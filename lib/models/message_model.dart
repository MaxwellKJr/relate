import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class Message {
  final User sender;
  final String
    time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.isLiked,
    required this.unread,
    });

  toJson() {
    return {
      "sender": sender,
      "text": text,
      "time": time,
    };
  }

}

