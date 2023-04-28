import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/text_string.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(layoutPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: const AssetImage(tLogo),
            height: height * 0.3,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page1Headline.toUpperCase(),
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryColor),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10.0),
              Text(
                page1Description,
                style: GoogleFonts.poppins(fontSize: 16),
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
