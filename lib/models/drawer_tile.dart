import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/icons.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/about_relate/about_relate_screen.dart';
import 'package:relate/screens/contact_professional/contact_professional_screen.dart';
import 'package:relate/screens/settings/settings_screen.dart';
import 'package:relate/screens/wellness_centres/wellness_centres_screen.dart';

class DrawerTilesViewModel {
  final List<Map<String, dynamic>> dataList = [
    // {
    //   'leading': const Icon(
    //     Icons.favorite,
    //   ),
    //   'title': tWellnessCentres,
    //   'destination': const WellnessCentresScreen()
    // },
    // {
    //   'leading': const Icon(
    //     Icons.send_sharp,
    //   ),
    //   'title': tContactAProfessional,
    //   'destination': ContactProfessionalScreen()
    // },
    {
      'leading': Container(
        height: 20,
        child: Image.asset(
          settings,
          color: primaryColor,
        ),
      ),
      'title': tSettings,
      'destination': const SettingsScreen()
    },
    {
      'leading': Container(
        height: 22,
        child: Image.asset(
          about,
          color: primaryColor,
        ),
      ),
      'title': tAboutRelate,
      'destination': const AboutRelateScreen()
    },
  ];
}
