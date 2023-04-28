import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/on_boarding/on_boarding_pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final _userNameTextfieldController = TextEditingController();

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
                        "Welcome Back!",
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: primaryColor),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: elementSpacing),
                      TextField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          hintText: 'Email',
                          suffix: GestureDetector(
                            onTap: () {
                              _userNameTextfieldController.clear();
                            },
                            child: const Text(
                              'Clear',
                            ),
                          ),

                          // labelText: 'First name',

                          // suffixIcon: IconButton(
                          //   onPressed: () {
                          //     _userNameTextfieldController.clear();
                          //   },
                          //   icon: const Icon(Icons.delete),
                          // )
                        ),
                      ),
                      const SizedBox(height: elementSpacing),
                      TextField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          hintText: 'Password',
                          suffix: GestureDetector(
                            onTap: () {
                              _userNameTextfieldController.clear();
                            },
                            child: const Text(
                              'Clear',
                            ),
                          ),

                          // labelText: 'First name',

                          // suffixIcon: IconButton(
                          //   onPressed: () {
                          //     _userNameTextfieldController.clear();
                          //   },
                          //   icon: const Icon(Icons.delete),
                          // )
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          SizedBox(
                            height: tButtonHeight,
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const OnBoardingPages();
                                  },
                                ));
                              },
                              child: Text(
                                tGetStartedText.toUpperCase(),
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: elementSpacing),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(tDontHaveAnAccount),
                              Text(
                                tSignupText,
                                style: TextStyle(color: primaryColor),
                              )
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
