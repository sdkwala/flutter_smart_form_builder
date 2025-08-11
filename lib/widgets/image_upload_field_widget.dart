import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/decoration_builder.dart';

class ImageUploadFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const ImageUploadFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<ImageUploadFieldWidget> createState() => _ImageUploadFieldWidgetState();
}

class _ImageUploadFieldWidgetState extends State<ImageUploadFieldWidget> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.schema['value'] != null && widget.schema['value'] is String && widget.schema['value'].toString().isNotEmpty) {
      _imageFile = File(widget.schema['value']);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);
      final maxSize = widget.schema['maxSize'];
      if (maxSize != null) {
        final sizeMB = await file.length() / (1024 * 1024);
        if (sizeMB > maxSize) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File too large. Max $maxSize MB allowed.')));
          return;
        }
      }
      setState(() => _imageFile = file);
      widget.onChanged(widget.schema['key'], file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.schema['label'] ?? widget.schema['key'];
    final decoration = buildDecoration(widget.schema);
    final source = widget.schema['source'] ?? 'both';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: decoration,
          child: Row(
            children: [
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Image.file(_imageFile!, width: 56, height: 56, fit: BoxFit.cover),
                ),
              Expanded(
                child: Row(
                  children: [
                    if (source == 'camera' || source == 'both')
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _pickImage(ImageSource.camera),
                        tooltip: 'Pick from camera',
                      ),
                    if (source == 'gallery' || source == 'both')
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: () => _pickImage(ImageSource.gallery),
                        tooltip: 'Pick from gallery',
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}