import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relate/components/post/comments/comment_card.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/post/post_bottom_icons.dart';

class CommentsSection extends StatefulWidget {
  final String postId;
  const CommentsSection({super.key, required this.postId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
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
    );
  }
}
