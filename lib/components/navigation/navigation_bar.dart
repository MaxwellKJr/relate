import 'package:flutter/material.dart';

class NavigationBarCustom extends StatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  State<NavigationBarCustom> createState() => _NavigationBarCustomState();
}

class _NavigationBarCustomState extends State<NavigationBarCustom> {
  @override
  Widget build(BuildContext context) {
    return
        NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.people), label: "Community"),
            NavigationDestination(icon: Icon(Icons.message), label: "Chat"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
    ),
  }
}
