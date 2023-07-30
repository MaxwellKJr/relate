import 'package:flutter/material.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/about_relate/about_relate_screen.dart';
import 'package:relate/screens/contact_professional/contact_professional_screen.dart';
import 'package:relate/screens/settings/settings_screen.dart';
import 'package:relate/screens/wellness_centres/wellness_centres_screen.dart';

class DrawerTilesViewModel {
  final List<Map<String, dynamic>> dataList = [
    {
      'leading': const Icon(
        Icons.favorite,
      ),
      'title': tWellnessCentres,
      'destination': const WellnessCentresScreen()
    },
    {
      'leading': const Icon(
        Icons.send_sharp,
      ),
      'title': tContactAProfessional,
      'destination': ContactProfessionalScreen()
    },
    {
      'leading': const Icon(
        Icons.settings,
      ),
      'title': tSettings,
      'destination': const SettingsScreen()
    },
    {
      'leading': const Icon(
        Icons.question_mark,
      ),
      'title': tAboutRelate,
      'destination': const AboutRelateScreen()
    },
  ];
}