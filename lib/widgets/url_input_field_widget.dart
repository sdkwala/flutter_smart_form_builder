import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_form_builder/utils/decoration_builder.dart';

class UrlInputFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const UrlInputFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<UrlInputFieldWidget> createState() => _UrlInputFieldWidgetState();
}

class _UrlInputFieldWidgetState extends State<UrlInputFieldWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isValidUrl = true;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    // Set initial value if provided
    final initialValue = widget.schema['defaultValue'];
    if (initialValue != null) {
      _controller.text = initialValue.toString();
      _validateUrl(initialValue.toString());
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

  bool _isValidUrlFormat(String url) {
    if (url.isEmpty) return true;
    
    // URL regex pattern
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      caseSensitive: false,
    );
    
    return urlPattern.hasMatch(url);
  }

  void _validateUrl(String url) {
    setState(() {
      if (url.isEmpty) {
        _isValidUrl = true;
        _validationMessage = null;
      } else if (!_isValidUrlFormat(url)) {
        _isValidUrl = false;
        _validationMessage = 'Please enter a valid URL (e.g., https://example.com)';
      } else {
        _isValidUrl = true;
        _validationMessage = null;
      }
    });
  }

  void _onUrlChanged(String value) {
    _validateUrl(value);
    
    final keyName = widget.schema['key'];
    widget.onChanged(keyName, value);
  }

  String? _getValidator(String? value) {
    final validators = widget.schema['validators'] ?? [];
    
    if (validators.contains('required') && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    
    if (value != null && value.isNotEmpty && !_isValidUrlFormat(value)) {
      return 'Please enter a valid URL (e.g., https://example.com)';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;
    final keyName = schema['key'];
    final label = (schema['label'] ?? keyName)?.toString() ?? '';
    final placeholder = schema['placeholder']?.toString() ?? 'https://example.com';
    final validators = schema['validators'] ?? [];
    final showProtocolHint = schema['showProtocolHint'] ?? true;
    final allowedProtocols = schema['allowedProtocols'] ?? ['http', 'https'];
    final autoAddProtocol = schema['autoAddProtocol'] ?? false;

    final isFocused = _focusNode.hasFocus;

    final decoration = InputDecoration(
      labelText: label,
      hintText: placeholder,
      filled: schema['filled'] ?? false,
      fillColor: schema['fillColor'] != null ? HexColor(schema['fillColor']) : null,
      prefixIcon: schema['prefixIcon'] != null 
          ? Icon(getIconData(schema['prefixIcon'])) 
          : Icon(Icons.link, color: _isValidUrl ? Colors.green : Colors.red),
      suffixIcon: _controller.text.isNotEmpty
          ? IconButton(
              icon: Icon(
                _isValidUrl ? Icons.check_circle : Icons.error,
                color: _isValidUrl ? Colors.green : Colors.red,
              ),
              onPressed: null,
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
      errorText: _validationMessage,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: decoration,
          onChanged: _onUrlChanged,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            if (autoAddProtocol)
              FilteringTextInputFormatter.deny(RegExp(r'^[^hH]')),
          ],
          validator: _getValidator,
          onFieldSubmitted: (value) {
            if (autoAddProtocol && value.isNotEmpty && !value.startsWith('http')) {
              final newValue = 'https://$value';
              _controller.text = newValue;
              _onUrlChanged(newValue);
            }
          },
        ),
        if (showProtocolHint) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Supported protocols: ${allowedProtocols.join(', ')}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
        if (autoAddProtocol) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.auto_fix_high, size: 16, color: Colors.blue.shade600),
              const SizedBox(width: 4),
              Text(
                'Protocol will be automatically added if missing',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade600,
                ),
              ),
            ],
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