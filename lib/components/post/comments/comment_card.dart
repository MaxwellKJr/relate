import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:relate/components/post/comments/comment_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatefulWidget {
  final String commentId, postId, userName, commentBody;
  final Timestamp timestamp;
  final comment;

  const CommentCard(
      {super.key,
      required this.comment,
      required this.commentId,
      required this.postId,
      required this.userName,
      required this.commentBody,
      required this.timestamp});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Format date
    final dateTime = widget.timestamp.toDate();

    final daysAgo = timeago.format(dateTime, locale: 'en_short');
    final formattedDate = DateFormat.yMMMMEEEEd().format(dateTime);
    final formattedTime = DateFormat.Hm().format(dateTime);

    final formattedDateTime = "$formattedDate $formattedTime";

    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.brightness == Brightness.dark
                ? borderColorDark // set color for dark theme
                : borderColor, // set color for light theme
            width: 1.0, // Set the width of the border
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
                        child: Text(
                          widget.userName.substring(
                              0, 1), // Get the first character of the userName
                          style: const TextStyle(
                              color: Colors.white), // Customize the text color
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Text(widget.commentBody,
                              style: GoogleFonts.openSans(fontSize: 15)),
                          const SizedBox(
                            height: 15,
                          ),

                          CommentBottomIcons(
                            postId: widget.postId,
                            commentId: widget.commentId,
                            relates: List<String>.from(
                                widget.comment['relates'] ?? []),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       isClicked = !isClicked;
                          //     });
                          //   },
                          //   child: isClicked
                          //       ? const Icon(
                          //           Icons.favorite,
                          //           size: 18,
                          //           color: primaryColor,
                          //         )
                          //       : const Icon(
                          //           Icons.favorite_outline,
                          //           size: 18,
                          //         ),
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    daysAgo,
                    style: const TextStyle(fontSize: 13, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
