import 'package:flutter/material.dart';

class Professional {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Professional({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class ContactProfessionalScreen extends StatefulWidget {
  const ContactProfessionalScreen({super.key});

  @override
  State<ContactProfessionalScreen> createState() =>
      _ContactProfessionalScreenState();
}

class _ContactProfessionalScreenState extends State<ContactProfessionalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
