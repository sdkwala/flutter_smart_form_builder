import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../utils/decoration_builder.dart';

class SignaturePadFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const SignaturePadFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<SignaturePadFieldWidget> createState() => _SignaturePadFieldWidgetState();
}

class _SignaturePadFieldWidgetState extends State<SignaturePadFieldWidget> {
  late SignatureController _controller;
  String? _exportFormat;
  Color? _strokeColor;
  Color? _backgroundColor;

  @override
  void initState() {
    super.initState();
    _exportFormat = widget.schema['exportFormat'] ?? 'png';
    _strokeColor = widget.schema['strokeColor'] != null ? HexColor(widget.schema['strokeColor']) : Colors.black;
    _backgroundColor = widget.schema['backgroundColor'] != null ? HexColor(widget.schema['backgroundColor']) : Colors.white;
    _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: _strokeColor!,
      exportBackgroundColor: _backgroundColor!,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _exportSignature() async {
    if (_controller.isNotEmpty) {
      if (_exportFormat == 'svg') {
        final svg = await _controller.toSVG();
        widget.onChanged(widget.schema['key'], svg);
      } else {
        final Uint8List? data = await _controller.toPngBytes();
        if (data != null) {
          widget.onChanged(widget.schema['key'], data);
        }
      }
    }
  }

  void _clear() {
    setState(() => _controller.clear());
    widget.onChanged(widget.schema['key'], null);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.schema['label'] ?? widget.schema['key'];
    final decoration = buildDecoration(widget.schema);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: decoration,
          child: Column(
            children: [
              Container(
                color: _backgroundColor,
                height: 160,
                child: Signature(
                  controller: _controller,
                  backgroundColor: _backgroundColor!,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _clear,
                    child: const Text('Clear'),
                  ),
                  TextButton(
                    onPressed: _exportSignature,
                    child: Text('Save as ${_exportFormat?.toUpperCase()}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}