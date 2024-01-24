import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/post/comments/comment_card.dart';
import 'package:relate/constants/colors.dart';

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
    final theme = Theme.of(context);

    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.brightness == Brightness.dark
                  ? borderColorDark // set color for dark theme
                  : borderColor, // set color for light theme
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 20, bottom: 80),
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
                      final commentId = comment.id;

                      return CommentCard(
                        comment: comment,
                        commentId: commentId,
                        postId: widget.postId,
                        userName: comment['userName'],
                        colorCode: comment['colorCode'],
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
