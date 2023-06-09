import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/size_values.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon prefixIcon;
  final TextInputAction textInputAction;
  final keyboardType;
  final FocusNode focusNode;
  final onFieldSubmitted;

  const FormTextField({
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
    final hasText = ValueNotifier(false);
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else if (obscureText == true && value.length < 6) {
          return 'Password must have at least 6 characters';
        }
        return null;
      },
      controller: controller,
      obscureText: obscureText,
      maxLines: 1,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onChanged: (text) {
        hasText.value = text.isNotEmpty;
      },
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        prefixIcon: prefixIcon,
        hintText: hintText,
        suffix: ValueListenableBuilder<bool>(
          valueListenable: hasText,
          builder: (context, value, child) {
            return Visibility(
              visible: value,
              child: GestureDetector(
                onTap: () {
                  controller.clear();
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: iconSize,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
