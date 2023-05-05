import 'package:flutter/material.dart';

class PostModel {
  final String? id;
  final String? body;
  final String? timestamp;
  final String? sentBy;

  const PostModel({
    this.id,
    required this.body,
    required this.timestamp,
    required this.sentBy,
  });

  toJson() {
    return {"body": body, "timestamp": timestamp, "sentBy": sentBy};
  }
}
