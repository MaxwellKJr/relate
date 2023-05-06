import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/navigation/drawer/drawer_list_title.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';
import 'package:relate/components/post/post_list.dart';
import 'package:relate/view_models/drawer_tiles_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // void signOut() {
  //   FirebaseAuth.instance.signOut();

  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (BuildContext context) => WillPopScope(
  //             onWillPop: () async {
  //               SystemNavigator.pop();
  //               return false;
  //             },
  //             child: const LoginScreen(),
  //           )
  //       // const LoginScreen()
  //       ));
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              // leading: const Icon(Icons.menu),
              title: const Text("Relate"),
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.logout_outlined)),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: layoutPadding, right: layoutPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Recent Issues",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                            color: primaryColor),
                      ),
                    ]),
              ),
            ),
          ],
        ),
        drawer: const DrawerMain(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const PostIssueScreen();
              },
            ));
          },
          backgroundColor: primaryColor,
          elevation: 3,
          child: const Icon(
            Icons.add,
            color: whiteColor,
          ),
        ),
        bottomNavigationBar: const NavigationBarMain(),
      ),
    );
  }
}
