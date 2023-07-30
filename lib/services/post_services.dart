import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:relate/constants/colors.dart';

class PostServices {
  final context = BuildContext;

  Future<void> submitComment(context, postTextController, String postId) async {
    try {
      final commentBody = postTextController.text;

      final user = FirebaseAuth.instance;
      final uid = user.currentUser?.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final professionalDoc = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(uid)
          .get();
      String? userName;

      if (userDoc.exists) {
        userName = userDoc.data()!['userName'];
      } else if (professionalDoc.exists) {
        userName = professionalDoc.data()!['userName'];
      }

      final comment = {
        'uid': uid,
        'userName': userName,
        'commentBody': commentBody,
        'relates': [],
        'timestamp': Timestamp.now(),
      };

      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      await postRef.collection('comments').add(comment).then((value) =>
          Fluttertoast.showToast(
              msg: "Comment Submitted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: primaryColor,
              textColor: Colors.white,
              fontSize: 16.0));
      postTextController.clear();
      // postTextController.unfocus();
      // }
    } on FirebaseFirestore catch (error) {
      print(error);
    }
  }
}
