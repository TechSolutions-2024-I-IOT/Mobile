import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  const ReusableTextField({super.key, 
    required this.title,
    required this.hint,
    this.isNumber,
    required this.controller, 
    required this.readOnly,
  });

  final String title;
  final String hint;
  final bool? isNumber;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isNumber == null ? TextInputType.text : TextInputType.number,
      decoration: InputDecoration(
        labelText: title,
        hintText: hint,
      ),
      validator: (value) => value!.isEmpty ? "Cannot be empty" : null,
      controller: controller,
      readOnly: readOnly,
    );
  }
}