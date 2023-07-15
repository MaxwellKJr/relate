import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/post/comments_section.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/services/post_services.dart';

class ViewPost extends StatefulWidget {
  final String postId, text, focus, image, postedBy, uid, formattedDateTime;

  const ViewPost({
    Key? key,
    required this.postId,
    required this.text,
    required this.focus,
    required this.image,
    required this.postedBy,
    required this.formattedDateTime,
    required this.uid,
  }) : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  final PostServices postService = PostServices();

  final _postTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void flagOrFilterContent(String content) {
    final bannedKeywords = [
      'fuck',
      'keyword2',
      'keyword3',
    ];

    bool containsBannedKeyword =
        checkForBannedKeywords(content, bannedKeywords);

    if (containsBannedKeyword) {
      flagContentForReview(content);
    } else {
      submitComment();
    }
  }

  bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
    for (String keyword in bannedKeywords) {
      if (content.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  void flagContentForReview(String content) {
    // Implement your logic to flag the content for review
    // Store the flagged content in a database or notify your moderation team
    print('Content flagged for review: $content');
    // Display a toast or error message to the user indicating that the comment contains flagged content
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Flagged Content'),
          content: const Text(
              'This comment contains flagged content and has been submitted for review.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void submitComment() {
    if (_formKey.currentState!.validate()) {
      postService.submitComment(context, _postTextController, widget.postId);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postId = widget.postId;

    return Scaffold(
      appBar: AppBar(title: const Text("Post")),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(layoutPadding),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text(
                                      widget.postedBy.substring(0, 1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.postedBy,
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.circle_rounded,
                                            color: Colors.grey,
                                            size: 6,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.focus,
                                            style: GoogleFonts.roboto(
                                              color: primaryColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Opacity(
                                        opacity: 0.8,
                                        child: Text(
                                          widget.formattedDateTime,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: elementSpacing),
                              Text(
                                widget.text,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              if (widget.image != '')
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.image,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(Icons.error),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                Container(),
                              const SizedBox(height: 25),
                              CommentsSection(postId: postId),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: const Border(
                      top: BorderSide(
                        color: Colors.teal,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(top: 0),
                            decoration: const BoxDecoration(),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Comment cannot be blank';
                                }
                                return null;
                              },
                              controller: _postTextController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                border: InputBorder.none,
                                hintText: "Comment",
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            String commentContent =
                                _postTextController.text.trim();
                            flagOrFilterContent(commentContent);
                          },
                          icon: const Icon(
                            Icons.send_sharp,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
