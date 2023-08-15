import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relate/components/navigation/main_home.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/firebase_options.dart';
import 'package:relate/screens/on_boarding/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
    final theme = Theme.of(context);

    if (theme.brightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: backgroundColorDark));
    } else if (theme.brightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: bottomNavDark));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relate',
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: "OpenSans",
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.light,
              seedColor: primaryColor,
              primary: primaryColor,
              background: backgroundColorLight)),
      darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: "OpenSans",
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: primaryColor,
              primary: primaryColor,
              background: backgroundColorDark)),
      themeMode: ThemeMode.system,
      home: isLoggedIn ? const MainHomeScreen() : const WelcomeScreen(),
    );
  }
}
