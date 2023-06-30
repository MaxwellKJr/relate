import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/models/post.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PostTile extends StatelessWidget {
  String postId, text, focus, image, postedBy, uid, formattedDateTime, daysAgo;
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
      required this.daysAgo,
      required this.formattedDateTime});

  Future<void> morePostOptions(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;

    if (currentUser == uid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Post"),
              content: const Text("Are you sure you want to delete this post?"),
              actions: [
                TextButton(
                  child:
                      const Text('Cancel', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () async {
                    // Delete Comments First
                    final commentsRef = await FirebaseFirestore.instance
                        .collection("posts")
                        .doc(postId)
                        .collection("comments")
                        .get();

                    for (var doc in commentsRef.docs) {
                      await FirebaseFirestore.instance
                          .collection("posts")
                          .doc(postId)
                          .collection("comments")
                          .doc(doc.id)
                          .delete();
                    }

                    // Delete Post
                    FirebaseFirestore.instance
                        .collection("posts")
                        .doc(postId)
                        .delete()
                        .then((value) => {
                              Fluttertoast.showToast(
                                  msg: "Post Deleted Successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: primaryColor,
                                  textColor: whiteColor,
                                  fontSize: 16.0),
                            });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Report Post'),
            content: const Text('Posts that get reported more than 3 times will automatically be deleted. Are you sure you want to report this post?'),
            actions: [
              TextButton(
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Yes, report'),
                onPressed: () async {
                  // Get the current post document reference
                  final postRef = FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId);

                  // Add the current user's ID to the reports field array
                  await postRef.update({
                    'reports': FieldValue.arrayUnion([currentUser]),
                  }).then((value) => {
                        Fluttertoast.showToast(
                            msg: "Thank you for reporting.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: primaryColor,
                            textColor: whiteColor,
                            fontSize: 16.0),
                      });

                  Navigator.of(context).pop();

                  // Get the updated post document snapshot
                  final postSnapshot = await postRef.get();

                  // Get the reports count from the updated post document
                  final reportsCount =
                      postSnapshot.data()?['reports']?.length ?? 0;

                  if (reportsCount > 2) {
                    // Delete the post if there are more than 0 reports
                    await postRef.delete();
                  }
                },
              ),
            ],
          );
        },
      );
    }
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
                      PageTransition(
                          child: ViewPost(
                            postId: postId,
                            text: text,
                            focus: focus,
                            image: image,
                            postedBy: postedBy,
                            formattedDateTime: formattedDateTime,
                            uid: uid,
                          ),
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 500)));
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors
                                          .grey, // Customize the background color
                                      child: Text(
                                        postedBy.substring(0,
                                            1), // Get the first character of the userName
                                        style: const TextStyle(
                                            color: Colors
                                                .white), // Customize the text color
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              postedBy,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        
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
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        Opacity(
                                          opacity: 0.6,
                                          child: Text(
                                            daysAgo,
                                            style: const TextStyle(),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      morePostOptions(context);
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                      size: 18,
                                    ))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              text,
                              style: GoogleFonts.roboto(fontSize: 14.5),
                              maxLines: 10,
                            ),
                            if (post['image'] != null && post['image'] != '')
                              Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
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
