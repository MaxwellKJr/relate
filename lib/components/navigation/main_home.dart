import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/community/communities_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/messages/messages_screen.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';
import 'package:relate/screens/self_journey/self_journey_updatedscreen.dart';
import 'package:relate/screens/wellness_centres/wellness_centres_screen.dart';
import 'package:relate/screens/community/search_and_join _screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String userName = "";
  String email = "";
  String groupName = "";
  String groupId = "";
  String purpose = "";
  String description = "";
  String rules = "";

  int currentPageIndex = 0;

  final uid = FirebaseAuth.instance.currentUser?.uid.toString();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screens = [
      const HomeScreen(),
      const Communities(),
      const PostIssueScreen(),
      SelfJourneyUpdatedScreen(),
      const WellnessCentresScreen(),
    ];

    final screenTitle = [
      "Home",
      "Communities",
      "Post",
      "Self Recovery Plans",
      "Discover"
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(screenTitle[currentPageIndex],
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          // actions: currentPageIndex == 1
          //     ? [
          //         IconButton(
          //           icon: const Icon(Icons.search),
          //           onPressed: () {
          //             Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (context) => SearchAndJoin()));
          //           },
          //         ),
          //       ]
          //     : null,
          // bottom:
          backgroundColor: theme.brightness == Brightness.dark
              ? Colors.black12 // set color for dark theme
              : Colors.white24, // set color for light theme
          bottomOpacity: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: primaryColor),
        ),
        body: screens[currentPageIndex],
        drawer: const DrawerMain(),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_rounded), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.people_rounded), label: "Communities"),
            NavigationDestination(
                icon: Icon(Icons.post_add_rounded), label: "Post"),
            NavigationDestination(
                icon: Icon(Icons.bar_chart_rounded), label: "Plans"),
            NavigationDestination(
                icon: Icon(Icons.search_outlined), label: "Discover"),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (currentPageIndex) =>
              setState(() => this.currentPageIndex = currentPageIndex),
        ));
  }
}
