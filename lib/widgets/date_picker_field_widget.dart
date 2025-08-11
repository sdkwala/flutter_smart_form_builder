import 'package:flutter/material.dart';
import '../utils/decoration_builder.dart';
import 'package:intl/intl.dart';

class DatePickerFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const DatePickerFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<DatePickerFieldWidget> createState() => _DatePickerFieldWidgetState();
}

class _DatePickerFieldWidgetState extends State<DatePickerFieldWidget> {
  late DateTime? _selectedDate;
  late DateTime _minDate;
  late DateTime _maxDate;
  late String _format;

  @override
  void initState() {
    super.initState();
    _format = widget.schema['format'] ?? 'yyyy-MM-dd';
    _minDate = _parseDate(widget.schema['minDate']) ?? DateTime(1900);
    _maxDate = _parseDate(widget.schema['maxDate']) ?? DateTime(2100);
    _selectedDate = _parseDate(widget.schema['value']) ?? _parseDate(widget.schema['initialDate']) ?? DateTime.now();
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

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: _minDate,
      lastDate: _maxDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      final formatted = DateFormat(_format).format(picked);
      widget.onChanged(widget.schema['key'], formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.schema['label'] ?? widget.schema['key'];
    final decoration = buildDecoration(widget.schema).copyWith(
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: _pickDate,
      ),
    );
    final displayValue = _selectedDate != null ? DateFormat(_format).format(_selectedDate!) : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
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