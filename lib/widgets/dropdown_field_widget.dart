import 'package:flutter/material.dart';

class DropdownFieldWidget extends StatelessWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const DropdownFieldWidget({
    Key? key,
    required this.schema,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyName = schema['key'];
    final label = schema['label'] ?? keyName;
    final validators = schema['validators'] ?? [];
    final options = schema['options'] ?? [];

    return DropdownButtonFormField<Object>(
      decoration: InputDecoration(labelText: label),
      items: options.map<DropdownMenuItem<Object>>((option) {
        return DropdownMenuItem<Object>(
          value: option['value'],
          child: Text(option['label'] ?? option['value'].toString()),
        );
      }).toList(),
      onChanged: (val) => onChanged(keyName, val),
      validator: (val) {
        if (validators.contains('required') && (val == null || val.toString().isEmpty)) {
          return 'Required';
        }
        return null;
      },
    );
  }
}
