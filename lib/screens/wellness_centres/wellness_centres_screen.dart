import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:relate/screens/wellness_centres/view_wellness_centre_screen.dart';

class WellnessCentresScreen extends StatefulWidget {
  const WellnessCentresScreen({super.key});

  @override
  State<WellnessCentresScreen> createState() => _WellnessCentresScreenState();
}

class _WellnessCentresScreenState extends State<WellnessCentresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discover")),
      drawer: const DrawerMain(),
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('wellnessCenters')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final wellnessCenters = snapshot.data?.docs;
                    return ListView.builder(
                        itemCount: wellnessCenters?.length,
                        itemBuilder: (context, index) {
                          final wellnessCenter = wellnessCenters![index];
                          final wellnessCenterId = wellnessCenter.id;
                          final String address = wellnessCenter['address'];
                          final String background =
                              wellnessCenter['background'];
                          final criteria = wellnessCenter['criteria'];
                          final String name = wellnessCenter['name'];
                          final String services = wellnessCenter['services'];
                          final String website = wellnessCenter['website'];
                          return SizedBox(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: layoutPadding - 10,
                                    right: layoutPadding - 10,
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewWellnessCentreScreen(
                                                          postId:
                                                              wellnessCenterId,
                                                          name: name,
                                                          address: address,
                                                          background:
                                                              background,
                                                          criteria: criteria,
                                                          services: services,
                                                          website: website,
                                                        )));
                                          },
                                          child: SizedBox(
                                              child: Card(
                                            elevation: 0,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.teal,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              padding: const EdgeInsets.only(
                                                top: layoutPadding + 5,
                                                bottom: layoutPadding + 5,
                                                left: layoutPadding - 10,
                                                right: layoutPadding - 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        name,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    address,
                                                    softWrap: true,
                                                    style: GoogleFonts.roboto(
                                                        color: primaryColor,
                                                        fontSize: 14.5),
                                                    maxLines: 10,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(background),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                          )),
                                        ),
                                      ])));
                        });
                  }
                },
              ))),
    );
  }
}
