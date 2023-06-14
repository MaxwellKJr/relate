import 'package:flutter/material.dart';

class TextFilter extends StatelessWidget {
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator validator;

  const TextFilter({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.onFieldSubmitted,
    required this.validator,

    // required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Color(0xFF009688),
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.lightbulb,
          color: Colors.green,
        ),
        labelText: labelText,
      ),
    );
  }
}
