import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/communities/communities_screen.dart';
import 'package:relate/screens/home/home_screen.dart';
import 'package:relate/screens/profile/profile_screen.dart';
import 'package:relate/screens/self_journey/self_journey_updatedscreen.dart';
import 'package:relate/screens/wellness_centres/wellness_centres_screen.dart';
import 'package:relate/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  Auth auth = Auth();

  int currentPageIndex = 0;
  final uid = FirebaseAuth.instance.currentUser?.uid.toString();

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
  }

  String? dropDownValue = 'Home';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screens = [
      HomeScreen(dropDownValue: dropDownValue),
      const Communities(),
      const SelfJourneyUpdatedScreen(),
      const WellnessCentresScreen(),
      ProfileScreen(uid: uid ?? ''),
    ];

    final screenTitle = [
      "Home",
      "Communities",
      "Self Recovery Plans",
      "Discover",
      "Profile"
    ];

    return Scaffold(
        appBar: AppBar(
          title: currentPageIndex == 0
              ? Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.only(left: 10, right: 6),
                  width: 105,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        focusColor: primaryColor,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              "Home",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w800),
                            ),
                            value: "Home",
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "Trending",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900),
                            ),
                            value: "Trending",
                          )
                        ],
                        hint: Text(
                          "$dropDownValue",
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.w700),
                        ),
                        iconEnabledColor: primaryColor,
                        value: dropDownValue,
                        onChanged: (dropDownValue) => setState(() {
                              dropDownValue =
                                  this.dropDownValue = dropDownValue;
                            })),
                  ),
                )
              : Text(screenTitle[currentPageIndex],
                  style: GoogleFonts.openSans(
                      fontSize: 18, fontWeight: FontWeight.w600)),
          backgroundColor: theme.brightness == Brightness.dark
              ? backgroundColorDark // set color for dark theme
              : backgroundColorLight, // set color for light theme
          bottomOpacity: 0,
          elevation: 0,
          iconTheme: const IconThemeData(),
        ),
        body: screens[currentPageIndex],
        drawer: const DrawerMain(),
        bottomNavigationBar: NavigationBar(
          elevation: 5,
          surfaceTintColor: theme.brightness == Brightness.light
              ? backgroundColorLight
              : backgroundColorDark,
          // shadowColor: theme.brightness == Brightness.light
          //     ? backgroundColorDark // set color for dark theme
          //     : backgroundColorLight, // set color for light theme
          animationDuration: const Duration(milliseconds: 1000),
          height: 60,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (currentPageIndex) =>
              setState(() => this.currentPageIndex = currentPageIndex),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home_rounded,
                size: 20,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(
                CupertinoIcons.group_solid,
                size: 25,
              ),
              label: "Communities",
            ),
            NavigationDestination(
                icon: Icon(
                  CupertinoIcons.list_dash,
                  size: 20,
                ),
                label: "Plans"),
            NavigationDestination(
                icon: Icon(
                  CupertinoIcons.search,
                  size: 20,
                ),
                label: "Discover"),
            NavigationDestination(
                icon: Icon(
                  CupertinoIcons.profile_circled,
                  size: 20,
                ),
                label: "Profile"),
          ],
        ));
  }
}
