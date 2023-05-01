import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/auth_text_field.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
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
                      AuthTextField(
                        controller: _emailController,
                        hintText: tEmail,
                        obscureText: false,
                        prefixIcon: const Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: elementSpacing),
                      AuthTextField(
                        controller: _passwordController,
                        hintText: tPassword,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          SizedBox(
                            height: tButtonHeight,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                signUp();
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
                                    style: TextStyle(color: primaryColor),
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
