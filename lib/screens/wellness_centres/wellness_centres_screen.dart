import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
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
        appBar: AppBar(title: Text("Discover")),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: layoutPadding, left: layoutPadding, bottom: 5),
          child: Text(
            "Wellness Centres",
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
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
                  return SizedBox(
                      height: 350,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
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
                                      left: layoutPadding,
                                      // right: layoutPadding,
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
                                                width: 300,
                                                child: Card(
                                                  elevation: 10,
                                                  shape:
                                                      const RoundedRectangleBorder(

                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top:
                                                              layoutPadding + 5,
                                                          bottom:
                                                              layoutPadding + 5,
                                                          left: layoutPadding,
                                                          right: layoutPadding,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    name,
                                                                    maxLines: 3,
                                                                    textWidthBasis:
                                                                        TextWidthBasis
                                                                            .parent,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              address,
                                                              softWrap: true,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                      color:
                                                                          primaryColor,
                                                                      fontSize:
                                                                          14.5),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              criteria,
                                                              softWrap: true,
                                                              maxLines: 4,
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ])));
                              }));
                    }
                  },
                )),
          ],
        ))));
  }
}
