import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/auth_text_field.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();

  void signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;
    final userName = _userNameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();

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
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(layoutPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Image(
                  //   image: const AssetImage(tLogo),
                  //   height: height * 0.3,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tCreateAccount,
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: primaryColor),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: elementSpacing),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AuthTextField(
                                controller: _userNameController,
                                hintText: tUserName,
                                obscureText: false,
                                prefixIcon: const Icon(Icons.person),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                focusNode: _focusNode1,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode2),
                              ),
                              const SizedBox(height: elementSpacing),
                              AuthTextField(
                                controller: _emailController,
                                hintText: tEmail,
                                obscureText: false,
                                prefixIcon: const Icon(Icons.email),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                focusNode: _focusNode2,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode3),
                              ),
                              // const SizedBox(height: elementSpacing),
                              // AuthTextField(
                              //   controller: _phoneNumberController,
                              //   hintText: tEmail,
                              //   obscureText: false,
                              //   prefixIcon: const Icon(Icons.email),
                              //   textInputAction: TextInputAction.next,
                              //   keyboardType: TextInputType.phone,
                              //   focusNode: _focusNode1,
                              //   onFieldSubmitted: (value) =>
                              //       FocusScope.of(context)
                              //           .requestFocus(_focusNode3),
                              // ),
                              const SizedBox(height: elementSpacing),
                              AuthTextField(
                                controller: _passwordController,
                                hintText: tPassword,
                                obscureText: true,
                                prefixIcon: const Icon(Icons.lock),
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.visiblePassword,
                                focusNode: _focusNode3,
                                onFieldSubmitted: (value) => signUp(),
                              ),
                            ],
                          )),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          SizedBox(
                            height: tButtonHeight,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signUp();
                                }
                              },
                              child: Text(
                                tSignupText.toUpperCase(),
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: elementSpacing),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tAlreadyHaveAnAccount,
                                style: GoogleFonts.poppins(),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const LoginScreen()));
                                  },
                                  child: const Text(
                                    tLogin,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ))
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              )),
        )));
  }
}
