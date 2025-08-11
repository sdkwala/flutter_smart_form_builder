import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:smart_form_builder/smart_form_builder.dart';
import 'package:smart_form_builder/exporters/schema_parser.dart';
import 'package:smart_form_builder/models/field_model.dart';
import 'package:smart_form_builder/models/step_model.dart';
import 'package:smart_form_builder/builders/field_factory.dart';

void main() {
  group('JSON schema parsing', () {
    test('parses valid schema into StepModel and FieldModel', () {
      final schema = {
        "steps": [
          {
            "title": "Step 1",
            "fields": [
              {"type": "text", "key": "name", "label": "Name"},
              {"type": "dropdown", "key": "gender", "label": "Gender", "options": [{"value": "m", "label": "M"}]}
            ]
          }
        ]
      };
      final steps = SchemaParser.parse(schema);
      expect(steps, isA<List<StepModel>>());
      expect(steps.first.fields.length, 2);
      expect(steps.first.fields.first, isA<FieldModel>());
      expect(steps.first.fields.first.type, 'text');
      expect(steps.first.fields[1].type, 'dropdown');
    });
  });

  group('Field validation', () {
    testWidgets('required field validation', (tester) async {
      final field = FieldModel(
        type: 'text',
        key: 'name',
        label: 'Name',
        validators: ['required'],
      );
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TextFormField(
            validator: (val) => field.validators.contains('required') && (val == null || val.isEmpty) ? 'Required' : null,
          ),
        ),
      ));
      expect(find.byType(TextFormField), findsOneWidget);
      final formField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(formField.validator!(null), 'Required');
      expect(formField.validator!(''), 'Required');
      expect(formField.validator!('ok'), null);
    });

    testWidgets('minLength and maxLength validation', (tester) async {
      final field = FieldModel(
        type: 'text',
        key: 'username',
        label: 'Username',
        validators: ['required'],
        extra: {'minLength': 3, 'maxLength': 5},
      );
      String? validator(String? val) {
        if (field.validators.contains('required') && (val == null || val.isEmpty)) return 'Required';
        if (field.extra?['minLength'] != null && val != null && val.length < field.extra!['minLength']) return 'Too short';
        if (field.extra?['maxLength'] != null && val != null && val.length > field.extra!['maxLength']) return 'Too long';
        return null;
      }
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TextFormField(validator: validator),
        ),
      ));
      final formField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(formField.validator!('ab'), 'Too short');
      expect(formField.validator!('abcdef'), 'Too long');
      expect(formField.validator!('abcd'), null);
    });
  });

  group('Conditional visibility', () {
    test('visibleWhen logic', () {
      final field = FieldModel(
        type: 'text',
        key: 'nickname',
        label: 'Nickname',
        visibleWhen: {'gender': 'male'},
      );
      // Simulate form data
      Map<String, dynamic> formData = {'gender': 'male'};
      bool isVisible = field.visibleWhen == null || formData[field.visibleWhen!.keys.first] == field.visibleWhen!.values.first;
      expect(isVisible, isTrue);
      formData = {'gender': 'female'};
      isVisible = field.visibleWhen == null || formData[field.visibleWhen!.keys.first] == field.visibleWhen!.values.first;
      expect(isVisible, isFalse);
    });
  });

  group('Dynamic rendering', () {
    testWidgets('renders correct widget for type', (tester) async {
      final fieldText = FieldModel(type: 'text', key: 'name', label: 'Name');
      final fieldDropdown = FieldModel(type: 'dropdown', key: 'gender', label: 'Gender', options: [
        {'value': 'm', 'label': 'M'},
        {'value': 'f', 'label': 'F'}
      ]);
      Widget buildField(FieldModel field) => MaterialApp(
        home: Material(
          child: FieldFactory.buildField({
            'type': field.type,
            'key': field.key,
            'label': field.label,
            'options': field.options,
          }, (k, v) {}),
        ),
      );
      await tester.pumpWidget(buildField(fieldText));
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.pumpWidget(buildField(fieldDropdown));
      expect(find.byType(DropdownButtonFormField), findsOneWidget);
    });
  });
}
