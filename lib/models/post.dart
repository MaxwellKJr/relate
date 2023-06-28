import 'package:flutter/material.dart';

class Post {
  final String postId, text, focus, image, postedBy, uid, timestamp;

  const Post(
      {required this.postId,
      required this.text,
      required this.focus,
      required this.image,
      required this.postedBy,
      required this.uid,
      required this.timestamp});

  // Map<String, dynamic> toJson() =>
  //     {"postedBy": postedBy, "text": text, "timestamp": timestamp, "uid": uid};
}
