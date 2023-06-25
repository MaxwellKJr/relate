import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/models/post.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PostTile extends StatelessWidget {
  String postId, text, focus, image, postedBy, uid, formattedDateTime;
  final post;

  PostTile(
      {super.key,
      required this.post,
      required this.postId,
      required this.text,
      required this.focus,
      required this.image,
      required this.postedBy,
      required this.uid,
      required this.formattedDateTime});

  displayProfessionalIcon() async {
    final professionalDoc = await FirebaseFirestore.instance
        .collection('professionals')
        .doc(uid)
        .get();

    if (professionalDoc.exists) {
      return Icons.check;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.only(
              left: layoutPadding - 10,
              right: layoutPadding - 10,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPost(
                                postId: postId,
                                text: text,
                                focus: focus,
                                image: image,
                                postedBy: postedBy,
                                formattedDateTime: formattedDateTime,
                                uid: uid,
                              )));
                },
                child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                          left: layoutPadding - 10,
                          right: layoutPadding - 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  postedBy,
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.circle_rounded,
                                  color: Colors.grey,
                                  size: 6,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  focus,
                                  style: GoogleFonts.poppins(
                                      color: primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            Text(
                              formattedDateTime,
                              style: const TextStyle(),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              text,
                              style: GoogleFonts.roboto(fontSize: 14.5),
                              maxLines: 10,
                            ),
                            if (post['image'] != null && post['image'] != '')
                              Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                            else
                              Container(),
                            PostBottomIcons(
                              postId: postId,
                              relates: List<String>.from(post['relates'] ?? []),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ])));
  }
}
