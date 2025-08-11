import 'package:flutter/material.dart';
import '../widgets/stepper_number_field_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/email_field_widget.dart';
import '../widgets/dropdown_field_widget.dart';
import '../widgets/phone_field_widget.dart';
import '../widgets/password_field_widget.dart';
import '../widgets/checkbox_field_widget.dart';
import '../widgets/radio_group_field_widget.dart';
import '../widgets/switch_field_widget.dart';
import '../widgets/multiline_text_field_widget.dart';
import '../widgets/multi_select_dropdown_field_widget.dart';
import '../widgets/country_picker_field_widget.dart';
import '../widgets/state_city_picker_field_widget.dart';
import '../widgets/date_picker_field_widget.dart';
import '../widgets/time_picker_field_widget.dart';
import '../widgets/datetime_picker_field_widget.dart';
import '../widgets/image_upload_field_widget.dart';
import '../widgets/file_upload_field_widget.dart';
import '../widgets/signature_pad_field_widget.dart';
import '../widgets/color_picker_field_widget.dart';
import '../widgets/rating_field_widget.dart';
import '../widgets/url_input_field_widget.dart';
import '../widgets/slider_field_widget.dart';

// Import other field widgets as you implement them

class FieldFactory {
  static Widget buildField(Map<String, dynamic> fieldSchema, void Function(String, dynamic) onChanged) {
    final type = fieldSchema['type'];
    switch (type) {
      case 'text':
        return TextFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'email':
        return EmailFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'dropdown':
        return DropdownFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'phone':
        return PhoneFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'password':
        return PasswordFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'checkbox':
        return CheckboxFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'radio':
        return RadioGroupFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'switch':
        return SwitchFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'multiline_text':
        return MultilineTextFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'multi_select_dropdown':
        return MultiSelectDropdownFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'country_picker':
        return CountryPickerFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'state_city_picker':
        return StateCityPickerFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'stepper_number':
        return StepperNumberFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'date':
        return DatePickerFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'time':
        return TimePickerFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'datetime':
        return DateTimePickerFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'image_upload':
        return ImageUploadFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'file_upload':
        return FileUploadFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'signature_pad':
        return SignaturePadFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'color_picker':
        return ColorPickerFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'rating':
        return RatingFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'url_input':
        return UrlInputFieldWidget(schema: fieldSchema, onChanged: onChanged);
      case 'slider':
        return SliderFieldWidget(schema: fieldSchema, onChanged: onChanged);
      default:
        return const SizedBox.shrink();
    }
  }
}