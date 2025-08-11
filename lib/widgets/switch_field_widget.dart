import 'package:flutter/material.dart';

class SwitchFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const SwitchFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<SwitchFieldWidget> createState() => _SwitchFieldWidgetState();
}

class _SwitchFieldWidgetState extends State<SwitchFieldWidget> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final keyName = widget.schema['key'];
    final label = widget.schema['label'] ?? keyName;
    return SwitchListTile(
      title: Text(label),
      value: _value,
      onChanged: (val) {
        setState(() => _value = val);
        widget.onChanged(keyName, _value);
      },
    );
  }
} 