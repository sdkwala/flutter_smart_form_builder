import 'package:flutter/material.dart';

// class FieldModel {
//   final String type;
//   final String key;
//   final dynamic label; // Can be String or Map<String, String>
//   final dynamic placeholder; // Can be String or Map<String, String>
//   final List<String> validators;
//   final List<Map<String, dynamic>>? options;
//   final Map<String, dynamic>? localization;
//   final Map<String, dynamic>? visibleWhen;
//   final Map<String, dynamic>? decoration;
//   final Map<String, dynamic>? extra;
//
//   FieldModel({
//     required this.type,
//     required this.key,
//     this.label,
//     this.placeholder,
//     this.validators = const [],
//     this.options,
//     this.localization,
//     this.visibleWhen,
//     this.decoration,
//     this.extra,
//   });
//
//   String? getLocalizedLabel(BuildContext context) {
//     final locale = Localizations.localeOf(context).languageCode;
//     if (label is Map<String, dynamic>) {
//       return label[locale] ?? label['en'] ?? label.values.first;
//     }
//     return label as String?;
//   }
//
//   String? getLocalizedPlaceholder(BuildContext context) {
//     final locale = Localizations.localeOf(context).languageCode;
//     if (placeholder is Map<String, dynamic>) {
//       return placeholder[locale] ?? placeholder['en'] ?? placeholder.values.first;
//     }
//     return placeholder as String?;
//   }
//
//   factory FieldModel.fromJson(Map<String, dynamic> json, {String? locale}) {
//     dynamic localizedField(dynamic value) {
//       if (value is Map && locale != null) {
//         return value[locale] ?? value['en'] ?? value.values.first;
//       }
//       return value;
//     }
//     return FieldModel(
//       type: json['type'],
//       key: json['key'],
//       label: json['label'],
//       placeholder: json['placeholder'],
//       validators: List<String>.from(json['validators'] ?? []),
//       options: (json['options'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList(),
//       localization: json['localization'],
//       visibleWhen: json['visibleWhen'],
//       decoration: json['decoration'],
//       extra: json['extra'],
//     );
//   }
// }


class FieldModel {
  final String type;
  final String key;
  final dynamic label;
  final dynamic placeholder;
  final List<String> validators;
  final List<Map<String, dynamic>>? options;
  final Map<String, dynamic>? localization;
  final Map<String, dynamic>? visibleWhen;
  final Map<String, dynamic>? extra;

  // 🎯 TextField-style decoration properties
  final String? prefixIcon;
  final String? suffixIcon;
  final String? border;
  final int? borderRadius;
  final bool? filled;
  final String? borderColor;
  final String? focusedBorderColor;
  final String? fillColor;

  // 🆕 Radio/Checkbox/Switch styling props
  final String? activeColor;
  final String? tileColor;
  final String? selectedTileColor;
  final String? shape; // like 'circle', 'rounded'
  final double? contentPadding;
  final double? visualDensity; // we'll convert this to proper VisualDensity
  final bool? isDense;

  FieldModel({
    required this.type,
    required this.key,
    this.label,
    this.placeholder,
    this.validators = const [],
    this.options,
    this.localization,
    this.visibleWhen,
    this.extra,
    // For TextField-style widgets
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.borderRadius,
    this.filled,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    // For selection controls (checkbox/radio/switch)
    this.activeColor,
    this.tileColor,
    this.selectedTileColor,
    this.shape,
    this.contentPadding,
    this.visualDensity,
    this.isDense,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json, {String? locale}) {
    return FieldModel(
      type: json['type'],
      key: json['key'],
      label: json['label'],
      placeholder: json['placeholder'],
      validators: List<String>.from(json['validators'] ?? []),
      options: (json['options'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList(),
      localization: json['localization'],
      visibleWhen: json['visibleWhen'],
      extra: json['extra'],
      prefixIcon: json['prefixIcon'],
      suffixIcon: json['suffixIcon'],
      border: json['border'],
      borderRadius: json['borderRadius'],
      filled: json['filled'],
      borderColor: json['borderColor'],
      focusedBorderColor: json['focusedBorderColor'],
      fillColor: json['fillColor'],
      activeColor: json['activeColor'],
      tileColor: json['tileColor'],
      selectedTileColor: json['selectedTileColor'],
      shape: json['shape'],
      contentPadding: (json['contentPadding'] is num) ? (json['contentPadding'] as num).toDouble() : null,
      visualDensity: (json['visualDensity'] is num) ? (json['visualDensity'] as num).toDouble() : null,
      isDense: json['isDense'],
    );
  }

  String? getLocalizedLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (label is Map<String, dynamic>) {
      return label[locale] ?? label['en'] ?? label.values.first;
    }
    return label as String?;
  }

  String? getLocalizedPlaceholder(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (placeholder is Map<String, dynamic>) {
      return placeholder[locale] ?? placeholder['en'] ?? placeholder.values.first;
    }
    return placeholder as String?;
  }
}


// class FieldModel {
//   final String type;
//   final String key;
//   final dynamic label;
//   final dynamic placeholder;
//   final List<String> validators;
//   final List<Map<String, dynamic>>? options;
//   final Map<String, dynamic>? localization;
//   final Map<String, dynamic>? visibleWhen;
//   final Map<String, dynamic>? extra;
//
//   // 🎯 These are new flattened decoration fields
//   final String? prefixIcon;
//   final String? suffixIcon;
//   final String? border;
//   final int? borderRadius;
//   final bool? filled;
//   final String? borderColor;
//   final String? focusedBorderColor;
//   final String? fillColor;
//
//   FieldModel({
//     required this.type,
//     required this.key,
//     this.label,
//     this.placeholder,
//     this.validators = const [],
//     this.options,
//     this.localization,
//     this.visibleWhen,
//     this.extra,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.border,
//     this.borderRadius,
//     this.filled,
//     this.borderColor,
//     this.focusedBorderColor,
//     this.fillColor,
//   });
//
//   factory FieldModel.fromJson(Map<String, dynamic> json, {String? locale}) {
//     return FieldModel(
//       type: json['type'],
//       key: json['key'],
//       label: json['label'],
//       placeholder: json['placeholder'],
//       validators: List<String>.from(json['validators'] ?? []),
//       options: (json['options'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList(),
//       localization: json['localization'],
//       visibleWhen: json['visibleWhen'],
//       extra: json['extra'],
//       prefixIcon: json['prefixIcon'],
//       suffixIcon: json['suffixIcon'],
//       border: json['border'],
//       borderRadius: json['borderRadius'],
//       filled: json['filled'],
//       borderColor: json['borderColor'],
//       focusedBorderColor: json['focusedBorderColor'],
//       fillColor: json['fillColor'],
//     );
//   }
//
//   String? getLocalizedLabel(BuildContext context) {
//     final locale = Localizations.localeOf(context).languageCode;
//     if (label is Map<String, dynamic>) {
//       return label[locale] ?? label['en'] ?? label.values.first;
//     }
//     return label as String?;
//   }
//
//   String? getLocalizedPlaceholder(BuildContext context) {
//     final locale = Localizations.localeOf(context).languageCode;
//     if (placeholder is Map<String, dynamic>) {
//       return placeholder[locale] ?? placeholder['en'] ?? placeholder.values.first;
//     }
//     return placeholder as String?;
//   }
// }
