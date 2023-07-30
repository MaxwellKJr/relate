import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/constants/size_values.dart';

class PlanDetailScreen extends StatelessWidget {
  final Map<String, dynamic> planData;

  PlanDetailScreen(this.planData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          expandedHeight: 300,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(planData['nameOfPlan']),
            background: CachedNetworkImage(imageUrl: planData['image']),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            child: Container(
              padding: EdgeInsets.all(layoutPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planData['nameOfPlan'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 16),
                  Text(
                    planData['description'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Steps:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('plans')
                        .doc(planData['documentID'])
                        .collection('steps')
                        .orderBy('stepNumber')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final steps = snapshot.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: steps.map((step) {
                            final stepData =
                                step.data() as Map<String, dynamic>;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Step ${stepData['stepNumber']}: ${stepData['stepText']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    )));
  }
}
