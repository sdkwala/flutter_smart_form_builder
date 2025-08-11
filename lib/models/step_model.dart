import 'field_model.dart';

class StepModel {
  final String? title;
  final List<FieldModel> fields;

  StepModel({this.title, required this.fields});

  factory StepModel.fromJson(Map<String, dynamic> json, {String? locale}) {
    return StepModel(
      title: (locale != null && json['localization'] != null && json['localization'][locale] != null)
          ? json['localization'][locale]['title'] as String?
          : json['title'] as String?,
      fields: (json['fields'] as List)
          .map((f) => FieldModel.fromJson(f as Map<String, dynamic>, locale: locale))
          .toList(),
    );
  }
} 