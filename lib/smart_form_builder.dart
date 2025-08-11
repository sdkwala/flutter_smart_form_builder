import 'dart:convert';
import 'package:flutter/material.dart';
import 'themes/smart_form_theme.dart';
import 'models/step_model.dart';
import 'models/field_model.dart';
import 'builders/field_factory.dart';
import 'package:flutter/cupertino.dart';

/// Callback for form submission
typedef OnSubmit = void Function(Map<String, dynamic> data);
/// Callback for field value change
typedef OnFieldChange = void Function(String key, dynamic value);

/// The main SmartForm widget
class SmartForm extends StatefulWidget {
  final List<StepModel>? steps;
  final List<FieldModel>? fields;
  final Map<String, dynamic>? schema; // for backward compatibility
  final OnSubmit? onSubmit;
  final OnFieldChange? onFieldChange;
  final void Function(StepModel step, int index)? onStepChange;
  final void Function(List<FieldModel> fields, List<StepModel> steps)? onSchemaImport;
  final double fieldSpacing;


  const SmartForm({
    Key? key,
    this.steps,
    this.fields,
    this.schema,
    this.onSubmit,
    this.onFieldChange,
    this.onStepChange,
    this.onSchemaImport,
    this.fieldSpacing = 12,
  }) : super(key: key);

  @override
  State<SmartForm> createState() => _SmartFormState();
}

class SmartFormBuilder {
  static final Map<String, Widget Function(Map<String, dynamic>, void Function(String, dynamic))> _customFieldBuilders = {};

  static void registerFieldType(String type, Widget Function(Map<String, dynamic>, void Function(String, dynamic)) builder) {
    _customFieldBuilders[type] = builder;
  }

  static Widget? buildCustomField(String type, Map<String, dynamic> schema, void Function(String, dynamic) onChanged) {
    final builder = _customFieldBuilders[type];
    if (builder != null) {
      return builder(schema, onChanged);
    }
    return null;
  }
}

