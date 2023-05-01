import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';

class AuthTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final prefixIcon;
  final keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        prefixIcon: prefixIcon,
        hintText: hintText,
        suffix: GestureDetector(
          onTap: () {
            controller.clear();
          },
          child: const Icon(
            Icons.delete,
            color: Colors.red,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
