import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class GetUserDataScreen extends StatefulWidget {
  const GetUserDataScreen({super.key});

  @override
  State<GetUserDataScreen> createState() => _GetUserDataScreenState();
}

class _GetUserDataScreenState extends State<GetUserDataScreen> {
  List<String> interestTags = [];
  static final List<String> _interests = [
    "Mental Health",
    "Depression",
    "Motivation",
    "General Topics",
    "Rants",
    "Loneliness",
    "Unknown Struggles",
    "Relationships",
    "Bad Breakup",
    "Religion",
  ];

  List<String> hobbiesTags = [];
  static final List<String> _hobbies = [
    "Reading",
    "Watching TV",
    "Writing",
    "Cooking",
    "Vibes Basi",
    "Socializing",
    "Blogging",
    "Music",
    "Praying",
    "Solo Worshipping",
    "Painting",
    "Tinkering",
    "Dancing",
    "Novels",
    "Day Dreaming",
  ];

  List<String> dislikesTags = [];
  static final List<String> _dislikes = [
    "Profanity",
    "Sexual Content",
    "Alcohol",
  ];

  Future<void> updateUserDetails() async {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final professionalDoc = await FirebaseFirestore.instance
        .collection('professionals')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.update({'interests': interestTags, 'hobbies': hobbiesTags});
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen()));
    } else if (professionalDoc.exists) {
      final professionalRef =
          FirebaseFirestore.instance.collection('professionals').doc(uid);
      await professionalRef
          .update({'interests': interestTags, 'hobbies': hobbiesTags});
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(layoutPadding),
                      child: Text(
                        "For a better user experience, we need to know more about you",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    //Interests
                    Container(
                        padding: const EdgeInsets.only(
                            left: layoutPadding, right: layoutPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Interests",
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor),
                            ),
                            Text(
                              "Kindly select what you would like to see more of while using Relate.",
                              style: GoogleFonts.roboto(fontSize: 16),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //Hobbies
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                            left: layoutPadding, right: layoutPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hobbies",
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor),
                            ),
                            Text(
                              "Select what you would like people to know about you",
                              style: GoogleFonts.roboto(fontSize: 16),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                // Dislikes
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                            left: layoutPadding, right: layoutPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dislikes",
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor),
                            ),
                            Text(
                              "Let us know what you hate so that we can do our best at not showing it to you",
                              style: GoogleFonts.roboto(fontSize: 16),
                            ),
                          ],
                        )),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(layoutPadding),
                  child: Column(children: [
                    SizedBox(
                      width: double.infinity,
                      height: tButtonHeight,
                      child: FilledButton(
                          onPressed: () {
                            updateUserDetails();
                          },
                          child: const Text("Continue")),
                    )
                  ]),
                )
              ]),
        ),
      ),
    ));
  }
}
