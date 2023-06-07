import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:relate/services/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo({super.key});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // getCurrentUser() async {
  //   await HelperFunctions.getUserNameFromshowgroups().then((value) {
  //     setState(() {
  //       userName = value!;
  //     });
  //   });
  //   user = FirebaseAuth.instance.currentUser;
  // }

  getCurrentUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var storedUserName = localStorage.getString('userName');

    setState(() {
      userName = storedUserName ??
          ""; // Use the stored user name from shared preferences
    });

    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          List<DocumentSnapshot> groups = snapshot.data!.docs;

          if (groups.isEmpty) {
            return noGroupWidget();
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              String groupId = groups[index]['id'];
              String groupName = groups[index]['groupName'];

              return groupTile(
                userName,
                groupId,
                groupName,
                groups[index]['admin'],
              );
            },
          );
        },
      ),
    );
  }

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

//  Widget allGroupList() {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
//           .getAllGroups(),
//       builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//         if (!snapshot.hasData) {
//           return const Text('No data available');
//         }

//         List<Map<String, dynamic>> groups = snapshot.data!;

//         if (groups.isEmpty) {
//           return noGroupWidget();
//         }

//         return ListView.builder(
//           itemCount: groups.length,
//           itemBuilder: (context, index) {
//             String groupId = groups[index]['id'];
//             String groupName = groups[index]['groupName'];

//             return GroupCards(
//               groupId: groupId,
//               userName: userName,
//               groupName: groupName,
//             );
//           },
//         );
//       },
//     );
//   }

  // groupList() {
  //   return hasUserSearched
  //       ? ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: searchSnapshot!.docs.length,
  //           itemBuilder: (context, index) {
  //             return groupTile(
  //               userName,
  //               searchSnapshot!.docs[index]['groupId'],
  //               searchSnapshot!.docs[index]['groupName'],
  //               searchSnapshot!.docs[index]['admin'],
  //             );
  //           },
  //         )
  //       : Container();
  // }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await ChatDatabase(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    // fThis functions cross checks if a user is in the group
    joinedOrNot(userName, groupId, groupName, admin);
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
      title:
          Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await ChatDatabase(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully joined the group"),
                backgroundColor: Colors.green,
              ),
            );
            // showSnackbar(context, Colors.green, "Successfully joined he group");
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    groupId: groupId,
                    groupName: groupName,
                    // userName: userName,
                  ),
                ),
              );

              // nextScreen(
              //     context,
              //     ChatScreen(
              //         groupId: groupId,
              //         groupName: groupName,
              //         userName: userName));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Successfully joined the group"),
                  backgroundColor: Colors.green,
                ),
              );
              // showSnackbar(context, Colors.red, "Left the group $groupName");
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            //sdf
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text("Join Now",
                    style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }
}
