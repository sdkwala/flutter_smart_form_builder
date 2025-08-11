import 'package:flutter/material.dart';

class RadioGroupFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const RadioGroupFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<RadioGroupFieldWidget> createState() => _RadioGroupFieldWidgetState();
}

class _RadioGroupFieldWidgetState extends State<RadioGroupFieldWidget> {
  dynamic _selected;

  @override
  Widget build(BuildContext context) {
    final keyName = widget.schema['key'];
    final label = widget.schema['label'] ?? keyName;
    final validators = widget.schema['validators'] ?? [];
    final options = widget.schema['options'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        ...options.map<Widget>((option) => RadioListTile(
              title: Text(option['label'] ?? option['value'].toString()),
              value: option['value'],
              groupValue: _selected,
              onChanged: (val) {
                setState(() => _selected = val);
                widget.onChanged(keyName, val);
              },
            )),
        if (validators.contains('required') && _selected == null)
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text('Required', style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
} 