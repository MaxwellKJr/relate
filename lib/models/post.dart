import 'package:flutter/material.dart';

class Post {
  final String? postedBy;
  final String? text;
  final String? timestamp;

  const Post({
    required this.postedBy,
    required this.text,
    required this.timestamp,
  });

  toJson() {
    return {"sentBy": postedBy, "text": text, "timestamp": timestamp};
  }
}
