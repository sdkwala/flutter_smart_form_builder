import 'package:flutter/material.dart';

InputDecoration buildDecoration(Map<String, dynamic> schema, {FocusNode? focusNode}) {
  final borderType = schema['border'] ?? 'underline';
  final borderRadius = BorderRadius.circular(schema['borderRadius']?.toDouble() ?? 4.0);
  final borderColor = schema['borderColor'] != null ? HexColor(schema['borderColor']) : Colors.grey;
  final focusedBorderColor = schema['focusedBorderColor'] != null ? HexColor(schema['focusedBorderColor']) : Colors.blue;

  final labelColor = (focusNode?.hasFocus ?? false) ? focusedBorderColor : borderColor;

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
    labelText: schema['labelText'],
    labelStyle: TextStyle(color: labelColor),
    hintText: schema['hintText'],
    helperText: schema['helperText'],
    counterText: schema['counterText'],
    filled: schema['filled'] ?? false,
    fillColor: schema['fillColor'] != null ? HexColor(schema['fillColor']) : null,
    prefixIcon: schema['prefixIcon'] != null ? Icon(getIconData(schema['prefixIcon'])) : null,
    suffixIcon: schema['suffixIcon'] != null ? Icon(getIconData(schema['suffixIcon'])) : null,
    border: getBorder(borderColor),
    focusedBorder: getBorder(focusedBorderColor),
    enabledBorder: getBorder(borderColor),
    disabledBorder: getBorder(borderColor),
  );
}



IconData getIconData(String name) {
  switch (name) {
    case 'email':
      return Icons.email;
    case 'lock':
      return Icons.lock;
    case 'check':
      return Icons.check;
    case 'person':
      return Icons.person;
    default:
      return Icons.help_outline;
  }
}

Color HexColor(String hex) {
  final hexCode = hex.replaceAll("#", "");
  return Color(int.parse("FF$hexCode", radix: 16));
}
