import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/auth_text_field.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();

  void login() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);

    // var user = FirebaseAuth.instance;

    // if (user.currentUser != null) {
    //   Navigator.of(context).pop(MaterialPageRoute(
    //       builder: (BuildContext context) => const LoginScreen()));

    // Navigator.pop(context);
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
                        tWelcomeBack,
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
                                controller: _emailController,
                                hintText: tEmail,
                                obscureText: false,
                                prefixIcon: const Icon(Icons.mail),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                focusNode: _focusNode1,
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode2),
                              ),
                              const SizedBox(height: elementSpacing),
                              AuthTextField(
                                controller: _passwordController,
                                hintText: tPassword,
                                obscureText: true,
                                prefixIcon: const Icon(Icons.lock),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.visiblePassword,
                                focusNode: _focusNode2,
                                onFieldSubmitted: (value) => login(),
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
                                  login();
                                }
                              },
                              child: Text(
                                tLogin.toUpperCase(),
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
                                tDontHaveAnAccount,
                                style: GoogleFonts.poppins(),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen()));
                                  },
                                  child: Text(
                                    tSignupText,
                                    style: GoogleFonts.poppins(
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
