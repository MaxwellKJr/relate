import 'package:flutter/material.dart';
import 'package:relate/constants/text_string.dart';

class AboutRelateScreen extends StatefulWidget {
  const AboutRelateScreen({super.key});

  @override
  State<AboutRelateScreen> createState() => _AboutRelateScreenState();
}

class _AboutRelateScreenState extends State<AboutRelateScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(tAboutRelate),
      )),
    );
  }
}
