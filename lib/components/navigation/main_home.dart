import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/community/communities_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/messages/messages_screen.dart';
import 'package:relate/screens/wellness_centres/wellness_centres_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int currentPageIndex = 0;

  final screens = [
    const HomeScreen(),
    const Communities(),
    const MessagesScreen(),
    const WellnessCentresScreen(),
  ];

  final screenTitle = ["Relate", "Communities", "Messages", "Discover"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(screenTitle[currentPageIndex],
              style: GoogleFonts.alexBrush(
                  fontWeight: FontWeight.w500, fontSize: 32)),
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
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_rounded), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.people_rounded), label: "Communities"),
            NavigationDestination(
                icon: Icon(Icons.message_rounded), label: "Messages"),
            NavigationDestination(
                icon: Icon(Icons.search_outlined), label: "Discover"),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (currentPageIndex) =>
              setState(() => this.currentPageIndex = currentPageIndex),
        ));
  }
}
