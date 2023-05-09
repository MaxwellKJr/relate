import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/on_boarding/welcome_screen.dart';
import 'package:relate/view_models/post_view_model.dart';

Future<void> main() async {
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
    // final theme = Theme.of(context);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: theme.brightness == Brightness.dark
    //         ? Colors.black // set color for dark theme
    //         : Colors.white, // set color for light theme
    //   ),
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relate',
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: primaryColor),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: primaryColor),
      themeMode: ThemeMode.system,
      home: isLoggedIn ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
