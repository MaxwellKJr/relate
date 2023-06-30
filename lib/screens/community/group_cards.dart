import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';

class GroupCards extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final String purpose;
  final String rules;
  final String description;
  final String admin;
  final String imageUrl;
  const GroupCards({
    Key? key,
    required this.imageUrl,
    required this.admin,
    required this.userName,
    required this.groupName,
    required this.groupId,
    required this.description,
    required this.purpose,
    required this.rules,
  }) : super(key: key);

  @override
  State<GroupCards> createState() => _GroupCardsState();
}

class _GroupCardsState extends State<GroupCards> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  userName: widget.userName,
                  description: widget.description,
                  purpose: widget.purpose,
                  rules: widget.rules,
                  admin: widget.admin),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            "Join the conversation as ",
            // widget.userName,
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
