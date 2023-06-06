import 'package:flutter/material.dart';
import 'package:relate/constants/text_string.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(tSettings)),
      body: const SafeArea(
          child: Center(
        child: Text(tSettings),
      )),
    );
  }
}
