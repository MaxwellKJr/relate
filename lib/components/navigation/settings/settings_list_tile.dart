import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final Icon leading;
  final String title;
  final destination;

  const SettingsListTile(
      {super.key,
      required this.leading,
      required this.title,
      required this.destination});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => destination));
      },
    );
  }
}
