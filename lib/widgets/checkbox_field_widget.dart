import 'package:flutter/material.dart';

class CheckboxFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const CheckboxFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<CheckboxFieldWidget> createState() => _CheckboxFieldWidgetState();
}

class _CheckboxFieldWidgetState extends State<CheckboxFieldWidget> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final keyName = widget.schema['key'];
    final label = widget.schema['label'] ?? keyName;
    final validators = widget.schema['validators'] ?? [];
    return CheckboxListTile(
      title: Text(label),
      value: _value,
      onChanged: (val) {
        setState(() => _value = val ?? false);
        widget.onChanged(keyName, _value);
      },
      controlAffinity: ListTileControlAffinity.leading,
      subtitle: validators.contains('required') && !_value ? const Text('Required', style: TextStyle(color: Colors.red)) : null,
    );
  }
} 