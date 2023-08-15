import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/screens/authentication/professional/signup_as_professional_screen.dart';

class ProfessionalDisclaimerScreen extends StatefulWidget {
  const ProfessionalDisclaimerScreen({super.key});

  @override
  State<ProfessionalDisclaimerScreen> createState() =>
      _ProfessionalDisclaimerScreenState();
}

class _ProfessionalDisclaimerScreenState
    extends State<ProfessionalDisclaimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(layoutPadding),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Disclaimer".toUpperCase(),
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w800, fontSize: 20)),
                  const SizedBox(
                    height: elementSpacing,
                  ),
                  Text(tProfessionalDisclaimer, style: GoogleFonts.openSans()),
                  const SizedBox(
                    height: elementSpacing,
                  ),
                  Text(tDisclaimer1, style: GoogleFonts.openSans()),
                  const SizedBox(
                    height: elementSpacing,
                  ),
                  Text(tDisclaimer2, style: GoogleFonts.openSans()),
                  const SizedBox(
                    height: elementSpacing,
                  ),
                  Text(tDisclaimer3, style: GoogleFonts.openSans()),
                  const SizedBox(
                    height: elementSpacing,
                  ),
                  Text(tDisclaimer4, style: GoogleFonts.openSans()),
                  const SizedBox(
                    height: elementSpacing,
                  ),
                  Text(tDisclaimer5, style: GoogleFonts.openSans()),
                  const SizedBox(
                    height: elementSpacing,
                  ),
                  SizedBox(
                    height: tButtonHeight,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const SignupAsProfessionalScreen();
                          },
                        ));
                      },
                      child: Text(
                        tIUnderstand.toUpperCase(),
                        style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )))),
    );
  }
}
