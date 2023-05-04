import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/on_boarding/on_boarding_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Check if user has signed in before
  // bool _userHasSignedInBefore = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkIfUserHasSignedInBefore();
  // }

  // Future<void> _checkIfUserHasSignedInBefore() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool hasSignedInBefore = prefs.getBool('hasSignedInBefore') ?? false;
  //   setState(() {
  //     _userHasSignedInBefore = hasSignedInBefore;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    // if (_userHasSignedInBefore) {
    //   // Navigate directly to the home screen if the user has signed in before
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (BuildContext context) => const LoginScreen()));

    //   return Container();
    // } else {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(layoutPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: const AssetImage(tLogo),
              height: height * 0.5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tWelcomeText.toUpperCase(),
                  style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: primaryColor),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12.0),
                Text(
                  tWelcomeDescription,
                  style: GoogleFonts.poppins(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
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
                SizedBox(
                  height: tButtonHeight,
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ));
                      },
                      child: Text(
                        tLoginInsteadText.toUpperCase(),
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
    // }
  }
}
