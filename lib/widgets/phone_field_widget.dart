// import 'package:flutter/material.dart';
//
// class PhoneFieldWidget extends StatelessWidget {
//   final Map<String, dynamic> schema;
//   final void Function(String, dynamic) onChanged;
//
//   const PhoneFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final keyName = schema['key'];
//     final label = schema['label'] ?? keyName;
//     final validators = schema['validators'] ?? [];
//     return TextFormField(
//       decoration: InputDecoration(labelText: label),
//       keyboardType: TextInputType.phone,
//       onChanged: (val) => onChanged(keyName, val),
//       validator: (val) {
//         if (validators.contains('required') && (val == null || val.isEmpty)) {
//           return 'Required';
//         }
//         // Basic phone validation (can be improved or replaced with intl_phone_field)
//         if (val != null && val.isNotEmpty && !RegExp(r'^[0-9+\-() ]{7,}$').hasMatch(val)) {
//           return 'Invalid phone number';
//         }
//         return null;
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:smart_form_builder/utils/decoration_builder.dart';

class PhoneFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const PhoneFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<PhoneFieldWidget> createState() => _PhoneFieldWidgetState();
}

class _PhoneFieldWidgetState extends State<PhoneFieldWidget> {
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
    final label = schema['label'] ?? keyName;
    final placeholder = schema['placeholder'];
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
      keyboardType: TextInputType.phone,
      onChanged: (val) => widget.onChanged(keyName, val),
      validator: (val) {
        if (validators.contains('required') && (val == null || val.isEmpty)) {
          return 'Required';
        }
        if (val != null && val.isNotEmpty && !RegExp(r'^[0-9+\-() ]{7,}$').hasMatch(val)) {
          return 'Invalid phone number';
        }
        return null;
      },
    );
  }
}
