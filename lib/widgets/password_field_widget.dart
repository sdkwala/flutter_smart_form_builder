// import 'package:flutter/material.dart';
//
// class PasswordFieldWidget extends StatefulWidget {
//   final Map<String, dynamic> schema;
//   final void Function(String, dynamic) onChanged;
//
//   const PasswordFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);
//
//   @override
//   State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
// }
//
// class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
//   bool _obscure = true;
//
//   @override
//   Widget build(BuildContext context) {
//     final keyName = widget.schema['key'];
//     final label = widget.schema['label'] ?? keyName;
//     final validators = widget.schema['validators'] ?? [];
//     final placeholder = widget.schema['placeholder'] ?? '';
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: label,
//         suffixIcon: IconButton(
//           icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
//           onPressed: () => setState(() => _obscure = !_obscure),
//         ),
//       ),
//       obscureText: _obscure,
//       onChanged: (val) => widget.onChanged(keyName, val),
//       validator: (val) {
//         if (validators.contains('required') && (val == null || val.isEmpty)) {
//           return 'Required';
//         }
//         final minLength = widget.schema['minLength'];
//         if (minLength != null && val != null && val.length < minLength) {
//           return 'Minimum $minLength characters';
//         }
//         return null;
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../utils/decoration_builder.dart';

class PasswordFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const PasswordFieldWidget({
    Key? key,
    required this.schema,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscure = true;
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
    _focusNode.removeListener(() {});
    _focusNode.dispose();
    super.dispose();
  }


  InputDecoration _buildDecoration(Map<String, dynamic> schema) {
    final borderType = schema['border'] ?? 'underline';
    final borderRadius = BorderRadius.circular(schema['borderRadius']?.toDouble() ?? 4.0);
    final borderColor = schema['borderColor'] != null ? HexColor(schema['borderColor']) : Colors.grey;
    final focusedBorderColor = schema['focusedBorderColor'] != null ? HexColor(schema['focusedBorderColor']) : Colors.blue;
    final fillColor = schema['fillColor'] != null ? HexColor(schema['fillColor']) : null;
    final labelColor = (_focusNode.hasFocus) ? focusedBorderColor : borderColor;

    InputBorder getBorder(Color color) {
      if (borderType == 'outline') {
        return OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: color),
        );
      } else if (borderType == 'underline') {
        return UnderlineInputBorder(borderSide: BorderSide(color: color));
      }
      return InputBorder.none;
    }

    return InputDecoration(
      labelText: schema['label'] ?? schema['key'],
      labelStyle: TextStyle(color: labelColor),
      hintText: schema['placeholder'],
      helperText: schema['helperText'],
      counterText: schema['counterText'],
      filled: schema['filled'] ?? false,
      fillColor: fillColor,
      prefixIcon: schema['prefixIcon'] != null ? Icon(getIconData(schema['prefixIcon'])) : null,
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      border: getBorder(borderColor),
      focusedBorder: getBorder(focusedBorderColor),
      enabledBorder: getBorder(borderColor),
      disabledBorder: getBorder(borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;
    final keyName = schema['key'];
    final validators = schema['validators'] ?? [];

    return TextFormField(
      focusNode: _focusNode,
      decoration: _buildDecoration(schema),
      obscureText: _obscure,
      onChanged: (val) => widget.onChanged(keyName, val),
      validator: (val) {
        if (validators.contains('required') && (val == null || val.isEmpty)) {
          return 'Required';
        }
        final minLength = schema['minLength'];
        if (minLength != null && val != null && val.length < minLength) {
          return 'Minimum $minLength characters';
        }
        return null;
      },
    );
  }
}

