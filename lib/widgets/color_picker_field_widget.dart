import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_form_builder/utils/decoration_builder.dart';

class ColorPickerFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const ColorPickerFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<ColorPickerFieldWidget> createState() => _ColorPickerFieldWidgetState();
}

class _ColorPickerFieldWidgetState extends State<ColorPickerFieldWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Color? _selectedColor;
  bool _isValidHex = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    // Set initial value if provided
    final initialValue = widget.schema['defaultValue'];
    if (initialValue != null) {
      _controller.text = initialValue.toString();
      _selectedColor = _parseHexColor(initialValue.toString());
    }
    
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Color? _parseHexColor(String hex) {
    if (hex.isEmpty) return null;
    
    final hexCode = hex.replaceAll("#", "");
    if (hexCode.length == 6) {
      try {
        return Color(int.parse("FF$hexCode", radix: 16));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  bool _isValidHexColor(String hex) {
    if (hex.isEmpty) return true;
    final hexCode = hex.replaceAll("#", "");
    return RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hexCode);
  }

  void _onHexChanged(String value) {
    setState(() {
      _isValidHex = _isValidHexColor(value);
      if (_isValidHex && value.isNotEmpty) {
        _selectedColor = _parseHexColor(value);
      } else {
        _selectedColor = null;
      }
    });
    
    final keyName = widget.schema['key'];
    widget.onChanged(keyName, value);
  }

  void _onColorSwatchSelected(Color color) {
    final hexValue = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    _controller.text = hexValue;
    setState(() {
      _selectedColor = color;
      _isValidHex = true;
    });
    
    final keyName = widget.schema['key'];
    widget.onChanged(keyName, hexValue);
  }

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;
    final keyName = schema['key'];
    final label = (schema['label'] ?? keyName)?.toString() ?? '';
    final placeholder = schema['placeholder']?.toString() ?? '#FFFFFF';
    final validators = schema['validators'] ?? [];
    final customSwatches = schema['customSwatches'] ?? [];
    final showSwatches = schema['showSwatches'] ?? true;
    final maxSwatches = schema['maxSwatches'] ?? 12;

    // Default color swatches
    final defaultSwatches = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
    ];

    // Combine custom and default swatches
    final allSwatches = <Color>[];
    
    // Add custom swatches first
    for (final swatch in customSwatches) {
      if (swatch is String) {
        final color = _parseHexColor(swatch);
        if (color != null) allSwatches.add(color);
      }
    }
    
    // Add default swatches if we have room
    for (final swatch in defaultSwatches) {
      if (allSwatches.length < maxSwatches && !allSwatches.contains(swatch)) {
        allSwatches.add(swatch);
      }
    }

    final isFocused = _focusNode.hasFocus;

    final decoration = InputDecoration(
      labelText: label,
      hintText: placeholder,
      filled: schema['filled'] ?? false,
      fillColor: schema['fillColor'] != null ? HexColor(schema['fillColor']) : null,
      prefixIcon: schema['prefixIcon'] != null 
          ? Icon(getIconData(schema['prefixIcon'])) 
          : Icon(Icons.color_lens, color: _selectedColor),
      suffixIcon: _selectedColor != null 
          ? Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
            )
          : null,
      border: _getBorder(schema['border'], schema['borderColor'], schema['borderRadius']),
      enabledBorder: _getBorder(schema['border'], schema['borderColor'], schema['borderRadius']),
      focusedBorder: _getBorder(schema['border'], schema['focusedBorderColor'], schema['borderRadius']),
      labelStyle: TextStyle(
        color: isFocused
            ? HexColor(schema['focusedBorderColor'])
            : HexColor(schema['borderColor']),
      ),
      floatingLabelStyle: TextStyle(
        color: isFocused
            ? HexColor(schema['focusedBorderColor'])
            : HexColor(schema['borderColor']),
      ),
      errorText: !_isValidHex ? 'Invalid hex color format' : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: decoration,
          onChanged: _onHexChanged,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[#0-9A-Fa-f]')),
            LengthLimitingTextInputFormatter(7), // # + 6 hex digits
          ],
          validator: (val) {
            if (validators.contains('required') && (val == null || val.isEmpty)) {
              return 'This field is required';
            }
            if (val != null && val.isNotEmpty && !_isValidHexColor(val)) {
              return 'Invalid hex color format';
            }
            return null;
          },
        ),
        if (showSwatches && allSwatches.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Color Swatches',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allSwatches.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () => _onColorSwatchSelected(color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  InputBorder _getBorder(dynamic type, dynamic hexColor, dynamic radius) {
    final borderColor = hexColor != null ? HexColor(hexColor) : Colors.grey;
    final borderRadius = BorderRadius.circular((radius ?? 4).toDouble());

    if (type == 'outline') {
      return OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: borderColor));
    } else if (type == 'underline') {
      return UnderlineInputBorder(borderSide: BorderSide(color: borderColor));
    } else {
      return InputBorder.none;
    }
  }
} 