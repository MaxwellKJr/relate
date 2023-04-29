import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        hintText: 'Email',
        suffix: GestureDetector(
          onTap: () {
            _userNameTextfieldController.clear();
          },
          child: const Text(
            'Clear',
          ),
        ),

        // labelText: 'First name',

        // suffixIcon: IconButton(
        //   onPressed: () {
        //     _userNameTextfieldController.clear();
        //   },
        //   icon: const Icon(Icons.delete),
        // )
      ),
    );
  }
}
