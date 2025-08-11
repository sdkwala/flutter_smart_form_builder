// import 'package:flutter/material.dart';
// import 'package:country_picker/country_picker.dart';
//
// class CountryPickerFieldWidget extends StatelessWidget {
//   final Map<String, dynamic> schema;
//   final void Function(String, dynamic)? onChanged;
//
//   const CountryPickerFieldWidget({Key? key, required this.schema, this.onChanged}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final keyName = schema['key'];
//     final label = schema['label'] ?? keyName;
//     return Builder(
//       builder: (context) {
//         String? selectedCountryName;
//         String? selectedCountryCode;
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label),
//                 const SizedBox(height: 8),
//                 InkWell(
//                   onTap: () {
//                     showCountryPicker(
//                       context: context,
//                       showPhoneCode: false,
//                       onSelect: (Country country) {
//                         setState(() {
//                           selectedCountryName = country.name;
//                           selectedCountryCode = country.countryCode;
//                         });
//                         if (onChanged != null) {
//                           onChanged!(keyName, {
//                             'name': country.name,
//                             'code': country.countryCode,
//                           });
//                         }
//                       },
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       selectedCountryName != null
//                           ? '$selectedCountryName (${selectedCountryCode ?? ''})'
//                           : 'Select country',
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:country_picker/country_picker.dart';
//
// class CountryPickerFieldWidget extends StatelessWidget {
//   final Map<String, dynamic> schema;
//   final void Function(String, dynamic)? onChanged;
//
//   const CountryPickerFieldWidget({Key? key, required this.schema, this.onChanged}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final keyName = schema['key'];
//     final label = schema['label'] ?? keyName;
//     return Builder(
//       builder: (context) {
//         String? selectedCountryName;
//         String? selectedCountryCode;
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label),
//                 const SizedBox(height: 8),
//                 Container(
//                   height: 48,
//                   width: 400,
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       showCountryPicker(
//                         context: context,
//                         showPhoneCode: false,
//                         onSelect: (Country country) {
//                           setState(() {
//                             selectedCountryName = country.name;
//                             selectedCountryCode = country.countryCode;
//                           });
//                           if (onChanged != null) {
//                             onChanged!(keyName, {
//                               'name': country.name,
//                               'code': country.countryCode,
//                             });
//                           }
//                         },
//                       );
//                     },
//                     child: Text(
//                       selectedCountryName ?? 'Select country',
//                       style: const TextStyle(fontSize: 16),
//                       ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountryPickerFieldWidget extends StatefulWidget {
  final Map<String, dynamic> schema;
  final void Function(String, dynamic)? onChanged;

  const CountryPickerFieldWidget({
    Key? key,
    required this.schema,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CountryPickerFieldWidget> createState() => _CountryPickerFieldWidgetState();
}

class _CountryPickerFieldWidgetState extends State<CountryPickerFieldWidget> {
  String? selectedCountryName;
  String? selectedCountryCode;

  @override
  Widget build(BuildContext context) {
    final keyName = widget.schema['key'];
    final label = widget.schema['label'] ?? keyName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Container(
          height: 48,
          width: 400,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: false,
                onSelect: (Country country) {
                  setState(() {
                    selectedCountryName = country.name;
                    selectedCountryCode = country.countryCode;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(keyName, {
                      'name': country.name,
                      'code': country.countryCode,
                    });
                  }
                },
              );
            },
            child: Text(
              selectedCountryName != null
                  ? '$selectedCountryName (${selectedCountryCode ?? ''})'
                  : 'Select country',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
