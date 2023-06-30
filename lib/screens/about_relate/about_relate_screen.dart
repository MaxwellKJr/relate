import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';

class AboutRelateScreen extends StatefulWidget {
  const AboutRelateScreen({super.key});

  @override
  State<AboutRelateScreen> createState() => _AboutRelateScreenState();
}

class _AboutRelateScreenState extends State<AboutRelateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(tAboutRelate)),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(layoutPadding),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Relate',
                style: GoogleFonts.alexBrush(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 16),
              const Text(
                'With Mental Health issues being on the rise among Malawian youths, Relate was created in order to help with that issue and to let people know that they are not alone in the struggles they face.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
                softWrap: true,
              ),
              const SizedBox(height: 32),
              const Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Developed by Group 5 Members:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  const Text(
                    'Maxwell Kapezi Jr',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    'Emmanuel William',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    'Elizabeth Kapusa',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    'Fred Likaka',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    'Comfort Chikapa',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
