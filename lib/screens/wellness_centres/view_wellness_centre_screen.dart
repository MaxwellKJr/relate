import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/post/comments_section.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/services/post_services.dart';

class ViewWellnessCentreScreen extends StatefulWidget {
  final String postId, name, address, background, criteria, services, website;

  const ViewWellnessCentreScreen({
    super.key,
    required this.postId,
    required this.name,
    required this.address,
    required this.background,
    required this.criteria,
    required this.services,
    required this.website,
  });
  @override
  State<ViewWellnessCentreScreen> createState() =>
      _ViewWellnessCentreScreenState();
}

class _ViewWellnessCentreScreenState extends State<ViewWellnessCentreScreen> {
  final PostServices postService = PostServices();

  final _postTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                child: Padding(
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
                                      Text(
                                        widget.name,
                                        style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.circle_rounded,
                                        color: Colors.grey,
                                        size: 6,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.name,
                                        style: GoogleFonts.poppins(
                                            color: primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.criteria,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: primaryColor),
                                  ),
                                  const SizedBox(height: elementSpacing),
                                  Text(
                                    widget.services,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  // if (widget.image != '')
                                  //   Container(
                                  //       padding: const EdgeInsets.only(top: 10),
                                  //       child: ClipRRect(
                                  //         borderRadius:
                                  //             BorderRadius.circular(20.0),
                                  //         child: Image.network(
                                  //           widget.image,
                                  //           fit: BoxFit.cover,
                                  //         ),
                                  //       ))
                                  // else
                                  //   // Container(),
                                  //   // PostBottomIcons(
                                  //   //   postId: postId,
                                  //   //   relates: const [],
                                  //   // ),
                                  CommentsSection(postId: postId),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Form(
                                      key: _formKey,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: layoutPadding),
                                                child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Comment cannot be blank';
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        _postTextController,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  borderRadius),
                                                        ),
                                                        hintText: "Comment"))),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                postService.submitComment(
                                                    context,
                                                    _postTextController,
                                                    widget.postId);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.send_sharp,
                                              color: primaryColor,
                                            ),
                                          )
                                        ],
                                      )))
                            ],
                          ),
                        )
                      ],
                    )))));
  }
}