class _SmartFormState extends State<SmartForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;
  int _currentStep = 0;
  late List<StepModel> _steps;
  late List<FieldModel> _fields;

  @override
  void initState() {
    super.initState();
    _formData = {};
    _steps = widget.steps ?? [];
    _fields = widget.fields ?? [];
    // If schema is provided, parse and trigger onSchemaImport
    if (widget.schema != null) {
      // Use SchemaParser if available
      try {
        // ignore: import_of_legacy_library_into_null_safe
        // ignore: unused_local_variable
        final parser = (dynamic schema) => schema; // fallback
        // If you have SchemaParser, use it here
        // final parsedSteps = SchemaParser.parse(widget.schema!);
        // final parsedFields = SchemaParser.parseFields(widget.schema!);
        // _steps = parsedSteps;
        // _fields = parsedFields;
        // if (widget.onSchemaImport != null) widget.onSchemaImport!(parsedFields, parsedSteps);
      } catch (_) {}
    }
    if (widget.onSchemaImport != null) {
      widget.onSchemaImport!(_fields, _steps);
    }
  }

  bool _isFieldVisible(FieldModel field) {
    if (field.visibleWhen == null) return true;
    // Support single or multiple conditions
    if (field.visibleWhen is Map<String, dynamic>) {
      final cond = field.visibleWhen as Map<String, dynamic>;
      // If 'field' and 'value' keys, use them; else, treat as {key: value}
      if (cond.containsKey('field') && cond.containsKey('value')) {
        return _formData[cond['field']] == cond['value'];
      }
      // All conditions must match
      for (final entry in cond.entries) {
        if (_formData[entry.key] != entry.value) return false;
      }
      return true;
    }
    // If visibleWhen is a List of conditions
    if (field.visibleWhen is List) {
      for (final cond in field.visibleWhen as List) {
        if (cond is Map<String, dynamic>) {
          if (cond.containsKey('field') && cond.containsKey('value')) {
            if (_formData[cond['field']] != cond['value']) return false;
          } else {
            for (final entry in cond.entries) {
              if (_formData[entry.key] != entry.value) return false;
            }
          }
        }
      }
      return true;
    }
    return true;
  }

  void _onFieldChanged(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
    if (widget.onFieldChange != null) {
      widget.onFieldChange!(key, value);
    }
  }

  // List<Widget> _buildFields(List<FieldModel> fields, TextDirection textDirection, BuildContext context) {
  //   return fields.where(_isFieldVisible).map<Widget>((field) {
  //     final label = field.getLocalizedLabel(context);
  //     final placeholder = field.getLocalizedPlaceholder(context);
  //     return Directionality(
  //       textDirection: textDirection,
  //       child: Align(
  //         alignment: textDirection == TextDirection.rtl ? Alignment.centerRight : Alignment.centerLeft,
  //         child: FieldFactory.buildField({
  //           'type': field.type,
  //           'key': field.key,
  //           'label': label,
  //           'placeholder': placeholder,
  //           'validators': field.validators,
  //           'options': field.options,
  //           'localization': field.localization,
  //           'visibleWhen': field.visibleWhen,
  //           'extra': field.extra,
  //           'prefixIcon': field.prefixIcon,
  //           'suffixIcon': field.suffixIcon,
  //           'border': field.border,
  //           'borderRadius': field.borderRadius,
  //           'filled': field.filled,
  //           'borderColor': field.borderColor,
  //           'focusedBorderColor': field.focusedBorderColor,
  //           'fillColor': field.fillColor,
  //         }, _onFieldChanged),
  //       ),
  //     );
  //   }).toList();
  // }
  List<Widget> _buildFields(List<FieldModel> fields, TextDirection textDirection, BuildContext context) {
    List<Widget> widgets = [];
    final visibleFields = fields.where(_isFieldVisible).toList();

    for (int i = 0; i < visibleFields.length; i++) {
      final field = visibleFields[i];
      final label = field.getLocalizedLabel(context);
      final placeholder = field.getLocalizedPlaceholder(context);
      final fieldWidget = Directionality(
        textDirection: textDirection,
        child: Align(
          alignment: textDirection == TextDirection.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: FieldFactory.buildField({
            'type': field.type,
            'key': field.key,
            'label': label,
            'placeholder': placeholder,
            'validators': field.validators,
            'options': field.options,
            'localization': field.localization,
            'visibleWhen': field.visibleWhen,
            'extra': field.extra,
            'prefixIcon': field.prefixIcon,
            'suffixIcon': field.suffixIcon,
            'border': field.border,
            'borderRadius': field.borderRadius,
            'filled': field.filled,
            'borderColor': field.borderColor,
            'focusedBorderColor': field.focusedBorderColor,
            'fillColor': field.fillColor,
          }, _onFieldChanged),
        ),
      );
      widgets.add(fieldWidget);
      // Add spacing only if not last field
      if (i < visibleFields.length - 1) {
        widgets.add(SizedBox(height: widget.fieldSpacing));
      }
    }
    return widgets;
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
    if (widget.onStepChange != null && _steps.isNotEmpty) {
      widget.onStepChange!(_steps[step], step);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = SmartFormTheme.of(context);
    final locale = Localizations.localeOf(context);
    final isRTL = ["ar", "he", "fa", "ur"].contains(locale.languageCode);
    final textDirection = isRTL ? TextDirection.rtl : TextDirection.ltr;
    final isMultiStep = _steps.isNotEmpty;
    if (isMultiStep) {
      return Directionality(
        textDirection: textDirection,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Step ${_currentStep + 1} of ${_steps.length}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                minHeight: 4,
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_steps[_currentStep].title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _steps[_currentStep].title!,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ..._buildFields(_steps[_currentStep].fields, textDirection, context),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: () => _goToStep(_currentStep - 1),
                            child: const Text('Back'),
                          ),
                        if (_currentStep < _steps.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _goToStep(_currentStep + 1);
                              }
                            },
                            child: const Text('Next'),
                          ),
                        if (_currentStep == _steps.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (widget.onSubmit != null) {
                                  widget.onSubmit!(_formData);
                                }
                              }
                            },
                            child: const Text('Submit'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    // Single step fallback
    return Directionality(
      textDirection: textDirection,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildFields(_fields, textDirection, context),
              const SizedBox(height: 16),
              Align(
                alignment: textDirection == TextDirection.rtl ? Alignment.centerRight : Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(_formData);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Submit',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
