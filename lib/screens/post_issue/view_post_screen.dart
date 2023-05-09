import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget {
  final String text, postedBy, uid;
  final Timestamp timestamp;

  const ViewPost(
      {super.key,
      required this.text,
      required this.postedBy,
      required this.timestamp,
      required this.uid});
  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.text.toString())),
      body: Container(
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
