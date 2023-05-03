import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';

class AuthTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final prefixIcon;
  final textInputAction;
  final keyboardType;
  final focusNode;
  final onFieldSubmitted;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.textInputAction,
    required this.keyboardType,
    required this.focusNode,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: controller,
      obscureText: obscureText,
      maxLines: 1,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
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
