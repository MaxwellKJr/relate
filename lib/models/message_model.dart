import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Message {
  final String senderId;
  final String uid;
  final String receiverUserName;
  final String time;
  final String text;


  Message({
    required this.senderId,
    required this.uid,
    required this.receiverUserName,
    required this.time,
    required this.text, required receiverId,
  });

  Map<String, dynamic> toMap() {
    return {
      "sender": senderId,
      "reciever": uid,
      "text": text,
      "time": time,
    };
  }
}

//   toJson() {
//     return {
//       "sender": senderId,
//       "reciever": recieverId,
//       "text": text,
//       "time": time,
//     };
//   }
// }
