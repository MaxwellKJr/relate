import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/community/communities_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';
import 'package:relate/screens/self_journey/self_journey_updatedscreen.dart';
import 'package:relate/screens/wellness_centres/wellness_centres_screen.dart';
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
              style: GoogleFonts.openSans(
                  fontSize: 20, fontWeight: FontWeight.w600)),
          backgroundColor: theme.brightness == Brightness.dark
              ? Colors.black12 // set color for dark theme
              : Colors.white24, // set color for light theme
          bottomOpacity: 0,
          elevation: 0,
          iconTheme: const IconThemeData(),
        ),
        body: screens[currentPageIndex],
        drawer: const DrawerMain(),
        bottomNavigationBar: Offstage(
            offstage: currentPageIndex == 5,
            child: NavigationBar(
              animationDuration: const Duration(milliseconds: 1000),
              height: currentPageIndex == 2 ? 60 : 60,
              selectedIndex: currentPageIndex,
              onDestinationSelected: (currentPageIndex) =>
                  setState(() => this.currentPageIndex = currentPageIndex),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: const [
                NavigationDestination(
                    icon: Icon(
                      Icons.home_rounded,
                      size: 20,
                    ),
                    label: "Home"),
                NavigationDestination(
                    icon: Icon(
                      CupertinoIcons.group_solid,
                      size: 25,
                    ),
                    label: "Communities"),
                NavigationDestination(
                    icon: Icon(
                      CupertinoIcons.add_circled_solid,
                      size: 35,
                      color: primaryColor,
                    ),
                    label: "Post"),
                NavigationDestination(
                    icon: Icon(
                      CupertinoIcons.list_dash,
                      size: 20,
                    ),
                    label: "Plans"),
                NavigationDestination(
                    icon: Icon(
                      CupertinoIcons.search,
                      size: 20,
                    ),
                    label: "Discover"),
              ],
            )));
  }
}
