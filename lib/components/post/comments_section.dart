import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/post/comments/comment_card.dart';

/// This Widget retrieves comments for each posts and displays them

class CommentsSection extends StatefulWidget {
  final String postId;
  const CommentsSection({super.key, required this.postId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 40, bottom: 80),
        child: Column(
          children: [
            /// Using StreamBuilder by getting the postId and comments collection
            /// being orderBy timestamp
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final comments = snapshot.data?.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments?.length,
                    itemBuilder: (context, index) {
                      final comment = comments![index];
                      return CommentCard(
                        userName: comment['userName'],
                        commentBody: comment['commentBody'],
                        timestamp: comment['timestamp'],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ));
  }
}
