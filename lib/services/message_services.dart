// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:relate/constants/colors.dart';
// import 'package:relate/models/message_model.dart';

// class MessageServices extends ChangeNotifier {
//   final messageTextController = TextEditingController();

//   // SEND MESSAGE
//   Future<void> sendMessage(String receiverId, String messageId) async {
//     try {
//       final user = FirebaseAuth.instance;
//       final currentUserId = user.currentUser?.uid;

//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUserId)
//           .get();
//       final userName = userDoc.data()!['userName'];

//       final professionalDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUserId)
//           .get();
//       final String professionalId = professionalDoc.data()!['uid'];

//       // Message newMessage = Message(
//       //   'senderId': currentUserId,
//       //   'senderUserName': userName,
//       //   'receiverId': professionalId,
//       //   'message': message,
//       //   'timestamp': Timestamp.now(),
//       // );

//       final messageRef =
//           FirebaseFirestore.instance.collection('Messages').doc(messageId);

//       // if (commentBody != null) {
//       //   Fluttertoast.showToast(
//       //       msg: "Comment field can't be blank",
//       //       toastLength: Toast.LENGTH_SHORT,
//       //       gravity: ToastGravity.BOTTOM,
//       //       timeInSecForIosWeb: 1,
//       //       backgroundColor: primaryColor,
//       //       textColor: Colors.white,
//       //       fontSize: 16.0);
//       // } else {
//       await messageRef.collection('reply').add(message).then((value) =>
//           Fluttertoast.showToast(
//               msg: "response Submitted",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: primaryColor,
//               textColor: Colors.white,
//               fontSize: 16.0));
//       messageTextController.clear();
//     } on FirebaseFirestore catch (error) {
//       print(error);
//     }
//   }
// }
