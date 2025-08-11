import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_form_builder/smart_form_builder.dart';
import 'package:smart_form_builder/models/field_model.dart';

void main() {
  runApp(const MaterialApp(
    home: SimpleFormPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class SimpleFormPage extends StatefulWidget {
  const SimpleFormPage({Key? key}) : super(key: key);

  @override
  State<SimpleFormPage> createState() => _SimpleFormPageState();
}

class _SimpleFormPageState extends State<SimpleFormPage> {
  Map<String, dynamic> formData = {};

  void onFieldChange(String key, dynamic value) {
    setState(() {
      formData[key] = value;
    });
  }

  void onSubmit(Map<String, dynamic> data) async {
    final payload = {
      'name': data['name'],
      'email': data['email'],
      'country': data['country'],
      'street_address': data['street_address'],
    };

    try {
      final response = await http.post(
        Uri.parse('https://688705e0071f195ca97eeee2.mockapi.io/Address'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text('Success'),
            content: Text('Data submitted successfully.'),
          ),
        );
      } else {
        throw Exception('Failed to submit');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Submission failed: $e'),
        ),
      );
    }
  }

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
    FieldModel(
      type: 'phone',
      key: 'phone_number',
      label: 'Phone Number',
      placeholder: 'Enter phone number',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'phone',
    ),
    FieldModel(
      type: 'password',
      key: 'password',
      label: 'Password',
      placeholder: 'Enter your password',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'lock',
      extra: {
        'showStrengthIndicator': true,
        'showVisibilityToggle': true,
      },
    ),

    // === Selection Fields ===
    FieldModel(
      type: 'dropdown',
      key: 'occupation',
      label: 'Occupation',
      placeholder: 'Select your occupation',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      options: [
        {'label': 'Software Developer', 'value': 'developer'},
        {'label': 'Designer', 'value': 'designer'},
        {'label': 'Manager', 'value': 'manager'},
        {'label': 'Student', 'value': 'student'},
        {'label': 'Other', 'value': 'other'},
      ],
    ),
    FieldModel(
      type: 'multi_select_dropdown',
      key: 'skills',
      label: 'Skills',
      placeholder: 'Select your skills',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      options: [
        {'label': 'Flutter', 'value': 'flutter'},
        {'label': 'Dart', 'value': 'dart'},
        {'label': 'React', 'value': 'react'},
        {'label': 'Node.js', 'value': 'nodejs'},
        {'label': 'Python', 'value': 'python'},
        {'label': 'Java', 'value': 'java'},
        {'label': 'Swift', 'value': 'swift'},
        {'label': 'Kotlin', 'value': 'kotlin'},
      ],
    ),
    FieldModel(
      type: 'country_picker',
      key: 'country',
      label: 'Country',
      placeholder: 'Select your country',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
    ),
    FieldModel(
      type: 'state_city_picker',
      key: 'location',
      label: 'State/City',
      placeholder: 'Select state and city',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      visibleWhen: {'country': 'US'},
    ),

    // === Interactive Controls ===
    FieldModel(
      type: 'checkbox',
      key: 'terms_accepted',
      label: 'I accept the terms and conditions',
      activeColor: '#3B82F6',
    ),
    FieldModel(
      type: 'checkbox',
      key: 'newsletter',
      label: 'Subscribe to newsletter',
      activeColor: '#10B981',
    ),
    FieldModel(
      type: 'radio',
      key: 'experience_level',
      label: 'Experience Level',
      activeColor: '#3B82F6',
      options: [
        {'label': 'Beginner (0-2 years)', 'value': 'beginner'},
        {'label': 'Intermediate (3-5 years)', 'value': 'intermediate'},
        {'label': 'Advanced (6-10 years)', 'value': 'advanced'},
        {'label': 'Expert (10+ years)', 'value': 'expert'},
      ],
    ),
    FieldModel(
      type: 'switch',
      key: 'notifications_enabled',
      label: 'Enable notifications',
      activeColor: '#3B82F6',
    ),
    FieldModel(
      type: 'slider',
      key: 'salary_expectation',
      label: 'Salary Expectation (\$)',
      extra: {
        'min': 30000,
        'max': 150000,
        'divisions': 12,
        'showValue': true,
      },
    ),
    FieldModel(
      type: 'stepper_number',
      key: 'years_experience',
      label: 'Years of Experience',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      extra: {
        'min': 0,
        'max': 50,
        'step': 1,
      },
    ),

    // === Date & Time ===
    FieldModel(
      type: 'date',
      key: 'birth_date',
      label: 'Date of Birth',
      placeholder: 'Select your birth date',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'calendar_today',
      extra: {
        'minDate': '1900-01-01',
        'maxDate': DateTime.now()
            .subtract(const Duration(days: 6570))
            .toIso8601String()
            .split('T')[0],
      },
    ),
    FieldModel(
      type: 'time',
      key: 'preferred_time',
      label: 'Preferred Contact Time',
      placeholder: 'Select preferred time',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'schedule',
      extra: {'format': '24h'},
    ),
    FieldModel(
      type: 'datetime',
      key: 'interview_time',
      label: 'Interview Date & Time',
      placeholder: 'Select interview date and time',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'event',
    ),

    // === File Uploads ===
    FieldModel(
      type: 'image_upload',
      key: 'profile_image',
      label: 'Profile Image',
      placeholder: 'Upload your profile image',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      extra: {
        'maxSize': 5,
        'allowedExtensions': ['jpg', 'jpeg', 'png'],
        'showPreview': true,
      },
    ),
    FieldModel(
      type: 'file_upload',
      key: 'resume',
      label: 'Resume (PDF)',
      placeholder: 'Upload your resume',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      extra: {
        'fileType': 'custom',
        'allowedExtensions': ['pdf', 'doc', 'docx'],
        'maxSize': 10,
      },
    ),
    FieldModel(
      type: 'signature_pad',
      key: 'digital_signature',
      label: 'Digital Signature',
      placeholder: 'Sign here',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#ffffff',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      extra: {
        'strokeWidth': 3,
        'exportFormat': 'svg',
      },
    ),

    // === Custom Inputs ===
    FieldModel(
      type: 'color_picker',
      key: 'theme_color',
      label: 'Theme Color',
      placeholder: '#3B82F6',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      extra: {
        'showSwatches': true,
        'maxSwatches': 12,
        'customSwatches': ['#EF4444', '#10B981', '#F59E0B', '#8B5CF6'],
      },
    ),
    FieldModel(
      type: 'rating',
      key: 'satisfaction_rating',
      label: 'How satisfied are you with this form?',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      extra: {
        'maxRating': 5,
        'ratingType': 'stars',
        'showLabels': true,
        'allowHalfRating': false,
        'size': 32,
        'activeColor': '#FFD700',
        'ratingLabels': {
          1: 'Very Dissatisfied',
          2: 'Dissatisfied',
          3: 'Neutral',
          4: 'Satisfied',
          5: 'Very Satisfied',
        },
      },
    ),
    FieldModel(
      type: 'url_input',
      key: 'portfolio_url',
      label: 'Portfolio URL',
      placeholder: 'https://your-portfolio.com',
      border: 'outline',
      borderRadius: 8,
      filled: true,
      fillColor: '#f8fafc',
      borderColor: '#e2e8f0',
      focusedBorderColor: '#3B82F6',
      prefixIcon: 'link',
      extra: {
        'showProtocolHint': true,
        'allowedProtocols': ['http', 'https'],
        'autoAddProtocol': true,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Demo"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: SmartForm(
                  fields: allFields,
                  onFieldChange: onFieldChange,
                  onSubmit: onSubmit,
                  fieldSpacing: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
