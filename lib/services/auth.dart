import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:relate/components/navigation/main_home.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/authentication/professional/get_professional_data_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Auth class contains all methods that have to do with authentication
/// Include signUp, login, and signout

class Auth {
  /// Get the context (scope) for each instance of where it is being used
  /// This can be another function or a screen

  final context = BuildContext;

  /// [userName] to be used

  String? userName;
  String? profilePicture;

  /// signUp as a normal user !professional
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
            builder: (BuildContext context) => const MainHomeScreen()));
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

  /// signUpAsProfessional
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

      if (user.currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasSignedInBefore', true);

        final professionalRef =
            FirebaseFirestore.instance.collection('professionals').doc(uid);

        await professionalRef.set({
          'uid': uid,
          'userName': userName,
          'email': email,
          'bio': "",
          'profilePicture': "",
          'location': "",
          'isProfessional': true,
          'isVerified': false,
          'isAPrivateProfessional': false,
          'specializedIn': [],
          'isAssociatedWith': [],
          'phoneNumber': phoneNumber,
          'relatesTo': [],
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                const GetProfessionalDataScreen()));
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

  /// login
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
            )));
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
    } else if (professionalDoc.exists) {
      userName = professionalDoc.data()!['userName'];
      profilePicture = professionalDoc.data()!['profilePicture'];
    }
  }

  // String imageUrl = '';

  void updateProfessionalDetails(
      BuildContext context,
      currentUser,
      bioController,
      phonenumberController,
      locationController,
      imageUrl) async {
    try {
      final bio = bioController.text.trim();
      final phoneNumber = phonenumberController.text.trim();
      final location = locationController.text.trim();

      final professionalDoc = await FirebaseFirestore.instance
          .collection('professionals')
          .doc(currentUser)
          .get();

      final professionalRef = FirebaseFirestore.instance
          .collection('professionals')
          .doc(currentUser);

      await professionalRef.update({
        'bio': bio,
        'phoneNumber': phoneNumber,
        'location': location,
        'profilePicture': imageUrl
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const MainHomeScreen()));
    } catch (e) {
      print(e);
    }
  }
}
