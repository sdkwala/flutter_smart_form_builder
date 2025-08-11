import 'package:flutter/material.dart';
import '../utils/decoration_builder.dart';
import 'package:intl/intl.dart';

class TimePickerFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const TimePickerFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<TimePickerFieldWidget> createState() => _TimePickerFieldWidgetState();
}

class _TimePickerFieldWidgetState extends State<TimePickerFieldWidget> {
  late TimeOfDay? _selectedTime;
  late String _format; // '24' or '12'

  @override
  void initState() {
    super.initState();
    _format = widget.schema['format']?.toString() ?? '24';
    _selectedTime = _parseTime(widget.schema['value']) ?? _parseTime(widget.schema['initialTime']) ?? TimeOfDay.now();
  }

  TimeOfDay? _parseTime(dynamic value) {
    if (value == null) return null;
    if (value is TimeOfDay) return value;
    if (value is String && value.isNotEmpty) {
      try {
        final parts = value.split(':');
        if (parts.length >= 2) {
          return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: _format == '24'),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
      final formatted = _formatTime(picked);
      widget.onChanged(widget.schema['key'], formatted);
    }
  }

  String _formatTime(TimeOfDay time) {
    final dt = DateTime(0, 1, 1, time.hour, time.minute);
    if (_format == '12') {
      return DateFormat('hh:mm a').format(dt);
    } else {
      return DateFormat('HH:mm').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.schema['label'] ?? widget.schema['key'];
    final decoration = buildDecoration(widget.schema).copyWith(
      suffixIcon: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: _pickTime,
      ),
    );
    final displayValue = _selectedTime != null ? _formatTime(_selectedTime!) : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickTime,
          child: AbsorbPointer(
            child: TextFormField(
              decoration: decoration,
              controller: TextEditingController(text: displayValue),
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }
} 