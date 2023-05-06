import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final Icon leading;
  final String title;

  const DrawerListTile({super.key, required this.leading, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
