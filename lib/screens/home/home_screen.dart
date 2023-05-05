import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/authentication/login_screen.dart';
import 'package:relate/screens/post_issue/post_issue_screen.dart';
import 'package:relate/components/post/post_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void signOut() {
    FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async {
                SystemNavigator.pop();
                return false;
              },
              child: const LoginScreen(),
            )
        // const LoginScreen()
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              leading: const Icon(Icons.menu),
              title: const Text("Relate"),
              actions: [
                IconButton(
                    onPressed: signOut,
                    icon: const Icon(Icons.logout_outlined)),
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
                      PostList(),
                    ]),
              ),
            ),
          ],
        ),
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
