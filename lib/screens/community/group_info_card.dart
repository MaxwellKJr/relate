import 'package:flutter/material.dart';
import 'package:relate/screens/community/GroupInfo.dart';

class GroupInfoCard extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final String purpose;
  final String description;
  final String rules;
  const GroupInfoCard({
    Key? key,
    required this.purpose,
    required this.description,
    required this.rules,
    required this.userName,
    required this.groupName,
    required this.groupId,
  }) : super(key: key);
  @override
  State<GroupInfoCard> createState() => _GroupInfoCardState();
}

class _GroupInfoCardState extends State<GroupInfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Groupinfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  purpose: widget.purpose,
                  description: widget.description,
                  rules: widget.rules

                  // userName: widget.userName,
                  ),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            // "Join the conversation as ",
            widget.description,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
