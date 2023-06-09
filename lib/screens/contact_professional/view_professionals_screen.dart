import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/post/comments_section.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/services/post_services.dart';

class ViewProfessionalDetailsScreen extends StatefulWidget {
  final String email, phoneNumber,  uid, userName;
  final bool isVerified;

  const ViewProfessionalDetailsScreen({
    super.key,
    required this.uid,
    required this.userName,
    required this.email,
    required this.isVerified,
    required this.phoneNumber,
  });
  @override
  State<ViewProfessionalDetailsScreen> createState() =>
      _ViewProfessionalDetailsScreenState();
}

class _ViewProfessionalDetailsScreenState extends State<ViewProfessionalDetailsScreen> {
  final PostServices postService = PostServices();

  final _postTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final professionalId = widget.uid;

    return Scaffold(
        appBar: AppBar(title: Text(widget.userName)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: widget.isVerified ? Text("Verified", style: GoogleFonts.poppins(color: primaryColor),) : Text("Not Verified", style: GoogleFonts.poppins(color: Colors.red),)
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: elementSpacing),
                                  Text(
                                    "phoneNumber",
                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  // Text(
                                  //   widget.phoneNumber,
                                  //   style: GoogleFonts.poppins(
                                  //     fontSize: 14,
                                  //   ),
                                  // ),
                                  // const SizedBox(height: elementSpacing),
                                  // Text(
                                  //   "email",
                                  //   style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                                  // ),
                                  // Text(
                                  //   widget.email,
                                  //   style: GoogleFonts.poppins(fontSize: 14),
                                  // ),
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
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )))));
  }
}
