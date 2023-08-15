import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/self_journey/plan_detail_screen.dart';
import 'package:relate/screens/self_journey/sellall_screen.dart';

class PlanSection extends StatelessWidget {
  final String typeOfField;
  final Query query;

  PlanSection({super.key, required this.typeOfField, required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              typeOfField,
              style: GoogleFonts.openSans(
                  fontSize: 16, fontWeight: FontWeight.w600),
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
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
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

                return Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanDetailScreen(planData),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          colorBlendMode: BlendMode.hue,
                          key: UniqueKey(),
                          imageUrl: imageURL,
                          fit: BoxFit.cover,
                          maxHeightDiskCache: 500,
                          placeholder: (context, imageURL) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: primaryAccentDark),
                            child: ListTile(
                              title: Text(
                                planData['nameOfPlan'],
                                style: GoogleFonts.openSans(
                                    color: whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                planData['description'],
                                style: GoogleFonts.openSans(
                                    color: whiteColor, fontSize: 13),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
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
