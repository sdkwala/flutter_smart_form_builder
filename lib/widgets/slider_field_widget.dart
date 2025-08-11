import 'package:flutter/material.dart';
import 'package:smart_form_builder/utils/decoration_builder.dart';

class SliderFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const SliderFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<SliderFieldWidget> createState() => _SliderFieldWidgetState();
}

class _SliderFieldWidgetState extends State<SliderFieldWidget> {
  double _value = 0;

  @override
  void initState() {
    super.initState();
    // Set initial value if provided
    final initialValue = widget.schema['defaultValue'];
    if (initialValue != null) {
      if (initialValue is int) {
        _value = initialValue.toDouble();
      } else if (initialValue is double) {
        _value = initialValue;
      } else if (initialValue is String) {
        _value = double.tryParse(initialValue) ?? 0;
      }
    } else {
      // Set to min value if no default
      final min = widget.schema['extra']?['min'] ?? 0;
      _value = (min is int) ? min.toDouble() : (min as double? ?? 0);
    }
  }

  void _onChanged(double value) {
    setState(() {
      _value = value;
    });
    
    final keyName = widget.schema['key'];
    widget.onChanged(keyName, value);
  }

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;
    final keyName = schema['key'];
    final label = (schema['label'] ?? keyName)?.toString() ?? '';
    final validators = schema['validators'] ?? [];
    final extra = schema['extra'] ?? {};
    
    final min = (extra['min'] ?? 0).toDouble();
    final max = (extra['max'] ?? 100).toDouble();
    final divisions = extra['divisions'];
    final showValue = extra['showValue'] ?? true;
    final valueLabel = extra['valueLabel'];
    final activeColor = schema['activeColor'] != null ? HexColor(schema['activeColor']) : Colors.blue;
    final inactiveColor = schema['inactiveColor'] != null ? HexColor(schema['inactiveColor']) : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: schema['filled'] ?? false 
                ? (schema['fillColor'] != null ? HexColor(schema['fillColor']) : Colors.grey.shade50)
                : null,
            borderRadius: BorderRadius.circular(schema['borderRadius'] ?? 8),
            border: schema['border'] == 'outline' 
                ? Border.all(
                    color: HexColor(schema['borderColor'] ?? '#E0E0E0'),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: activeColor,
                        inactiveTrackColor: inactiveColor,
                        thumbColor: activeColor,
                        overlayColor: activeColor.withOpacity(0.2),
                        valueIndicatorColor: activeColor,
                        valueIndicatorTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Slider(
                        value: _value,
                        min: min,
                        max: max,
                        divisions: divisions,
                        onChanged: _onChanged,
                        onChangeEnd: _onChanged,
                      ),
                    ),
                  ),
                  if (showValue) ...[
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        valueLabel != null 
                            ? valueLabel.replaceAll('{value}', _value.toStringAsFixed(divisions != null ? 0 : 1))
                            : _value.toStringAsFixed(divisions != null ? 0 : 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (divisions != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      min.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      max.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (validators.contains('required') && _value == 0) ...[
          const SizedBox(height: 4),
          Text(
            'This field is required',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
} 