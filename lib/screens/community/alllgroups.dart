import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:relate/screens/chat/group_chat_info.dart';
import 'package:relate/screens/community/NotJoinedGroupInfo.dart';
import 'package:relate/screens/community/reasons.dart';
import 'package:relate/screens/community/trialpage.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:relate/services/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

class AllGroups extends StatefulWidget {
  const AllGroups({Key? key}) : super(key: key);

  @override
  State<AllGroups> createState() => _AllGroupsState();
}

class _AllGroupsState extends State<AllGroups> {
  String userName = "";
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var storedUserName = localStorage.getString('userName');

    setState(() {
      userName = storedUserName ??
          ""; // Use the stored user name from shared preferences
    });

    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatDatabase().getAllGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          if (snapshot.hasData) {
            final groups = snapshot.data!;

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final groupId = group['groupId'];
                final groupName = group['groupName'];
                final admin = group['admin'];
                final purpose = group['purpose'];
                final description = group['description'];
                final rules = group['rules'];

                return StreamBuilder<DocumentSnapshot>(
                  stream: ChatDatabase().getGroupData(groupId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    if (snapshot.hasData) {
                      final groupData = snapshot.data!;

                      final isMember =
                          groupData['members'].contains(user?.uid ?? '');

                      return isMember
                          ? joinedGroupTile(
                              userName,
                              groupId,
                              groupName,
                              admin,
                              purpose,
                              description,
                              rules,
                            )
                          : groupTile(
                              userName,
                              groupId,
                              groupName,
                              admin,
                              purpose,
                              description,
                              rules,
                            );
                    }

                    return const SizedBox();
                  },
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget groupTile(String userName, String groupId, String groupName,
      String admin, String purpose, String description, String rules) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrialPage(
                groupId: groupId,
                groupName: groupName,
                purpose: purpose,
                description: description,
                rules: rules,
                userName: userName),
          ),
        );
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  duration: const Duration(milliseconds: 400),
                  child: Reason(
                      groupId: groupId,
                      groupName: groupName,
                      purpose: purpose,
                      description: description,
                      rules: rules,
                      userName: userName),
                ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              "Join Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget joinedGroupTile(String userName, String groupId, String groupName,
      String admin, String purpose, String description, String rules) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[400],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: const Text(
          'Already Joined',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/screens/chat/chat_screen.dart';
// import 'package:relate/screens/chat/group_chat_info.dart';
// import 'package:relate/screens/community/NotJoinedGroupInfo.dart';
// import 'package:relate/screens/community/trialpage.dart';
// import 'package:relate/services/chat_database_services.dart';
// import 'package:relate/services/helper_functions.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AllGroups extends StatefulWidget {
//   const AllGroups({Key? key}) : super(key: key);

//   @override
//   State<AllGroups> createState() => _AllGroupsState();
// }

// class _AllGroupsState extends State<AllGroups> {
//   String userName = "";
//   User? user;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   getCurrentUser() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var storedUserName = localStorage.getString('userName');

//     setState(() {
//       userName = storedUserName ??
//           ""; // Use the stored user name from shared preferences
//     });

//     user = FirebaseAuth.instance.currentUser;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: ChatDatabase().getAllGroups(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//               ),
//             );
//           }

//           if (snapshot.hasData) {
//             final groups = snapshot.data!;

//             return ListView.builder(
//               itemCount: groups.length,
//               itemBuilder: (context, index) {
//                 final group = groups[index];
//                 final groupId = group['groupId'];
//                 final groupName = group['groupName'];
//                 final admin = group['admin'];
//                 final purpose = group['purpose'];
//                 final description = group['description'];
//                 final rules = group['rules'];

//                 return StreamBuilder<DocumentSnapshot>(
//                   stream: ChatDatabase().getGroupData(groupId),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const SizedBox();
//                     }

//                     if (snapshot.hasData) {
//                       final groupData = snapshot.data!;

//                       final isMember =
//                           groupData['members'].contains(user?.uid ?? '');

//                       return isMember
//                           ? joinedGroupTile(
//                               userName,
//                               groupId,
//                               groupName,
//                               admin,
//                               purpose,
//                               description,
//                               rules,
//                             )
//                           : groupTile(
//                               userName,
//                               groupId,
//                               groupName,
//                               admin,
//                               purpose,
//                               description,
//                               rules,
//                             );
//                     }

//                     return const SizedBox();
//                   },
//                 );
//               },
//             );
//           }

//           return Container();
//         },
//       ),
//     );
//   }

//   Widget groupTile(String userName, String groupId, String groupName,
//       String admin, String purpose, String description, String rules) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TrialPage(
//                 groupId: groupId,
//                 groupName: groupName,
//                 purpose: purpose,
//                 description: description,
//                 rules: rules,
//                 userName: userName),
//           ),
//         );
//       },
//       child: ListTile(
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         leading: CircleAvatar(
//           radius: 30,
//           backgroundColor: Theme.of(context).primaryColor,
//           child: Text(
//             groupName.substring(0, 1).toUpperCase(),
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//         title: Text(
//           groupName,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         trailing: InkWell(
//           onTap: () async {
//             await ChatDatabase(uid: user!.uid)
//                 .toggleGroupJoin(groupId, userName, groupName);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("Successfully joined the group"),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Theme.of(context).primaryColor,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: const Text(
//               "Join Now",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget joinedGroupTile(String userName, String groupId, String groupName,
//       String admin, String purpose, String description, String rules) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       leading: CircleAvatar(
//         radius: 30,
//         backgroundColor: Theme.of(context).primaryColor,
//         child: Text(
//           groupName.substring(0, 1).toUpperCase(),
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       title: Text(
//         groupName,
//         style: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//       trailing: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.grey[400],
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: const Text(
//           'Already Joined',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
