import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';

class ViewPost extends StatefulWidget {
  final String text, postedBy, uid, formattedDateTime;

  const ViewPost(
      {super.key,
      required this.text,
      required this.postedBy,
      required this.formattedDateTime,
      required this.uid});
  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  final _postTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Post")),
        body: SafeArea(
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
                              Text(
                                widget.postedBy,
                                style: GoogleFonts.poppins(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                widget.formattedDateTime,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: primaryColor),
                              ),
                              const SizedBox(height: elementSpacing),
                              Text(
                                widget.text,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              const PostBottomIcons(),
                            ],
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Form(
                                  key: _formKey,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Flexible(
                                          child: TextField(
                                              decoration: InputDecoration(
                                                  hintText: "Comment"))),
                                      IconButton(
                                        onPressed: () {},
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
                ))));
  }
}
