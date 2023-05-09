import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post")),
      body: Container(
        padding: const EdgeInsets.all(layoutPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.postedBy,
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.formattedDateTime,
              style: GoogleFonts.poppins(fontSize: 12, color: primaryColor),
            ),
            const SizedBox(height: elementSpacing),
            Text(
              widget.text,
              style: GoogleFonts.poppins(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
