import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/self_journey/plans/plan_section_screen.dart';

class AllPlansScreen extends StatefulWidget {
  const AllPlansScreen({super.key});

  @override
  State<AllPlansScreen> createState() => _AllPlansScreenState();
}

class _AllPlansScreenState extends State<AllPlansScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: layoutPadding, horizontal: layoutPadding),
          child: Column(
            children: [
              // General Plans
              PlanSection(
                typeOfField: 'General',
                query: FirebaseFirestore.instance
                    .collection('plans')
                    .where('typeOfField', isEqualTo: 'General')
                    .limit(3),
              ),
              SizedBox(
                height: 10,
              ),
              // Other Plans Tab
              PlanSection(
                typeOfField: 'Addiction',
                query: FirebaseFirestore.instance
                    .collection('plans')
                    .where('typeOfField', isEqualTo: 'Addiction')
                    .limit(3),
              )
            ],
          ),
        )
      ],
    );
  }
}
