import 'package:flutter/material.dart';
import '../utils/decoration_builder.dart';
import 'package:intl/intl.dart';

class DateTimePickerFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const DateTimePickerFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<DateTimePickerFieldWidget> createState() => _DateTimePickerFieldWidgetState();
}

class _DateTimePickerFieldWidgetState extends State<DateTimePickerFieldWidget> {
  DateTime? _selectedDateTime;
  late DateTime _minDate;
  late DateTime _maxDate;
  late String _format;

  @override
  void initState() {
    super.initState();
    _format = widget.schema['format'] ?? 'yyyy-MM-dd HH:mm';
    _minDate = _parseDate(widget.schema['minDate']) ?? DateTime(1900);
    _maxDate = _parseDate(widget.schema['maxDate']) ?? DateTime(2100);
    _selectedDateTime = _parseDate(widget.schema['value']) ?? _parseDate(widget.schema['initialDateTime']) ?? DateTime.now();
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: _minDate,
      lastDate: _maxDate,
    );
    if (pickedDate == null) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );
    if (pickedTime == null) return;
    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() => _selectedDateTime = combined);
    final formatted = DateFormat(_format).format(combined);
    widget.onChanged(widget.schema['key'], formatted);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.schema['label'] ?? widget.schema['key'];
    final decoration = buildDecoration(widget.schema).copyWith(
      suffixIcon: IconButton(
        icon: const Icon(Icons.event),
        onPressed: _pickDateTime,
      ),
    );
    final displayValue = _selectedDateTime != null ? DateFormat(_format).format(_selectedDateTime!) : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDateTime,
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