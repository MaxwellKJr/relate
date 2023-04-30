import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: layoutPadding, right: layoutPadding),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const Text("Home Page BABY!!")]),
      ),
    ));
  }
}
