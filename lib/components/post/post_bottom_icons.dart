import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:relate/constants/colors.dart';

class PostBottomIcons extends StatefulWidget {
  final String postId;
  final List<String> relates;
  const PostBottomIcons(
      {super.key, required this.postId, required this.relates});

  @override
  State<PostBottomIcons> createState() => _PostBottomIconsState();
}

/// Post Bottom icons that enable users to relate to a post and also see number of comments in a post
class _PostBottomIconsState extends State<PostBottomIcons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final userRef = FirebaseAuth.instance.currentUser;
  bool relates = false;

  @override
  void initState() {
    super.initState();
    relates = widget.relates.contains(userRef?.uid);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void toggleRelate() {
    setState(() {
      relates = !relates;
      // fetchCommentsLength();
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);

    if (relates) {
      _controller.forward();
      postRef.update({
        'relates': FieldValue.arrayUnion([userRef?.uid])
      });
      Fluttertoast.showToast(
          msg: "Post Related",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryColor,
          textColor: whiteColor,
          fontSize: 16.0);
    } else {
      _controller.reverse();
      postRef.update({
        'relates': FieldValue.arrayRemove([userRef?.uid])
      });
      Fluttertoast.showToast(
          msg: "Post Unrelated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryColor,
          textColor: whiteColor,
          fontSize: 16.0);
    }
  }

  int commentsLength = 0;

  Future<void> fetchCommentsLength() async {
    final int length = await getCommentsLength();
    setState(() {
      commentsLength = length;
    });
  }

  Future<int> getCommentsLength() async {
    final document =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    final collectionSnapshot = await document.collection('comments').get();
    return collectionSnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          toggleRelate();
                        },
                        child: relates
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red[800],
                                size: 20,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.grey,
                                size: 20,
                              )
                        // Lottie.asset(relateHeart,
                        //         height: 70, controller: _controller),
                        ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(widget.relates.length.toString())
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    // Lottie.asset(comment, height: 40, width: 40),
                    const Icon(
                      CupertinoIcons.text_bubble,
                      size: 19,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    FutureBuilder<int>(
                      future: getCommentsLength(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("0");
                        } else if (snapshot.hasData) {
                          commentsLength = snapshot.data!;
                        }
                        return Text(
                          commentsLength.toString(),
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    )
                  ],
                )
                // const Icon(
                //   Icons.share,
                //   size: 22,
                // ),
              ],
            )));
  }
}
