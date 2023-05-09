import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:relate/view_models/post_view_model.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  late final PostViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PostViewModel();
    _viewModel.getPosts();
  }

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
          posts
              ?.map((post) => post.data())
              .forEach((post) => debugPrint(post.toString()));

          return ListView.builder(
              itemCount: posts?.length,
              itemBuilder: (context, index) {
                final post = posts![index];
                final String text = post['text'];
                final String postedBy = post['postedBy'];
                final Timestamp timestamp = post['timestamp'];
                final String uid = post['uid'];

                //Format date
                final dateTime = timestamp.toDate();
                final formattedDate = DateFormat.yMMMMEEEEd().format(dateTime);
                final formattedTime = DateFormat.Hm().format(dateTime);

                return SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(layoutPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPost(
                                            text: post['text'],
                                            postedBy: post['postedBy'],
                                            timestamp: post['timestamp'],
                                            uid: post['uid'],
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(color: Colors.red),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postedBy,
                                    style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    '$formattedDate - $formattedTime',
                                    style: const TextStyle(color: primaryColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    text,
                                    style: GoogleFonts.roboto(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              });
        }
      },
    ));
  }
}
