import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/firebase_options.dart';
import 'package:relate/screens/authentication/auth_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:relate/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  var auth = FirebaseAuth.instance;
  var isLoggedIn = false;

  checkIfLoggedIn() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relate',
      theme: ThemeData(
          useMaterial3: true,
          // primaryColor: Colors.teal,
          // primarySwatch: Colors.teal,
          colorSchemeSeed: primaryColor),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          // primaryColor: Colors.teal,
          // primarySwatch: Colors.teal,
          colorSchemeSeed: primaryColor),
      themeMode: ThemeMode.system,
      home: isLoggedIn ? const HomeScreen() : const AuthScreen(),
    );
  }
}
