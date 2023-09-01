import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/icons.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/about_relate/about_relate_screen.dart';
import 'package:relate/screens/settings/settings_screen.dart';

class DrawerTilesViewModel {
  final List<Map<String, dynamic>> dataList = [
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
