import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/models/message_model.dart';

class MessageService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get uid => null;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      time: 'timestamp',
      text: message,
      uid: receiverId,
      receiverUserName: '', receiverId: uid, // Replace with the actual receiver's username
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String uid, String otheruid) {
    List<String> ids = [uid, otheruid];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }
}






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/models/message_model.dart';
//
// class MessageService extends ChangeNotifier {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   get uid => null;
//
//   Future<void> sendMessage(String receiverId, String message) async {
//     final String currentUserId = _firebaseAuth.currentUser!.uid;
//     final Timestamp timestamp = Timestamp.now();
//
//     Message newMessage = Message(
//       senderId: currentUserId,
//       time: 'timestamp',
//       text: message,
//       uid: receiverId,
//       receiverUserName: '', receiverId: uid, // Replace with the actual receiver's username
//     );
//
//     List<String> ids = [currentUserId, receiverId];
//     ids.sort();
//     String chatRoomId = ids.join("_");
//
//     await _firestore
//         .collection('chat_rooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .add(newMessage.toMap());
//   }
//
//   Stream<QuerySnapshot> getMessages(String uid, String otheruid) {
//     List<String> ids = [uid, otheruid];
//     ids.sort();
//     String chatRoomId = ids.join("_");
//
//     return _firestore
//         .collection('chat_rooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('time', descending: false)
//         .snapshots();
//   }
// }
