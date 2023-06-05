import 'package:flutter/material.dart';
import 'package:relate/screens/community/group_cards.dart';
// import 'package:relate/screens/community/search_and_join_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/navigation/drawer/drawer_community.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/community/group_cards.dart';
import 'package:relate/screens/community/search_and_join%20_screen.dart';
// import 'package:relate/screens/community/section_divider.dart';
import 'package:relate/screens/create_group/CreateGroup.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:relate/services/helper_functions.dart';
// import 'section_divider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Communities extends StatefulWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream? groups;
  String userName = "";
  String email = "";
  String groupName = "";
  Stream? allGroupsStream;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? myGroupsStream;

  // string manipulation
  String getUsertId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getUserName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getGroupName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

//get email
  String getEmail(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    gettingUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //shared preference
  // gettingUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String storedUserName = prefs.getString('userName') ?? "";
  //   setState(() {
  //     userName = storedUserName;
  //   });

  //   await ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
  //       .getUserGroups()
  //       .then((snapshot) {
  //     setState(() {
  //       groups = snapshot.data()!['groups'];
  //     });

  //     groups!.forEach((groupId) {
  //       ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
  //           .getAllGroupMembers(groupId)
  //           .then((groupSnapshot) {
  //         // Access the group data here
  //         var groupData = groupSnapshot.data();
  //         // Perform any necessary operations with the group data
  //       });
  //     });
  //   });

  // await ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
  //     .getUserGroups()
  //     .then((snapshot) {
  //   setState(() {
  //     groups = snapshot;
  //   });
  //   groups!.forEach((element) {});
  // });

  gettingUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserName = prefs.getString('userName') ?? "";
    setState(() {
      userName = storedUserName;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    ChatDatabase chatDatabase = ChatDatabase(uid: userId);

    myGroupsStream = chatDatabase.getUserGroups();

    // myGroupsStream = chatDatabase.getUserGroups();
    allGroupsStream = chatDatabase.getAllGroups();

    // void yourFunction() async {
    //   myGroupsStream = chatDatabase.getUserGroups();
    // }

    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tCommunityGroups,
            style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchAndJoin()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateGroup()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'My Groups'),
              Tab(text: 'All Groups'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Content for My Groups tab
                myGroupList(),
                // Content for All Groups tab
                allGroupList(),
              ],
            ),
          ),
        ],
      ),
      drawer: const DrawerMain(),
    );
  }

  Widget myGroupList() {
    return StreamBuilder<DocumentSnapshot>(
      stream: myGroupsStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return noGroupWidget();
        }

        List<String> myGroups = [];

        if (snapshot.data!.exists) {
          myGroups = List<String>.from(snapshot.data!.get('groups') ?? []);
        }

        if (myGroups.isEmpty) {
          return noGroupWidget();
        }

        return ListView.builder(
          itemCount: myGroups.length,
          itemBuilder: (context, index) {
            return GroupCards(
              groupId: myGroups[index],
              userName: userName,
              groupName: myGroups[index],
            );
          },
        );
      },
    );
  }

  // Widget groupList() {
  //   return StreamBuilder(
  //     stream: groups,
  //     builder: (context, AsyncSnapshot snapshot) {
  //       // make checks
  //       if (snapshot.hasData) {
  //         if (snapshot.data['groups'] != null) {
  //           if (snapshot.data['groups'].length != 0) {
  //             // return Text("mabodza");

  //             return ListView.builder(
  //               itemCount: snapshot.data['groups'].length,
  //               itemBuilder: (context, index) {
  //                 return GroupCards(
  //                   groupId: snapshot.data['groups'][index],
  //                   userName: userName,
  //                   groupName: snapshot.data['groups'][index],
  //                 );
  //               },
  //             );
  //           } else {
  //             return noGroupWidget();
  //           }
  //         } else {
  //           return noGroupWidget();
  //         }
  //       } else {
  //         return Center(
  //           child: CircularProgressIndicator(
  //               color: Theme.of(context).primaryColor),
  //         );
  //       }
  //     },
  //   );
  // }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget allGroupList() {
    return StreamBuilder<List<String>>(
      stream: ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
          .getAllGroups(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Text('No data available');
        }

        List<String> groups = snapshot.data!;

        if (groups.isEmpty) {
          return noGroupWidget();
        }

        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return GroupCards(
              groupId: groups[index],
              userName: userName,
              groupName: getGroupName(groups[index]),
            );
          },
        );
      },
    );
  }

  // Widget allGroupList() {
  //   // Your implementation for All Groups tab content
  //   return Center(
  //     child: Text("pull all groups"),
  //   );
  // }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/components/navigation/drawer/drawer_community.dart';
