import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/icons.dart';
import 'package:relate/screens/home/addiction_posts_body.dart';
import 'package:relate/screens/home/motivation_posts_body.dart';
import 'package:relate/screens/home/home_screen_body.dart';
import 'package:relate/screens/home/depression_posts_body.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? dropDownValue;

  const HomeScreen({super.key, required this.dropDownValue});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
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
                    HomeScreenBody(dropDownValue: widget.dropDownValue),
                    DepressionPostsBody(dropDownValue: widget.dropDownValue),
                    AddictionPostsBody(dropDownValue: widget.dropDownValue),
                    MotivationPostsBody(dropDownValue: widget.dropDownValue)
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
              child: Container(
                height: 25,
                child: Image.asset(
                  pencil,
                  color: theme.brightness == Brightness.light
                      ? whiteColor
                      : iconColorLight,
                ),
              )),
        ));
  }
}
