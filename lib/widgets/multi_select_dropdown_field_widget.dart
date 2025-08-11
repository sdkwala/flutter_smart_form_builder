import 'package:flutter/material.dart';

class MultiSelectDropdownFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic)? onChanged;

  const MultiSelectDropdownFieldWidget({Key? key, required this.schema, this.onChanged}) : super(key: key);

  @override
  State<MultiSelectDropdownFieldWidget> createState() => _MultiSelectDropdownFieldWidgetState();
}

class _MultiSelectDropdownFieldWidgetState extends State<MultiSelectDropdownFieldWidget> {
  List selectedValues = [];

  @override
  Widget build(BuildContext context) {
    final keyName = widget.schema['key'];
    final label = widget.schema['label'] ?? keyName;
    final options = widget.schema['options'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        InkWell(
          onTap: () async {
            final result = await showDialog<List>(
              context: context,
              builder: (ctx) {
                List tempSelected = List.from(selectedValues);
                return AlertDialog(
                  title: Text(label),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView(
                      shrinkWrap: true,
                      children: options.map<Widget>((option) {
                        final value = option['value'];
                        return CheckboxListTile(
                          value: tempSelected.contains(value),
                          title: Text(option['label'] ?? value.toString()),
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                tempSelected.add(value);
                              } else {
                                tempSelected.remove(value);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, tempSelected),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            if (result != null) {
              setState(() => selectedValues = result);
              if (widget.onChanged != null) widget.onChanged!(keyName, selectedValues);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(selectedValues.isEmpty ? 'Select...' : selectedValues.join(', ')),
          ),
        ),
      ],
    );
  }
} 