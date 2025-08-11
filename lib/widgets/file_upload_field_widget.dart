import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/decoration_builder.dart';

class FileUploadFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic) onChanged;

  const FileUploadFieldWidget({Key? key, required this.schema, required this.onChanged}) : super(key: key);

  @override
  State<FileUploadFieldWidget> createState() => _FileUploadFieldWidgetState();
}

class _FileUploadFieldWidgetState extends State<FileUploadFieldWidget> {
  String? _fileName;
  String? _filePath;

  Future<void> _pickFile() async {
    final allowedExtensions = widget.schema['allowedExtensions'] != null
        ? List<String>.from(widget.schema['allowedExtensions'])
        : null;
    final fileType = widget.schema['fileType'] ?? 'any';
    final result = await FilePicker.platform.pickFiles(
      type: fileType == 'any'
          ? FileType.any
          : fileType == 'image'
              ? FileType.image
              : fileType == 'video'
                  ? FileType.video
                  : fileType == 'media'
                      ? FileType.media
                      : fileType == 'custom' && allowedExtensions != null
                          ? FileType.custom
                          : FileType.any,
      allowedExtensions: allowedExtensions,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final maxSize = widget.schema['maxSize'];
      if (maxSize != null) {
        final sizeMB = await file.length() / (1024 * 1024);
        if (sizeMB > maxSize) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File too large. Max $maxSize MB allowed.')));
          return;
        }
      }
      setState(() {
        _fileName = result.files.single.name;
        _filePath = file.path;
      });
      widget.onChanged(widget.schema['key'], file.path);
    }
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
          child: Row(
            children: [
              Expanded(
                child: Text(_fileName ?? 'No file selected', overflow: TextOverflow.ellipsis),
              ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: _pickFile,
                tooltip: 'Pick file',
              ),
            ],
          ),
        ),
      ],
    );
  }
}