import 'package:flutter/material.dart';

class MultilineTextFieldWidget extends StatelessWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic)? onChanged;

  const MultilineTextFieldWidget({Key? key, required this.schema, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyName = schema['key'];
    final label = schema['label'] ?? keyName;
    final placeholder = schema['placeholder'] ?? '';
    final validators = schema['validators'] ?? [];
    return TextFormField(
      decoration: InputDecoration(labelText: label, hintText: placeholder),
      maxLines: null,
      minLines: 3,
      onChanged: onChanged != null ? (val) => onChanged!(keyName, val) : null,
      validator: (val) {
        if (validators.contains('required') && (val == null || val.isEmpty)) {
          return 'Required';
        }
        return null;
      },
    );
  }
} 