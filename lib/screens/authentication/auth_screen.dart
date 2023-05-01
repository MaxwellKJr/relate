import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/on_boarding/welcome_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if logged in
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              // if logged out
              return const WelcomeScreen();
            }
          }),
    );
  }
}
