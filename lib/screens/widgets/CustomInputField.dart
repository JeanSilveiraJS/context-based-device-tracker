import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String?) onSaved;
  final String? Function(String?) validator;
  final bool obscureText;

  CustomInputField({
    required this.label,
    required this.hint,
    required this.onSaved,
    required this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        autofocus: true,
        onSaved: onSaved,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}