import 'package:flutter/material.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:relate/screens/community/community_groups.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/profile/profile_screen.dart';

class NavigationBarMain extends StatefulWidget {
  const NavigationBarMain({super.key});

  @override
  State<NavigationBarMain> createState() => _NavigationBarMainState();
}

class _NavigationBarMainState extends State<NavigationBarMain> {
  int currentPageIndex = 0;

  final screens = [
    const HomeScreen(),
    const CommunityGroupsScreen(),
    const ChatScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_rounded), label: "Home"),
        NavigationDestination(
            icon: Icon(Icons.people_rounded), label: "Community"),
        NavigationDestination(icon: Icon(Icons.message_rounded), label: "Chat"),
        NavigationDestination(
            icon: Icon(Icons.person_rounded), label: "Profile"),
      ],
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }
}
