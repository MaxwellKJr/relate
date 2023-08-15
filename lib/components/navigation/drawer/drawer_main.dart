import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/navigation/drawer/drawer_list_title.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/models/drawer_tile.dart';
import 'package:relate/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMain extends StatefulWidget {
  const DrawerMain({super.key});

  @override
  State<DrawerMain> createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  late DrawerTilesViewModel _viewModel;
  final Auth auth = Auth();

  String? userName;

  Future init() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('userName');
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    // auth.getCurrentUserData().then((value) => {setState(() {})});
    _viewModel = DrawerTilesViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.brightness == Brightness.dark
          ? backgroundColorDark // set color for dark theme
          : backgroundColorLight, // set color for light theme
      child: Container(
        padding:
            const EdgeInsets.only(left: layoutPadding, right: layoutPadding),
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Relate",
                            style: GoogleFonts.openSans(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                color: primaryColor)),
                        Text(
                          "$userName",
                          style: GoogleFonts.openSans(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    if (auth.profilePicture != null &&
                        auth.profilePicture != '')
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                auth.profilePicture ?? '',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                    else
                      Container(),
                  ],
                ),
              ],
            )),
            SizedBox(
              height: 350,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _viewModel.dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _viewModel.dataList[index];
                  return DrawerListTile(
                    leading: item['leading'],
                    title: item['title'],
                    destination: item['destination'],
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
                  child: Text(tSignout.toUpperCase(),
                      style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w700))),
            )
          ],
        ),
      ),
    );
  }
}
