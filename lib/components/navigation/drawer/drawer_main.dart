import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/navigation/drawer/drawer_list_title.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/services/auth.dart';
import 'package:relate/view_models/drawer_tiles_view_model.dart';

class DrawerMain extends StatefulWidget {
  const DrawerMain({super.key});

  @override
  State<DrawerMain> createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  late DrawerTilesViewModel _viewModel;
  final Auth auth = Auth();

  @override
  void initState() {
    super.initState();
    _viewModel = DrawerTilesViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding:
            const EdgeInsets.only(left: layoutPadding, right: layoutPadding),
        child: ListView(
          children: [
            DrawerHeader(
                child: Center(
              child: Text("Relate",
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: primaryColor)),
            )),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: _viewModel.dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _viewModel.dataList[index];
                  return DrawerListTile(
                    leading: item['leading'],
                    title: item['title'],
                  );
                },
              ),
            ),
            const SizedBox(
              height: elementSpacing,
            ),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: FilledButton(
                  onPressed: () {
                    auth.signOut(context);
                  },
                  child: const Text(tSignout)),
            )
          ],
        ),
      ),
    );
  }
}