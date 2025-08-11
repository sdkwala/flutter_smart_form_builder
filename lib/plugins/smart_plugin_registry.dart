import 'package:flutter/cupertino.dart';

typedef ValidatorFunction = String? Function(dynamic value, Map<String, dynamic> fieldSchema);
typedef DataProviderFunction = Future<List<Map<String, dynamic>>> Function(Map<String, dynamic> fieldSchema);
typedef FieldBuilderFunction = Widget Function(Map<String, dynamic> fieldSchema, void Function(String, dynamic) onChanged);

class SmartPluginRegistry {
  static final Map<String, ValidatorFunction> customValidators = {};
  static final Map<String, DataProviderFunction> dataProviders = {};
  static final Map<String, FieldBuilderFunction> fieldBuilders = {};

  static void registerValidator(String name, ValidatorFunction validator) {
    customValidators[name] = validator;
  }

  static void registerDataProvider(String name, DataProviderFunction provider) {
    dataProviders[name] = provider;
  }

  static void registerFieldBuilder(String type, FieldBuilderFunction builder) {
    fieldBuilders[type] = builder;
  }
} 