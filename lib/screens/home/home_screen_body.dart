import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relate/components/post/post_tile.dart';

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
          // .orderBy('relates', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final posts = snapshot.data?.docs;
          return ListView.builder(
              itemCount: posts?.length,
              itemBuilder: (context, index) {
                final post = posts![index];
                final postId = post.id;

                final String text = post['text'];
                final String focus = post['focus'];

                final image = post['image'];

                final String postedBy = post['postedBy'];
                final Timestamp timestamp = post['timestamp'];
                final String uid = post['uid'];

                //Format date
                final dateTime = timestamp.toDate();
                final formattedDate = DateFormat.yMMMMEEEEd().format(dateTime);
                final formattedTime = DateFormat.Hm().format(dateTime);
                final formattedDateTime = "$formattedDate @ $formattedTime";

                return PostTile(
                    post: post,
                    postId: postId,
                    text: text,
                    image: image,
                    focus: focus,
                    postedBy: postedBy,
                    uid: uid,
                    formattedDateTime: formattedDateTime);
              });
        }
      },
    ));
  }
}
