import 'package:flutter/material.dart';
import 'package:relate/constants/text_string.dart';

class ContactProfessionalScreen extends StatefulWidget {
  const ContactProfessionalScreen({super.key});

  @override
  State<ContactProfessionalScreen> createState() =>
      _ContactProfessionalScreenState();
}

class _ContactProfessionalScreenState extends State<ContactProfessionalScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(tContactAProfessional),
      )),
    );
  }
}
