import 'package:flutter/material.dart';

class GroupCards extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String email;
  // final String adminName;
  const GroupCards(
      {Key? key,
      // required this.adminName,
      required this.email,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupCards> createState() => _GroupCardsState();
}

class _GroupCardsState extends State<GroupCards> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.groupId),
      subtitle: Text(widget.groupName),
    );
  }
}
