# 📦 smart_form_builder
[![Pub Version](https://img.shields.io/pub/v/smart_form_builder.svg)](https://pub.dev/packages/smart_form_builder)
[![Pub Likes](https://img.shields.io/pub/likes/smart_form_builder)](https://pub.dev/packages/smart_form_builder/score)
[![Pub Points](https://img.shields.io/pub/points/smart_form_builder)](https://pub.dev/packages/smart_form_builder/score)
[![Popularity](https://img.shields.io/pub/popularity/smart_form_builder)](https://pub.dev/packages/smart_form_builder/score)
[![Pub Downloads](https://img.shields.io/pub/dm/smart_form_builder)](https://pub.dev/packages/smart_form_builder)
[![GitHub Stars](https://img.shields.io/github/stars/sdkwala/flutter_smart_form_builder)](https://github.com/sdkwala/flutter_smart_form_builder)
[![GitHub Downloads](https://img.shields.io/github/downloads/sdkwala/flutter_smart_form_builder/total)](https://github.com/sdkwala/flutter_smart_form_builder/releases)
[![License](https://img.shields.io/github/license/sdkwala/flutter_smart_form_builder)](https://github.com/sdkwala/flutter_smart_form_builder/blob/master/LICENSE)
A **Flutter SDK package** to build dynamic, multi-step, multilingual forms using JSON schemas — with full customization, plugin support, and drag-and-drop visual editing.  
This is **not a standalone app**, but a reusable **component library** that other Flutter apps can import and use.

---

## ✨ Key Features

### 🛠 Built-in Field Types
- Text, Multiline, Email, Phone, Password
- Dropdown, Multi-Select, Country/State/City picker
- Checkbox, Radio, Switch, Slider, Stepper
- Date, Time, DateTime picker
- File/Image upload, Signature pad
- Color picker, Rating, Currency, HTML editor

### 🌍 Language & RTL Support
- Fully multilingual (labels, placeholders, error messages)
- RTL-ready for Arabic/Hebrew
- JSON schema supports localized text
- Auto adjusts alignment based on locale

### 🎨 High Customization
- Theming with `SmartFormTheme`
- Per-field styles via JSON
- Custom validators (sync/async)
- Conditional logic for field visibility
- Plugin support for external data sources & custom fields

### 🧩 Multi-Step Form Wizard
- Break long forms into steps
- Progress indicator (linear, circle, number)
- Step-by-step validation

---

## 📦 Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  smart_form_builder: ^0.1.0
```

## ⚡ Quick Start

```dart
import 'package:smart_form_builder/smart_form_builder.dart';
import 'package:smart_form_builder/models/field_model.dart';


List<FieldModel> get allFields => [
    // === Basic Info ===
    FieldModel(
      type: 'text',
      key: 'name',
      label: 'Full Name',
      placeholder: 'Enter your full name',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'person',
    ),
    FieldModel(
      type: 'multiline_text',
      key: 'street_address',
      label: 'Biography',
      placeholder: 'Tell us about yourself...',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      extra: {
        'maxLines': 5,
        'showCharacterCount': true,
        'maxLength': 500,
      },
    ),
    FieldModel(
      type: 'email',
      key: 'email',
      label: 'Email Address',
      placeholder: 'your.email@example.com',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'email',
    ),
]

SmartForm(
    fields: allFields,
    onSubmit: (data) => print(data),
    onFieldChange: (key, value) => print('$key = $value'),
    fieldSpacing: 16,
),
```

📂 Full Example  
For a complete working example with multiple field types, custom themes, and step-by-step forms, check out:  
👉 [Full Example on GitHub](https://github.com/sdkwala/flutter_smart_form_builder/tree/main/example)

### License
MIT

### Author
sdkwala.com