import 'package:flutter/material.dart';

class StateCityPickerFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic)? onChanged;

  const StateCityPickerFieldWidget({Key? key, required this.schema, this.onChanged}) : super(key: key);

  @override
  State<StateCityPickerFieldWidget> createState() => _StateCityPickerFieldWidgetState();
}

class _StateCityPickerFieldWidgetState extends State<StateCityPickerFieldWidget> {
  String? selectedState;
  String? selectedCity;

  final states = {
    'us': ['California', 'Texas', 'New York'],
    'fr': ['Île-de-France', 'Provence'],
    'ar': ['Riyadh', 'Jeddah'],
  };
  final cities = {
    'California': ['Los Angeles', 'San Francisco'],
    'Texas': ['Houston', 'Dallas'],
    'New York': ['NYC', 'Buffalo'],
    'Île-de-France': ['Paris'],
    'Provence': ['Marseille'],
    'Riyadh': ['Riyadh City'],
    'Jeddah': ['Jeddah City'],
  };

  @override
  Widget build(BuildContext context) {
    final keyName = widget.schema['key'];
    final label = widget.schema['label'] ?? keyName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          hint: const Text('Select state'),
          value: selectedState,
          items: states.keys.map((state) => DropdownMenuItem(value: state, child: Text(state))).toList(),
          onChanged: (val) {
            setState(() {
              selectedState = val;
              selectedCity = null;
            });
          },
        ),
        if (selectedState != null)
          DropdownButton<String>(
            hint: const Text('Select city'),
            value: selectedCity,
            items: (states[selectedState] ?? []).map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
            onChanged: (val) {
              setState(() {
                selectedCity = val;
              });
              if (widget.onChanged != null) widget.onChanged!(keyName, {'state': selectedState, 'city': selectedCity});
            },
          ),
      ],
    );
  }
} 