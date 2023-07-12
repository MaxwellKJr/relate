// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/screens/chat/chat_screen.dart';
// import 'package:relate/services/chat_database_services.dart';
// import 'package:relate/services/helper_functions.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SearchAndJoin extends StatefulWidget {
//   final String imageUrl;
//   final String description;
//   final String groupId;
//   final String groupName;
//   final String purpose;
//   final String rules;
//   final String userName;
//   const SearchAndJoin({
//     Key? key,
//     required this.imageUrl,
//     required this.description,
//     required this.userName,
//     required this.groupId,
//     required this.groupName,
//     required this.purpose,
//     required this.rules,
//   }) : super(key: key);

//   @override
//   State<SearchAndJoin> createState() => _SearchAndJoinState();
// }

// class _SearchAndJoinState extends State<SearchAndJoin> {
//   TextEditingController searchController = TextEditingController();
//   bool isLoading = false;
//   QuerySnapshot? searchSnapshot;
//   bool hasUserSearched = false;
//   String userName = "";
//   bool isJoined = false;
//   User? user;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   // getCurrentUser() async {
//   //   await HelperFunctions.getUserNameFromshowgroups().then((value) {
//   //     setState(() {
//   //       userName = value!;
//   //     });
//   //   });
//   //   user = FirebaseAuth.instance.currentUser;
//   // }

//   getCurrentUser() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var storedUserName = localStorage.getString('userName');

//     setState(() {
//       userName = storedUserName ??
//           ""; // Use the stored user name from shared preferences
//     });

//     user = FirebaseAuth.instance.currentUser;
//   }

//   String getName(String r) {
//     return r.substring(r.indexOf("_") + 1);
//   }

//   String getId(String res) {
//     return res.substring(0, res.indexOf("_"));
//   }

//   void showSnackbar(BuildContext context, Color color, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text(
//           "Search",
//           style: TextStyle(
//               fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Theme.of(context).primaryColor,
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: searchController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Search groups....",
//                         hintStyle:
//                             TextStyle(color: Colors.white, fontSize: 16)),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     initiateSearchMethod();
//                   },
//                   child: Container(
//                     width: 40,
//                     height: 30,
//                     decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(40)),
//                     child: const Icon(
//                       Icons.search,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           isLoading
//               ? Center(
//                   child: CircularProgressIndicator(
//                       color: Theme.of(context).primaryColor),
//                 )
//               : groupList(),
//         ],
//       ),
//     );
//   }

//   initiateSearchMethod() async {
//     if (searchController.text.isNotEmpty) {
//       setState(() {
//         isLoading = true;
//       });
//       await ChatDatabase()
//           .searchGroupName(
//               searchController.text.toLowerCase()) // Convert input to lowercase
//           .then((snapshot) {
//         setState(() {
//           searchSnapshot = snapshot;
//           isLoading = false;
//           hasUserSearched = true;
//         });
//       });
//     }
//   }

//   groupList() {
//     return hasUserSearched
//         ? ListView.builder(
//             shrinkWrap: true,
//             itemCount: searchSnapshot!.docs.length,
//             itemBuilder: (context, index) {
//               return groupTile(
//                 userName,
//                 searchSnapshot!.docs[index]['groupId'],
//                 searchSnapshot!.docs[index]['groupName'],
//                 searchSnapshot!.docs[index]['admin'],
//                 searchSnapshot!.docs[index]['imageUrl'],
//               );
//             },
//           )
//         : Container();
//   }

//   joinedOrNot(
//       String userName, String groupId, String groupname, String admin) async {
//     await ChatDatabase(uid: user!.uid)
//         .isUserJoined(groupname, groupId, userName)
//         .then((value) {
//       setState(() {
//         isJoined = value;
//       });
//     });
//   }

//   Widget groupTile(String userName, String groupId, String groupName,
//       String admin, String imageUrl) {
//     // This functions cross checks if a user is in the group
//     joinedOrNot(userName, groupId, groupName, admin);
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       leading: CircleAvatar(
//         radius: 30,
//         backgroundColor: Theme.of(context).primaryColor,
//         child: Image.network(
//           widget.imageUrl,
//           fit: BoxFit.cover,
//         ),
//       ),
//       title:
//           Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
//       subtitle: Text("Admin: ${getName(admin)}"),
//       trailing: InkWell(
//         onTap: () async {
//           await ChatDatabase(uid: user!.uid)
//               .toggleGroupJoin(groupId, userName, groupName);
//           if (isJoined) {
//             setState(() {
//               isJoined = !isJoined;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text("Successfully joined the group"),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             showSnackbar(context, Colors.green, "Successfully joined he group");
//             Future.delayed(const Duration(seconds: 2), () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(
//                     imageUrl: imageUrl,
//                     groupId: groupId,
//                     admin: admin,
//                     groupName: groupName,
//                     userName: userName,
//                     description: widget.description,
//                     purpose: widget.purpose,
//                     rules: widget.rules,
//                   ),
//                 ),
//               );
//             });
//           } else {
//             setState(() {
//               isJoined = !isJoined;
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text("Successfully joined the group"),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//               // showSnackbar(context, Colors.red, "Left the group $groupName");
//             });
//           }
//         },
//         child: isJoined
//             ? Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.black,
//                   border: Border.all(color: Colors.white, width: 1),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: const Text(
//                   "Joined",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               )
//             //sdf
//             : Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: const Text("Join Now",
//                     style: TextStyle(color: Colors.white)),
//               ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:relate/services/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchAndJoin extends StatefulWidget {
  final String imageUrl;
  final String description;
  final String groupId;
  final String groupName;
  final String purpose;
  final String rules;
  final String userName;

  const SearchAndJoin({
    Key? key,
    required this.imageUrl,
    required this.description,
    required this.userName,
    required this.groupId,
    required this.groupName,
    required this.purpose,
    required this.rules,
  }) : super(key: key);

  @override
  State<SearchAndJoin> createState() => _SearchAndJoinState();
}

class _SearchAndJoinState extends State<SearchAndJoin> {
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

  void showSnackbar(BuildContext context, Color color, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
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
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search groups....",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await ChatDatabase()
          .searchGroupName(
              searchController.text.toLowerCase()) // Convert input to lowercase
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
                searchSnapshot!.docs[index]['imageUrl'],
              );
            },
          )
        : Container();
  }

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

  Widget groupTile(String userName, String groupId, String groupName,
      String admin, String imageUrl) {
    // This function cross checks if a user is in the group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
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
            showSnackbar(
                context, Colors.green, "Successfully joined the group");
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    imageUrl: imageUrl,
                    groupId: groupId,
                    admin: admin,
                    groupName: groupName,
                    userName: userName,
                    description: widget.description,
                    purpose: widget.purpose,
                    rules: widget.rules,
                  ),
                ),
              );
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
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Join Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
//The SearchAndJoin widget represents a page where users can search for groups and join them. 
//It includes a search bar where users can enter the group name, and the matching groups are displayed in a list. 
//Users can join the groups by clicking on the "Join Now" button. 
//The widget also checks if the user has already joined a group and updates the UI accordingly.