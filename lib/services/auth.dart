import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final context = BuildContext;

  void signUp(context, userNameController, phoneNumberController,
      emailController, passwordController) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Account created successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: primaryColor,
                    textColor: whiteColor,
                    fontSize: 16.0)
              });

      final user = FirebaseAuth.instance;
      final uid = user.currentUser?.uid;

      final userName = userNameController.text.trim();
      final email = emailController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();

      if (user.currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasSignedInBefore', true);

        final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

        await userRef.set({
          'uid': uid,
          'userName': userName,
          'email': email,
          'phoneNumber': phoneNumber
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (error) {
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

  void signUpAsProfessional(context, userNameController, phoneNumberController,
      emailController, passwordController) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Account created successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: primaryColor,
                    textColor: whiteColor,
                    fontSize: 16.0)
              });

      final user = FirebaseAuth.instance;
      final uid = user.currentUser?.uid;

      final userName = userNameController.text.trim();
      final email = emailController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();
      // final consultancyName = consultancyNameController.text.trim();

      if (user.currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasSignedInBefore', true);

        final professionalRef =
            FirebaseFirestore.instance.collection('professionals').doc(uid);

        await professionalRef.set({
          'uid': uid,
          'userName': userName,
          'email': email,
          'isProfessional': true,
          'isVerified': false,
          'isAPrivateProfessional': false,
          'specializedIn': [],
          'isAssociatedWith': [],
          'phoneNumber': phoneNumber,
          // 'consultancyName': consultancyName,
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (error) {
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

  void login(context, _emailController, _passwordController) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Welcome, back!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: primaryColor,
                    textColor: whiteColor,
                    fontSize: 16.0)
              });

      var user = FirebaseAuth.instance;

      if (user.currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasSignedInBefore', true);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (error) {
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

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async {
                SystemNavigator.pop();
                return false;
              },
              child: const LoginScreen(),
            )
        // const LoginScreen()
        ));
  }

  void getCurrentUserData() {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;
  }
}
