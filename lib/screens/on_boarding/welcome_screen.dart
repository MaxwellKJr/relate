import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/on_boarding/on_boarding_pages.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

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
                      onPressed: () {},
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
  }
}
