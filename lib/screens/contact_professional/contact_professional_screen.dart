import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/contact_professional/view_professionals_screen.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:relate/screens/contact_professional/view_professionals_screen.dart';

class ContactProfessionalScreen extends StatefulWidget {
  const ContactProfessionalScreen({super.key});

  @override
  State<ContactProfessionalScreen> createState() =>
      _ContactProfessionalScreenState();
}

class _ContactProfessionalScreenState extends State<ContactProfessionalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Profesional")),
      drawer: const DrawerMain(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: layoutPadding, left: layoutPadding, bottom: 5),
              //   child: Text(
              //     "Contact Professional",
              //     style: GoogleFonts.poppins(
              //       fontSize: 20,
              //       fontWeight: FontWeight.w800,
              //     ),
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.all(0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('professionals')
                      .snapshots(),
                  builder: (
                      context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final professionals = snapshot.data?.docs;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 100, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.vertical, // Change to vertical scroll
                          itemCount: professionals?.length,
                          itemBuilder: (context, index) {
                            final professional = professionals![index];
                            final String uid = professional['uid'];
                            final String email = professional['email'];
                            final isVerified = professional['isVerified'];
                            final phoneNumber = professional['phoneNumber'];
                            final String userName = professional['userName'];
                            return SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: layoutPadding,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewProfessionalDetailsScreen(
                                                  email: email,
                                                  uid: uid,
                                                  userName: userName,
                                                  isVerified: isVerified,
                                                  phoneNumber: phoneNumber,
                                                ),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: 350,
                                        child: Card(
                                          elevation: 10,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              top: layoutPadding + 5,
                                              bottom: layoutPadding + 5,
                                              left: layoutPadding,
                                              right: layoutPadding,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      userName,
                                                      maxLines: 3,
                                                      textWidthBasis:
                                                      TextWidthBasis.parent,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 17,
                                                        fontWeight:
                                                        FontWeight.w800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                    child: isVerified ? Text("Verified", style: GoogleFonts.poppins(color: primaryColor),) : Text("Not Verified", style: GoogleFonts.poppins(color: Colors.red),)
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  email,
                                                  softWrap: true,
                                                  style: GoogleFonts.roboto(
                                                    color: primaryColor,
                                                    fontSize: 14.5,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
