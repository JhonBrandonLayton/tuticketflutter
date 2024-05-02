
import 'package:flutter/material.dart';

class TextFieldPersonalizado extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  const TextFieldPersonalizado({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      obscureText: obscureText,
    );
  }
}
