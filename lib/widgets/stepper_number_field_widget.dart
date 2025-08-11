import 'package:flutter/material.dart';
import '../utils/decoration_builder.dart';

class StepperNumberFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const StepperNumberFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<StepperNumberFieldWidget> createState() => _StepperNumberFieldWidgetState();
}

class _StepperNumberFieldWidgetState extends State<StepperNumberFieldWidget> {
  late int _value;
  late int _min;
  late int _max;
  late int _step;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _value = widget.schema['value'] is int ? widget.schema['value'] : int.tryParse(widget.schema['value']?.toString() ?? '') ?? 0;
    _min = widget.schema['min'] is int ? widget.schema['min'] : int.tryParse(widget.schema['min']?.toString() ?? '') ?? 0;
    _max = widget.schema['max'] is int ? widget.schema['max'] : int.tryParse(widget.schema['max']?.toString() ?? '') ?? 100;
    _step = widget.schema['step'] is int ? widget.schema['step'] : int.tryParse(widget.schema['step']?.toString() ?? '') ?? 1;
  }

  void _updateValue(int newValue) {
    if (newValue < _min || newValue > _max) return;
    setState(() {
      _value = newValue;
      _errorText = _validate(_value);
    });
    widget.onChanged(widget.schema['key'], _value);
  }

  String? _validate(int value) {
    final validation = widget.schema['validation'];
    if (validation is String && validation == 'required' && value == null) {
      return 'Required';
    }
    if (validation is Map<String, dynamic>) {
      if (validation['min'] != null && value < validation['min']) {
        return 'Minimum is ${validation['min']}';
      }
      if (validation['max'] != null && value > validation['max']) {
        return 'Maximum is ${validation['max']}';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.schema['label'] ?? widget.schema['key'];
    final decoration = buildDecoration(widget.schema);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: decoration.copyWith(errorText: _errorText),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _value > _min ? () => _updateValue(_value - _step) : null,
              ),
              Text('$_value', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _value < _max ? () => _updateValue(_value + _step) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 