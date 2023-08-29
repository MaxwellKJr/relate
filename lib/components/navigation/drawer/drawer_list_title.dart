import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final Container leading;
  final String title;
  final destination;

  const DrawerListTile(
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
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => destination));
      },
    );
  }
}
