import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:relate/constants/colors.dart';

class MessageServices {
  final context = BuildContext;

  Future<void> sendMessage(context, messageTextController, String messageId) async {
    try {
      final replyBody = messageTextController.text;

      final user = FirebaseAuth.instance;
      final uid = user.currentUser?.uid;
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userName = userDoc.data()!['userName'];

      final reply = {
        'uid': uid,
        'userName': userName,
        'messageBody': replyBody,
        'timestamp': Timestamp.now(),
      };

      final messageRef =
      FirebaseFirestore.instance.collection('Messages').doc(messageId);

      // if (commentBody != null) {
      //   Fluttertoast.showToast(
      //       msg: "Comment field can't be blank",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: primaryColor,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // } else {
      await messageRef.collection('reply').add(reply).then((value) =>
          Fluttertoast.showToast(
              msg: "response Submitted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: primaryColor,
              textColor: Colors.white,
              fontSize: 16.0));
      messageTextController.clear();
      messageTextController.unfocus();
      // }
    } on FirebaseFirestore catch (error) {
      print(error);
    }
  }

}
