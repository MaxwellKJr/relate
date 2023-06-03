// import 'package:flutter/material.dart';

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Tab Demo'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Tab 1'),
//               Tab(text: 'Tab 2'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             Center(child: Text('Content of Tab 1')),
//             Center(child: Text('Content of Tab 2')),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //kapolo


// ///
// ///
// // ///
// // ///import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:relate/components/navigation/drawer/drawer_community.dart';
// // import 'package:relate/components/navigation/drawer/drawer_main.dart';
// // import 'package:relate/components/navigation/navigation_bar.dart';
// // import 'package:relate/constants/colors.dart';
// // import 'package:relate/constants/text_string.dart';
// // import 'package:relate/screens/community/group_cards.dart';
// // import 'package:relate/screens/community/search_and_join%20_screen.dart';
// // // import 'package:relate/screens/community/section_divider.dart';
// // import 'package:relate/screens/create_group/CreateGroup.dart';
// // import 'package:relate/services/chat_database_services.dart';
// // import 'package:relate/services/helper_functions.dart';
// // // import 'section_divider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class Communities extends StatefulWidget {
// //   const Communities({Key? key}) : super(key: key);

// //   @override
// //   State<Communities> createState() => _CommunitiesState();
// // }

// // class _CommunitiesState extends State<Communities> {
// //   Stream? groups;
// //   String userName = "";

// //   String email = "";

// //   String groupName = "";

// //   // string manipulation
// //   String getUsertId(String res) {
// //     return res.substring(0, res.indexOf("_"));
// //   }

// //   String getUserName(String res) {
// //     return res.substring(res.indexOf("_") + 1);
// //   }

// //   String getGroupName(String res) {
// //     return res.substring(res.indexOf("_") + 1);
// //   }

// // //get email
// //   String getEmail(String res) {
// //     return res.substring(res.indexOf("_") + 1);
// //   }

// //   void initState() {
// //     super.initState();
// //     gettingUserData();
// //   }

// // //shared preference
// //   gettingUserData() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String storedUserName = prefs.getString('userName') ?? "";
// //     setState(() {
// //       userName = storedUserName;
// //     });

// //     await ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
// //         .getUserGroups()
// //         .then((snapshot) {
// //       setState(() {
// //         groups = snapshot;
// //       });
// //       groups!.forEach((element) {});
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Community Groups",
// //             style: TextStyle(fontWeight: FontWeight.w500)),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.search),
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => SearchAndJoin()),
// //               );
// //             },
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.add),
// //             onPressed: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => CreateGroup()),
// //               );
// //             },
// //           ),
// //         ],
// //         backgroundColor: theme.brightness == Brightness.dark
// //             ? Colors.black12 // set color for dark theme
// //             : Colors.white24, // set color for light theme
// //         bottomOpacity: 0,
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: primaryColor),
// //       ),
// //       drawer: const DrawerMain(),
// //       body: groupList(),
// //       bottomNavigationBar: const NavigationBarMain(),
// //     );
// //   }

// //   groupList() {
// //     return StreamBuilder(
// //       stream: groups,
// //       builder: (context, AsyncSnapshot snapshot) {
// //         // make checks
// //         if (snapshot.hasData) {
// //           if (snapshot.data['groups'] != null) {
// //             if (snapshot.data['groups'].length != 0) {
// //               // return Text("mabodza");

// //               return ListView.builder(
// //                 itemCount: snapshot.data['groups'].length,
// //                 itemBuilder: (context, index) {
// //                   return GroupCards(
// //                     groupId: getUsertId(snapshot.data['groups'][index]),
// //                     userName: userName,
// //                     groupName: getGroupName(snapshot.data['groups'][index]),
// //                   );
// //                 },
// //               );
// //             } else {
// //               return noGroupWidget();
// //             }
// //           } else {
// //             return noGroupWidget();
// //           }
// //         } else {
// //           return Center(
// //             child: CircularProgressIndicator(
// //                 color: Theme.of(context).primaryColor),
// //           );
// //         }
// //       },
// //     );
// //   }

// //   noGroupWidget() {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 25),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: const [
// //           Text(
// //             "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
// //             textAlign: TextAlign.center,
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
