import 'package:flutter/material.dart';
import 'package:relate/constants/text_string.dart';

class WellnessCentresScreen extends StatefulWidget {
  const WellnessCentresScreen({super.key});

  @override
  State<WellnessCentresScreen> createState() => _WellnessCentresScreenState();
}

class _WellnessCentresScreenState extends State<WellnessCentresScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(tWellnessCentres),
      ),
    );
  }
}
