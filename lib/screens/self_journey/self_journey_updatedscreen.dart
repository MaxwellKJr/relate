import 'package:flutter/material.dart';
import 'package:relate/screens/self_journey/plans/all_plans_screen.dart';

class SelfJourneyUpdatedScreen extends StatefulWidget {
  final String typeOfField = '';

  const SelfJourneyUpdatedScreen({super.key});
  State<SelfJourneyUpdatedScreen> createState() =>
      _SelfJourneyUpdatedScreenState();
}

class _SelfJourneyUpdatedScreenState extends State<SelfJourneyUpdatedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          SingleChildScrollView(
            child: TabBar(isScrollable: false, tabs: [
              Tab(
                text: "My Plans",
              ),
              Tab(
                text: "Other Plans",
              ),
            ]),
          ),
          Expanded(
            child: TabBarView(
              children: [
                AllPlansScreen(),
                AllPlansScreen(),
              ],
            ),
          )
        ],
      ))),
    );
  }
}
