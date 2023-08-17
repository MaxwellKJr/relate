import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/auth_text_field.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/signup_screen.dart';
import 'package:relate/services/auth.dart';

/// This is the login screen
/// Either a normal user and professional can use this screen to login

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Instantiate the auth class
  final Auth auth = Auth();

  /// TextEditing Controllers to be used in the the respective fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();

  final RegExp _emailRegEx = RegExp(r'\s');
  final RegExp _passwordRegEx = RegExp(r'[a-zA-Z0-9]');

  bool _isLoading = false;

  /// function to trigger the loading animation
  void onButtonPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              padding: const EdgeInsets.all(layoutPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tWelcomeBack,
                        style: GoogleFonts.openSans(
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
                                prefixIcon: const Icon(Icons.alternate_email),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(_emailRegEx),
                                ],
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      _passwordRegEx),
                                ],
                                focusNode: _focusNode2,
                                onFieldSubmitted: (value) => auth.login(context,
                                    _emailController, _passwordController),
                              ),
                            ],
                          )),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          SizedBox(
                            height: tButtonHeight,
                            width: _isLoading ? tButtonHeight : double.infinity,
                            child: _isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : FilledButton(
                                    onPressed: () {
                                      /// Validator to ensure that all parameters are met and that text field !empty upon sending
                                      if (_formKey.currentState!.validate()) {
                                        onButtonPressed();
                                        _focusNode1.unfocus();
                                        _focusNode2.unfocus();
                                        auth.login(context, _emailController,
                                            _passwordController);
                                      }
                                    },
                                    child: Text(
                                      tLogin.toUpperCase(),
                                      style: GoogleFonts.openSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                                style: GoogleFonts.openSans(),
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
                                    style: GoogleFonts.openSans(
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
        ))));
  }
}
