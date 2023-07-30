import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/on_boarding/on_boarding_pages.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              pinkies,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withOpacity(0.2),
                      Colors.black.withOpacity(0.9)
                    ]),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(layoutPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: const AssetImage(tLogoWhite),
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
                            color: whiteColor),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        tWelcomeDescription,
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: whiteColor.withOpacity(0.84)),
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
          ],
        ));
    // }
  }
}
