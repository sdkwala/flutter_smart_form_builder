import 'dart:convert';
import '../models/step_model.dart';
import '../models/field_model.dart';

class SchemaParser {
  static List<StepModel> parse(dynamic schema, {String? locale}) {
    Map<String, dynamic> json;
    if (schema is String) {
      json = jsonDecode(schema);
    } else if (schema is Map<String, dynamic>) {
      json = schema;
    } else {
      throw ArgumentError('Schema must be a JSON string or Map');
    }
    final steps = (json['steps'] as List?) ?? [json];
    return steps.map((step) => StepModel.fromJson(step, locale: locale)).toList();
  }

  static List<FieldModel> parseFields(dynamic schema, {String? locale}) {
    Map<String, dynamic> json;
    if (schema is String) {
      json = jsonDecode(schema);
    } else if (schema is Map<String, dynamic>) {
      json = schema;
    } else {
      throw ArgumentError('Schema must be a JSON string or Map');
    }
    final fields = (json['fields'] as List?) ?? [];
    return fields.map((f) => FieldModel.fromJson(f, locale: locale)).toList();
  }
} 