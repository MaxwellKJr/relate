import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:relate/components/post/post_tile.dart';
import 'package:relate/constants/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class DepressionPostsBody extends StatefulWidget {
  const DepressionPostsBody({super.key});

  @override
  State<DepressionPostsBody> createState() => _DepressionPostsBodyState();
}

class _DepressionPostsBodyState extends State<DepressionPostsBody> {
  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            animSpeedFactor: 10,
            backgroundColor: primaryColor,
            color: Colors.transparent,
            showChildOpacityTransition: false,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where(
                    'focus',
                    isEqualTo: 'Depression',
                  )
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
                      itemCount: posts!.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final postId = post.id;

                        // debugPrint(postId);

                        final String text = post['text'];
                        final String focus = post['focus'];

                        final image = post['image'];

                        final String postedBy = post['postedBy'];
                        final Timestamp timestamp = post['timestamp'];
                        final String uid = post['uid'];

                        final relates = post['relates'];

                        //Format date
                        final dateTime = timestamp.toDate();
                        final daysAgo = timeago.format(dateTime);
                        final formattedDate =
                            DateFormat.yMMMMEEEEd().format(dateTime);
                        final formattedTime = DateFormat.Hm().format(dateTime);
                        final formattedDateTime =
                            "$formattedDate @ $formattedTime";

                        return PostTile(
                            post: post,
                            relates: relates,
                            postId: postId,
                            text: text,
                            image: image,
                            focus: focus,
                            postedBy: postedBy,
                            uid: uid,
                            daysAgo: daysAgo,
                            formattedDateTime: formattedDateTime);
                      });
                }
              },
            )));
  }
}
