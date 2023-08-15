import "package:flutter/material.dart";
import "package:relate/constants/colors.dart";
import "package:relate/constants/size_values.dart";
import "package:relate/constants/text_string.dart";
import "package:relate/screens/authentication/signup_screen.dart";
import "package:relate/screens/on_boarding/page_1.dart";
import "package:relate/screens/on_boarding/page_2.dart";
import "package:relate/screens/on_boarding/page_3.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import 'package:google_fonts/google_fonts.dart';

class OnBoardingPages extends StatefulWidget {
  const OnBoardingPages({Key? key}) : super(key: key);

  @override
  State<OnBoardingPages> createState() => _OnBoardingPagesState();
}

class _OnBoardingPagesState extends State<OnBoardingPages> {
  // Page Controller
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [Page1(), Page2(), Page3()],
          ),
          Container(
              alignment: const Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: layoutPadding + 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SmoothPageIndicator(
                          controller: _controller,
                          count: 3,
                          effect: const ExpandingDotsEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            activeDotColor: primaryColor,
                          ),
                        ),
                        const SizedBox(height: elementSpacing),
                        SizedBox(
                          height: tButtonHeight,
                          width: width - layoutPadding,
                          child: onLastPage
                              ? FilledButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const SignupScreen();
                                    }));
                                  },
                                  child: Text(
                                    tCreateAccount.toUpperCase(),
                                    style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: () {
                                    _controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn);
                                  },
                                  child: Text(
                                    "Next".toUpperCase(),
                                    style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    ));
  }
}
