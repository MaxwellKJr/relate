import 'package:flutter/material.dart';
import 'package:relate/constants/text_string.dart';

class SelfJourneyScreen extends StatefulWidget {
  const SelfJourneyScreen({super.key});

  @override
  State<SelfJourneyScreen> createState() => _SelfJourneyScreenState();
}

class _SelfJourneyScreenState extends State<SelfJourneyScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(tSelfJourney),
      )),
    );
  }
}
