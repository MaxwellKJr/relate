import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/screens/self_journey/plan_detail_screen.dart';
import 'package:relate/screens/self_journey/sellall_screen.dart';

class SelfJourneyUpdatedScreen extends StatelessWidget {
  String typeOfField = '';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Self Journey',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Plans'),
              Tab(text: 'Other Plans'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // My Plans Tab
            Container(
              child: Text('My Plans Tab Content'),
            ),
            // Other Plans Tab
            Container(
              child: ListView(
                children: [
                  PlanSection(
                    title: 'General',
                    query: FirebaseFirestore.instance
                        .collection('plans')
                        .where('typeOfField', isEqualTo: 'General')
                        .limit(3),
                  ),
                  SizedBox(height: 20),
                  PlanSection(
                    title: 'Addiction',
                    query: FirebaseFirestore.instance
                        .collection('plans')
                        .where('typeOfField', isEqualTo: 'Addiction')
                        .limit(3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanSection extends StatelessWidget {
  final String title;
  final Query query;

  PlanSection({required this.title, required this.query});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: EdgeInsets.all(8),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle navigation to the "See All" page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeAllScreen(typeOfField: 'General'),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<QuerySnapshot>(
          future: query.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('Error retrieving plans'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No plans found'),
              );
            }

            // Plans data is available
            List<DocumentSnapshot> planDocuments = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: planDocuments.length,
              itemBuilder: (context, index) {
                DocumentSnapshot planSnapshot = planDocuments[index];
                Map<String, dynamic> planData =
                    planSnapshot.data() as Map<String, dynamic>;

                final imageURL = planData['image'];

                return GestureDetector(
                  onTap: () {
                    // Handle navigation to the detailed page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanDetailScreen(planData),
                      ),
                    );
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Image.network(
                          imageURL,
                          fit: BoxFit.cover,
                          height: 70,
                          width: 80,
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(planData['nameOfPlan']),
                            subtitle: Text(planData['description']),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
