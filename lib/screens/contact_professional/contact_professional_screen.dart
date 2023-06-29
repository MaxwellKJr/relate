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
      appBar: AppBar(title: const Text(tContactAProfessional)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // padding(
              //   padding: const edgeinsets.only(
              //       top: layoutpadding, left: layoutpadding, bottom: 5),
              //   child: text(
              //     "contact professional",
              //     style: googlefonts.poppins(
              //       fontsize: 20,
              //       fontweight: fontweight.w800,
              //     ),
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.all(layoutPadding - 10),
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
                        height: MediaQuery.of(context).size.height -
                            100, // Adjust the height as needed
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, crossAxisSpacing: 5),
                          itemCount: professionals?.length,
                          itemBuilder: (context, index) {
                            final professional = professionals![index];

                            final String uid = professional['uid'];
                            final String email = professional['email'];
                            final isVerified = professional['isVerified'];
                            final phoneNumber = professional['phoneNumber'];
                            final String userName = professional['userName'];
                            return SizedBox(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        child: Card(
                                          elevation: 5,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              top: layoutPadding + 5,
                                              left: layoutPadding,
                                              right: layoutPadding,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      userName,
                                                      textWidthBasis:
                                                          TextWidthBasis.parent,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                    child: isVerified
                                                        ? Text(
                                                            "Verified",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color:
                                                                        primaryColor),
                                                          )
                                                        : Text(
                                                            "Not Verified",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .red),
                                                          )),
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
                                                SizedBox(
                                                  height: 30,
                                                  child: OutlinedButton(
                                                      onPressed: () {},
                                                      child: Text("Message")),
                                                ),
                                                const SizedBox(height: 20),
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
