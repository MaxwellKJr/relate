import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/components/navigation/main_home.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/post_issue/edit_post_screen.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostTile extends StatelessWidget {
  final String postId,
      text,
      focus,
      image,
      postedBy,
      uid,
      formattedDateTime,
      daysAgo;
  final post, relates;

  const PostTile(
      {super.key,
      required this.post,
      required this.relates,
      required this.postId,
      required this.text,
      required this.focus,
      required this.image,
      required this.postedBy,
      required this.uid,
      required this.daysAgo,
      required this.formattedDateTime});

  Future<void> showBottomSheetPostOption(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
        width: double.infinity,
        child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  // color: borderColor,
                  color: theme.brightness == Brightness.dark
                      ? borderColorDark // set color for dark theme
                      : borderColor, // set color for light theme
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: layoutPadding - 10,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onLongPress: () async {
                  showPostOptions(context);
                },
                onTap: () async {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: ViewPost(
                            post: post,
                            relates: relates,
                            postId: postId,
                            text: text,
                            focus: focus,
                            image: image,
                            postedBy: postedBy,
                            formattedDateTime: formattedDateTime,
                            uid: uid,
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 230)));
                },
                child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Container(
                        padding: const EdgeInsets.only(
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
                                      backgroundColor: Colors.grey[400],
                                      // Random color generator
                                      // Color(
                                      //               (math.Random().nextDouble() *
                                      //                       0xFFFFFF)
                                      //                   .toInt())
                                      //           .withOpacity(1.0),
                                      child: Text(
                                        postedBy.substring(0,
                                            2), // Get the first character of the userName
                                        style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
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
                                              style: GoogleFonts.openSans(
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
                                              style: GoogleFonts.roboto(
                                                  color: focus == 'General'
                                                      ? primaryColor
                                                      : focus == 'Depression'
                                                          ? depressionColor
                                                          : focus == 'Addiction'
                                                              ? addictionColor
                                                              : motivationColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        Opacity(
                                          opacity: 0.6,
                                          child: Text(
                                            daysAgo,
                                            style: GoogleFonts.openSans(),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // morePostOptions(context);

                                    showPostOptions(context);
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    size: 19,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              text,
                              style: GoogleFonts.openSans(fontSize: 14.5),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                            if (post['image'] != null && post['image'] != '')
                              Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                      key: UniqueKey(),
                                      imageUrl: image,
                                      width: double.infinity,
                                      maxHeightDiskCache: 700,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(Icons.error),
                                      ),
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

  Future<void> showPostOptions(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          final currentUser = FirebaseAuth.instance.currentUser?.uid;
          return SizedBox(
              height: 200,
              child: Container(
                padding: EdgeInsets.all(layoutPadding),
                child: Center(
                    child: currentUser == uid
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Allow user to edit post
                              FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          child: EditPostScreen(
                                            postId: postId,
                                            text: text,
                                            focus: focus,
                                            image: image,
                                          ),
                                        ));
                                  },
                                  child: Text("Edit Post")),

                              /// Allow User to delete their post
                              FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Delete Post"),
                                            content: const Text(
                                                "Are you sure you want to delete this post?"),
                                            actions: [
                                              TextButton(
                                                child: const Text(
                                                  'Cancel',
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Yes, Delete',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                                onPressed: () async {
                                                  /// Firebase requires that inner documents or fields or collections are deleted first before outer collections
                                                  /// Delete Comments First
                                                  final commentsRef =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("posts")
                                                          .doc(postId)
                                                          .collection(
                                                              "comments")
                                                          .get();

                                                  for (var doc
                                                      in commentsRef.docs) {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("posts")
                                                        .doc(postId)
                                                        .collection("comments")
                                                        .doc(doc.id)
                                                        .delete();
                                                  }

                                                  /// Delete Post
                                                  FirebaseFirestore.instance
                                                      .collection("posts")
                                                      .doc(postId)
                                                      .delete()
                                                      .then((value) => {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Post Deleted Successfully",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .TOP,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    primaryColor,
                                                                textColor:
                                                                    whiteColor,
                                                                fontSize: 16.0),
                                                          });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Text("Delete Post")),
                            ],
                          )
                        : Flexible(
                            child: FilledButton(
                                onPressed: () {
                                  /// if user is not the owner of the post give them the option to report it
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Report Post'),
                                        content: const SizedBox(
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'Posts that get reported more than 5 times will automatically be deleted.'),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  'Are you sure you want to report this post?'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Yes, report'),
                                            onPressed: () async {
                                              /// Get the current post document reference or uid
                                              final postRef = FirebaseFirestore
                                                  .instance
                                                  .collection('posts')
                                                  .doc(postId);

                                              /// Add the current user's ID to the reports field array
                                              await postRef.update({
                                                'reports':
                                                    FieldValue.arrayUnion(
                                                        [currentUser]),
                                              }).then((value) => {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Thank you for reporting.",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            primaryColor,
                                                        textColor: whiteColor,
                                                        fontSize: 16.0),
                                                  });

                                              Navigator.of(context).pop();

                                              /// Get the updated post document snapshot
                                              final postSnapshot =
                                                  await postRef.get();

                                              /// Get the reports count from the updated post document
                                              final reportsCount = postSnapshot
                                                      .data()?['reports']
                                                      ?.length ??
                                                  0;

                                              /// This will check if the post has more than 2 reports
                                              /// Then delete the post if there are more than 2 reports
                                              if (reportsCount > 2) {
                                                await postRef.delete();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("Report Post")))),
              ));
        });
  }
}
