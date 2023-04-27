import "package:flutter/material.dart";
import "package:relate/constants/colors.dart";
import "package:relate/constants/size_values.dart";
import "package:relate/screens/on_boarding/page_1.dart";
import "package:relate/screens/on_boarding/page_2.dart";
import "package:relate/screens/on_boarding/page_3.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class OnBoardingPages extends StatefulWidget {
  const OnBoardingPages({Key? key}) : super(key: key);

  @override
  State<OnBoardingPages> createState() => _OnBoardingPagesState();
}

class _OnBoardingPagesState extends State<OnBoardingPages> {
  // Page Controller
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [Page1(), Page2(), Page3()],
          ),
          Container(
              alignment: const Alignment(0, 0.75),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const ExpandingDotsEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  activeDotColor: primaryColor,
                ),
              ))
        ],
      ),
    ));
  }
}
