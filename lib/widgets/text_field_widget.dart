import 'package:flutter/material.dart';
import 'package:smart_form_builder/utils/decoration_builder.dart';

class TextFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const TextFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   final schema = widget.schema;
  //   final keyName = schema['key'];
  //   final label = schema['label'] ?? keyName;
  //   final validators = schema['validators'] ?? [];
  //   final decoration = schema['decoration'] ?? {};
  //
  //   return TextFormField(
  //     focusNode: _focusNode,
  //     decoration: buildDecoration({...decoration, 'labelText': label}, focusNode: _focusNode),
  //     onChanged: (val) => widget.onChanged(keyName, val),
  //     validator: (val) {
  //       if (validators.contains('required') && (val == null || val.isEmpty)) {
  //         return 'This field is required';
  //       }
  //       final minLength = schema['minLength'];
  //       final maxLength = schema['maxLength'];
  //       if (minLength != null && val != null && val.length < minLength) {
  //         return 'Minimum $minLength characters';
  //       }
  //       if (maxLength != null && val != null && val.length > maxLength) {
  //         return 'Maximum $maxLength characters';
  //       }
  //       return null;
  //     },
  //   );
  // }
  InputBorder getBorder(dynamic type, dynamic hexColor, dynamic radius) {
    final borderColor = hexColor != null ? HexColor(hexColor) : Colors.grey;
    final borderRadius = BorderRadius.circular((radius ?? 4).toDouble());

    if (type == 'outline') {
      return OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: borderColor));
    } else if (type == 'underline') {
      return UnderlineInputBorder(borderSide: BorderSide(color: borderColor));
    } else {
      return InputBorder.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;
    final keyName = schema['key'];
    final label = (schema['label'] ?? keyName)?.toString() ?? '';
    final placeholder = schema['placeholder']?.toString() ?? '';
    final validators = schema['validators'] ?? [];

    final isFocused = _focusNode.hasFocus;

    final decoration = InputDecoration(
      labelText: label,
      hintText: placeholder,
      filled: schema['filled'] ?? false,
      fillColor: schema['fillColor'] != null ? HexColor(schema['fillColor']) : null,
      prefixIcon: schema['prefixIcon'] != null ? Icon(getIconData(schema['prefixIcon'])) : null,
      suffixIcon: schema['suffixIcon'] != null ? Icon(getIconData(schema['suffixIcon'])) : null,
      border: getBorder(schema['border'], schema['borderColor'], schema['borderRadius']),
      enabledBorder: getBorder(schema['border'], schema['borderColor'], schema['borderRadius']),
      focusedBorder: getBorder(schema['border'], schema['focusedBorderColor'], schema['borderRadius']),
      labelStyle: TextStyle(
        color: isFocused
            ? HexColor(schema['focusedBorderColor'])
            : HexColor(schema['borderColor']),
      ),
      floatingLabelStyle: TextStyle(
        color: isFocused
            ? HexColor(schema['focusedBorderColor'])
            : HexColor(schema['borderColor']),
      ),
    );


    return TextFormField(
      focusNode: _focusNode,
      decoration: decoration,
      onChanged: (val) => widget.onChanged(keyName, val),
      validator: (val) {
        if (validators.contains('required') && (val == null || val.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

}