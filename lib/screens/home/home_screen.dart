import 'package:flutter/material.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';
import 'package:relate/screens/home/home_screen_body.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(tRelate),
        ),
        body: const HomeScreenBody(),
        drawer: const DrawerMain(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(milliseconds: 400),
                    child: const PostIssueScreen())
                // MaterialPageRoute(
                //   builder: (context) => const PostIssueScreen(),
                // ),
                );
          },
          backgroundColor: primaryColor,
          elevation: 3,
          child: const Icon(
            Icons.add,
            color: whiteColor,
          ),
        ),
        bottomNavigationBar: const NavigationBarMain(),
      ),
    );
  }
}
