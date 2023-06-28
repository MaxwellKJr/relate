import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/home/addiction_posts_body.dart';
import 'package:relate/screens/home/motivation_posts_body.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';
import 'package:relate/screens/home/home_screen_body.dart';
import 'package:relate/screens/home/depression_posts_body.dart';
import 'package:page_transition/page_transition.dart';

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
          //   appBar:
          // AppBar(
          //     title: Text(tRelate,
          //         style: GoogleFonts.alexBrush(
          //             fontWeight: FontWeight.w500, fontSize: 32)),
          //     // bottom:
          //     backgroundColor: theme.brightness == Brightness.dark
          //         ? Colors.black12 // set color for dark theme
          //         : Colors.white24, // set color for light theme
          //     bottomOpacity: 0,
          //     elevation: 0,
          //     iconTheme: const IconThemeData(color: primaryColor),
          //   ),
          //   drawer: const DrawerMain(),
          body: const Column(
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(milliseconds: 400),
                    child: const PostIssueScreen(),
                  ));
            },
            backgroundColor: primaryColor,
            elevation: 3,
            child: const Icon(
              Icons.add,
              color: whiteColor,
            ),
          ),
        ));
  }
}
