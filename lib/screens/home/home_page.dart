import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout_outlined)),
        ],
      ),
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