// import 'package:relate/components/navigation/drawer/drawer_main.dart';
// import 'package:relate/components/navigation/navigation_bar.dart';
// import 'package:relate/constants/colors.dart';
// import 'package:relate/constants/text_string.dart';
// import 'package:relate/screens/community/group_cards.dart';
// import 'package:relate/screens/community/search_and_join%20_screen.dart';
// // import 'package:relate/screens/community/section_divider.dart';
// import 'package:relate/screens/create_group/CreateGroup.dart';
// import 'package:relate/services/chat_database_services.dart';
// import 'package:relate/services/helper_functions.dart';
// // import 'section_divider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Communities extends StatefulWidget {
//   const Communities({Key? key}) : super(key: key);

//   @override
//   State<Communities> createState() => _CommunitiesState();
// }

// class _CommunitiesState extends State<Communities> {
//   Stream? groups;
//   String userName = "";

//   String email = "";

//   String groupName = "";

//   // string manipulation
//   String getUsertId(String res) {
//     return res.substring(0, res.indexOf("_"));
//   }

//   String getUserName(String res) {
//     return res.substring(res.indexOf("_") + 1);
//   }

//   String getGroupName(String res) {
//     return res.substring(res.indexOf("_") + 1);
//   }

// //get email
//   String getEmail(String res) {
//     return res.substring(res.indexOf("_") + 1);
//   }

//   void initState() {
//     super.initState();
//     gettingUserData();
//   }

// //shared preference
//   gettingUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String storedUserName = prefs.getString('userName') ?? "";
//     setState(() {
//       userName = storedUserName;
//     });

//     await ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
//         .getUserGroups()
//         .then((snapshot) {
//       setState(() {
//         groups = snapshot;
//       });
//       groups!.forEach((element) {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Community Groups",
//             style: TextStyle(fontWeight: FontWeight.w500)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SearchAndJoin()),
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => CreateGroup()),
//               );
//             },
//           ),
//         ],
//         backgroundColor: theme.brightness == Brightness.dark
//             ? Colors.black12 // set color for dark theme
//             : Colors.white24, // set color for light theme
//         bottomOpacity: 0,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: primaryColor),
//       ),
//       drawer: const DrawerMain(),
//       body: groupList(),
//       bottomNavigationBar: const NavigationBarMain(),
//     );
//   }

//   groupList() {
//     return StreamBuilder(
//       stream: groups,
//       builder: (context, AsyncSnapshot snapshot) {
//         // make checks
//         if (snapshot.hasData) {
//           if (snapshot.data['groups'] != null) {
//             if (snapshot.data['groups'].length != 0) {
//               // return Text("mabodza");

//               return ListView.builder(
//                 itemCount: snapshot.data['groups'].length,
//                 itemBuilder: (context, index) {
//                   return GroupCards(
//                     // groupId: getUsertId(snapshot.data['groups'][index]),
//                     groupId: snapshot.data['groups'][index],
//                     userName: userName,
//                     groupName: getGroupName(snapshot.data['groups'][index]),
//                   );
//                 },
//               );
//             } else {
//               return noGroupWidget();
//             }
//           } else {
//             return noGroupWidget();
//           }
//         } else {
//           return Center(
//             child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor),
//           );
//         }
//       },
//     );
//   }

//   noGroupWidget() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 25),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: const [
//           Text(
//             "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
//             textAlign: TextAlign.center,
//           )
//         ],
//       ),
//     );
//   }
// }

