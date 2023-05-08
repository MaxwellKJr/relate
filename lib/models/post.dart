import 'package:flutter/material.dart';

class Post {
  final String? postedBy;
  final String? text;
  final String? timestamp;
  final String? uid;

  const Post(
      {required this.postedBy,
      required this.text,
      required this.timestamp,
      required this.uid});

  Map<String, dynamic> toJson() =>
      {"postedBy": postedBy, "text": text, "timestamp": timestamp, "uid": uid};
}
