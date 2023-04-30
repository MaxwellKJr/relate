import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/home/home_page.dart';

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
              return const LoginScreen();
            }
          }),
    );
  }
}
