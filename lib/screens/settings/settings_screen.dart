import 'package:flutter/material.dart';
import 'package:relate/components/navigation/settings/settings_list_tile.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/models/settings_list_tile_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsListTileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsListTileViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(tSettings)),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _viewModel.settingsPagesList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _viewModel.settingsPagesList[index];
            return SettingsListTile(
              leading: item['leading'],
              title: item['title'],
              destination: item['destination'],
            );
          }),
    );
  }
}
