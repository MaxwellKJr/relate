import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/wellness_centres/webview_for_wellness_centres.dart';
import 'package:relate/services/post_services.dart';

/// View the wellness centre details

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

  @override
  Widget build(BuildContext context) {
    final postId = widget.postId;
    final website = widget.website;

    return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.name,
                                        style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.address,
                                            style: GoogleFonts.poppins(
                                                color: primaryColor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FilledButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      duration: const Duration(
                                                          milliseconds: 400),
                                                      child:
                                                          WebviewForWellnessCentres(
                                                              websiteName:
                                                                  widget.name,
                                                              website: website),
                                                    ));
                                              },
                                              icon: const Icon(Icons.launch),
                                              label:
                                                  const Text("Visit Website"))
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: elementSpacing),
                                  Text(
                                    "Background",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    widget.background,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: elementSpacing),
                                  Text(
                                    "Services",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    widget.services,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )))));
  }
}
