import 'package:flutter/material.dart';

class GetUserInput extends StatelessWidget {
  const GetUserInput({
    Key? key,
    required this.label,
    required this.hint,
    required this.isPassword,
    this.function,
  }) : super(key: key);
  final String label, hint;
  final bool isPassword;
  final String Function(String?)? function;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.all(20),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
