import 'package:flutter/material.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:relate/screens/community/community_groups.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/profile/profile_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int currentPageIndex = 0;

  final screens = [
    const HomeScreen(),
    const CommunityGroupsScreen(),
    const ChatScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentPageIndex],
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_rounded), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.people_rounded), label: "Community"),
            NavigationDestination(
                icon: Icon(Icons.message_rounded), label: "Chat"),
            NavigationDestination(
                icon: Icon(Icons.person_rounded), label: "Profile"),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (currentPageIndex) =>
              setState(() => this.currentPageIndex = currentPageIndex),
        ));
  }
}
