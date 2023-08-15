import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/text_string.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(layoutPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.asset(expressYourself, height: height * 0.3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page2Headline.toUpperCase(),
                style: GoogleFonts.openSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryColor),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10.0),
              Text(
                page2Description,
                style: GoogleFonts.openSans(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
