import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  final context = BuildContext;

  void postComment(context, postTextController) async {
    try {} on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "User Does Not Exist!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (error.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong Password. Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return null;
    }
  }
}
