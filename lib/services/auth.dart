import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:relate/components/navigation/main_home.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/authentication/get_user_data_screen.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final context = BuildContext;

  String? userName;

  void signUp(
    context,
    userNameController,
    phoneNumberController,
    emailController,
    passwordController,
    groupsController,
  ) async {
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
      final groups = groupsController.text.split(',');

      if (user.currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasSignedInBefore', true);
        prefs.setString('userName', userName);

        final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

        await userRef.set({
          'uid': uid,
          'userName': userName,
          'email': email,
          'phoneNumber': phoneNumber,
          'groups': [],
          'relatesTo': []
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const GetUserDataScreen()));
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
          'relatesTo': [],
          // 'consultancyName': consultancyName,
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const GetUserDataScreen()));
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

        final currentUser = user.currentUser!;
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUser.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userName = querySnapshot.docs[0].data()['userName'];
          prefs.setString('userName', userName);
        }

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

  Future<void> getCurrentUserData() async {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final professionalDoc = await FirebaseFirestore.instance
        .collection('professionals')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      userName = userDoc.data()!['userName'];
      print(userName);
    } else if (professionalDoc.exists) {
      userName = professionalDoc.data()!['userName'];
      final isVerified = professionalDoc.data()!['isVerified'];
      print(userName);
    }
  }

  String imageUrl = '';

  void updateProfessionalDetails(BuildContext context, bioController,
      phonenumberController, locationController, imageUrl) async {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;

    final bio = bioController.text.trim();
    final phoneNumber = phonenumberController.text.trim();
    final location = locationController.text.trim();

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final professionalDoc = await FirebaseFirestore.instance
        .collection('professionals')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.update({
        'bio': bio,
        'phoneNumber': phoneNumber,
        'location': location,
        'profilePicture': imageUrl
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const MainHomeScreen()));
    } else if (professionalDoc.exists) {
      final professionalRef =
          FirebaseFirestore.instance.collection('professionals').doc(uid);

      await professionalRef.update({
        'bio': bio,
        'phoneNumber': phoneNumber,
        'location': location,
        'profilePicture': imageUrl
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const MainHomeScreen()));
    }
  }
}
