import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/home/addiction_posts_body.dart';
import 'package:relate/screens/home/motivation_posts_body.dart';
import 'package:relate/screens/home/home_screen_body.dart';
import 'package:relate/screens/home/depression_posts_body.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: TabBar(isScrollable: true, tabs: [
                    Tab(text: "General"),
                    Tab(text: "Depression"),
                    Tab(text: "Addiction"),
                    Tab(text: "Motivation"),
                  ]),
                ),
                Expanded(
                  child: TabBarView(children: [
                    HomeScreenBody(),
                    DepressionPostsBody(),
                    AddictionPostsBody(),
                    MotivationPostsBody()
                  ]),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(milliseconds: 230),
                    child: const PostIssueScreen(),
                  ));
            },
            backgroundColor: primaryColor,
            elevation: 3,
            child: const Icon(
              CupertinoIcons.pen,
              color: whiteColor,
              size: 30,
            ),
          ),
        ));
  }
}
