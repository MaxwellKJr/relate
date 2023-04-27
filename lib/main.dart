import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/on_boarding/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relate App',
      theme: ThemeData(
        useMaterial3: true,
        // primaryColor: Colors.teal,
        // primarySwatch: Colors.teal,
        colorSchemeSeed: primaryColor
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          // primaryColor: Colors.teal,
          // primarySwatch: Colors.teal,
          colorSchemeSeed: primaryColor
      ),
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}

