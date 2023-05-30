import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/about_relate/about_relate_screen.dart';
import 'package:relate/screens/community/community_groups.dart';
import 'package:relate/screens/contact_professional/contact_professional_screen.dart';
import 'package:relate/screens/self_journey/self_journey_screen.dart';
import 'package:relate/screens/settings/settings_screen.dart';
import 'package:relate/screens/wellness_centres/wellness_centres_screen.dart';

class DrawerTilesViewModel {
  final List<Map<String, dynamic>> dataList = [
    {
      'leading': const Icon(
        Icons.thumb_up,
        color: primaryColor,
      ),
      'title': tWellnessCentres,
      'destination': const WellnessCentresScreen()
    },
    {
      'leading': const Icon(Icons.bar_chart),
      'title': tSelfJourney,
      'destination': const SelfJourneyScreen()
    },
    {
      'leading': const Icon(
        Icons.people,
        color: primaryColor,
      ),
      'title': tCommunityGroups,
      'destination': const CommunityGroupsScreen()
    },
    {
      'leading': const Icon(Icons.send_sharp),
      'title': tContactAProfessional,
      'destination': const ContactProfessionalScreen()
    },
    {
      'leading': const Icon(
        Icons.settings,
        color: primaryColor,
      ),
      'title': tSettings,
      'destination': const SettingsScreen()
    },
    {
      'leading': const Icon(Icons.question_mark),
      'title': tAboutRelate,
      'destination': const AboutRelateScreen()
    },
  ];
}
