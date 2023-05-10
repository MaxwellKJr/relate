import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/post/post_bottom_icons.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final posts = snapshot.data?.docs;

          // posts
          //     ?.map((post) => post.data())
          //     .forEach((post) => debugPrint(post.toString()));

          return ListView.builder(
              itemCount: posts?.length,
              itemBuilder: (context, index) {
                final post = posts![index];
                final postId = post.id;

                debugPrint(postId);

                final String text = post['text'];
                final String postedBy = post['postedBy'];
                final Timestamp timestamp = post['timestamp'];
                final String uid = post['uid'];

                //Format date
                final dateTime = timestamp.toDate();
                final formattedDate = DateFormat.yMMMMEEEEd().format(dateTime);
                final formattedTime = DateFormat.Hm().format(dateTime);
                final formattedDateTime = "$formattedDate $formattedTime";

                return SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: layoutPadding - 10,
                            right: layoutPadding - 10,
                            bottom: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewPost(
                                                postId: postId,
                                                text: text,
                                                postedBy: postedBy,
                                                formattedDateTime:
                                                    formattedDateTime,
                                                uid: uid,
                                              )));
                                },
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 1,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(layoutPadding),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              postedBy,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              '$formattedDate - $formattedTime',
                                              style: const TextStyle(
                                                  color: primaryColor),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              text,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 14.5),
                                              maxLines: 5,
                                            ),
                                            const PostBottomIcons(),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ])));
              });
        }
      },
    ));
  }
}
