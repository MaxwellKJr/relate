import 'package:flutter/cupertino.dart';
import 'package:relate/screens/settings/customization_screen.dart';
import 'package:relate/screens/settings/preferences_screen.dart';
import 'package:relate/screens/settings/privacy_screen.dart';

class SettingsListTileViewModel {
  final List<Map<String, dynamic>> settingsPagesList = [
    {
      'leading': Icon(CupertinoIcons.add),
      'title': 'Preferences',
      'destination': const PreferencesScreen()
    },
    {
      'leading': Icon(CupertinoIcons.lock),
      'title': 'Privacy',
      'destination': const PrivacyScreen()
    },
    {
      'leading': Icon(CupertinoIcons.paintbrush_fill),
      'title': 'Customization',
      'destination': const CustomizationScreen()
    },
  ];
}
