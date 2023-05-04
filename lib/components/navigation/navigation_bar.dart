import 'package:flutter/material.dart';

class NavigationBarMain extends StatefulWidget {
  const NavigationBarMain({super.key});

  @override
  State<NavigationBarMain> createState() => _NavigationBarMainState();
}

class _NavigationBarMainState extends State<NavigationBarMain> {
  int currentPageIndex = 0;

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
