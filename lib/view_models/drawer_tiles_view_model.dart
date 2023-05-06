import 'package:flutter/material.dart';
import 'package:relate/constants/text_string.dart';

class DrawerTilesViewModel {
  final List<Map<String, dynamic>> dataList = [
    {'leading': const Icon(Icons.thumb_up), 'title': tWellnessCentres},
    {'leading': const Icon(Icons.bar_chart), 'title': tSelfJourney},
    {'leading': const Icon(Icons.people), 'title': tCommunityGroups},
    {'leading': const Icon(Icons.send_sharp), 'title': tContactAProfessional},
    {'leading': const Icon(Icons.question_mark), 'title': tAboutRelate},
  ];
}
