// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:relate/components/navigation/main_home.dart';
// import 'package:relate/services/chat_database_services.dart';

// class GroupJoinedChatInforr extends StatefulWidget {
//   final String groupId;
//   final String groupName;
//   final String admin;
//   final String rules;
//   final String description;
//   final String purpose;
//   const GroupJoinedChatInforr(
//       {Key? key,
//       required this.admin,
//       required this.groupName,
//       required this.purpose,
//       required this.rules,
//       required this.description,
//       required this.groupId})
//       : super(key: key);

//   @override
//   State<GroupJoinedChatInforr> createState() => _GroupJoinedChatInforrState();
// }

// class _GroupJoinedChatInforrState extends State<GroupJoinedChatInforr> {
//   Stream? members;

//   @override
//   void initState() {
//     getUserMembers();
//     super.initState();
//   }

//   getUserMembers() async {
//     try {
//       List<String> val = await ChatDatabase(
//               uid: FirebaseAuth.instance.currentUser!.uid)
//           .groupMembers(widget.groupId)
//           .first; // Use `.first` to get the first value from the stream immediately
//       setState(() {
//         members = val as Stream?;
//       });
//     } catch (error) {
//       // Handle any potential errors that occurred during the database operation
//       print('Error: $error');
//     }
//   }

//   String getName(String r) {
//     return r.substring(r.indexOf("_") + 1);
//   }

//   String getId(String res) {
//     return res.substring(0, res.indexOf("_"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text("Group Info"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 showDialog(
//                     barrierDismissible: false,
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text("Exit"),
//                         content:
//                             const Text("Are you sure you exit the group? "),
//                         actions: [
//                           IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(
//                               Icons.cancel,
//                               color: Colors.red,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               await ChatDatabase(
//                                       uid: FirebaseAuth
//                                           .instance.currentUser!.uid)
//                                   .toggleGroupJoin(widget.groupId,
//                                       getName(widget.admin), widget.groupName)
//                                   .whenComplete(() {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const MainHomeScreen(),
//                                   ),
//                                 );
//                               });
//                             },
//                             icon: const Icon(
//                               Icons.done,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ],
//                       );
//                     });
//               },
//               icon: const Icon(Icons.exit_to_app))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 leading: const CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage('assets/images/placeholderr.jpg'),
//                 ),
//                 title: Text(
//                   widget.groupName,
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: const Text(
//                   '4 members',
//                   style: TextStyle(fontSize: 19),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Description',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.description,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Purpose',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.purpose,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Rules',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.rules,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // memberUsersList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:relate/components/navigation/main_home.dart';
// import 'package:relate/screens/community/communities_screen.dart';
// import 'package:relate/services/chat_database_services.dart';

// class GroupJoinedChatInforr extends StatefulWidget {
//   final String groupId;
//   final String groupName;
//   final String admin;
//   final String rules;
//   final String description;
//   final String purpose;
//   const GroupJoinedChatInforr(
//       {Key? key,
//       required this.admin,
//       required this.groupName,
//       required this.purpose,
//       required this.rules,
//       required this.description,
//       required this.groupId})
//       : super(key: key);

//   @override
//   State<GroupJoinedChatInforr> createState() => _GroupJoinedChatInforrState();
// }

// class _GroupJoinedChatInforrState extends State<GroupJoinedChatInforr> {
//   Stream? members;

//   @override
//   void initState() {
//     getUserMembers();
//     super.initState();
//   }

//   getUserMembers() async {
//     try {
//       List<String> val = await ChatDatabase(
//               uid: FirebaseAuth.instance.currentUser!.uid)
//           .groupMembers(widget.groupId)
//           .first; // Use `.first` to get the first value from the stream immediately
//       setState(() {
//         members = val as Stream?;
//       });
//     } catch (error) {
//       // Handle any potential errors that occurred during the database operation
//       print('Error: $error');
//     }
//   }

//   String getName(String r) {
//     return r.substring(r.indexOf("_") + 1);
//   }

//   String getId(String res) {
//     return res.substring(0, res.indexOf("_"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text("Group Info"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 showDialog(
//                     barrierDismissible: false,
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text("Exit"),
//                         content:
//                             const Text("Are you sure you exit the group? "),
//                         actions: [
//                           IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(
//                               Icons.cancel,
//                               color: Colors.red,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               await ChatDatabase(
//                                       uid: FirebaseAuth
//                                           .instance.currentUser!.uid)
//                                   .toggleGroupJoin(widget.groupId,
//                                       getName(widget.admin), widget.groupName)
//                                   .whenComplete(() {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const Communities(),
//                                   ),
//                                 );
//                               });
//                             },
//                             icon: const Icon(
//                               Icons.done,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ],
//                       );
//                     });
//               },
//               icon: const Icon(Icons.exit_to_app))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 leading: const CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage('assets/images/placeholderr.jpg'),
//                 ),
//                 title: Text(
//                   widget.groupName,
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: const Text(
//                   '4 members',
//                   style: TextStyle(fontSize: 19),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Description',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.description,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Purpose',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.purpose,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Rules',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.rules,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // memberUsersList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:relate/components/navigation/main_home.dart';
// import 'package:relate/screens/community/communities_screen.dart';
// import 'package:relate/services/chat_database_services.dart';

// class GroupJoinedChatInforr extends StatefulWidget {
//   final String groupId;
//   final String groupName;
//   final String admin;
//   final String rules;
//   final String description;
//   final String purpose;
//   const GroupJoinedChatInforr(
//       {Key? key,
//       required this.admin,
//       required this.groupName,
//       required this.purpose,
//       required this.rules,
//       required this.description,
//       required this.groupId})
//       : super(key: key);

//   @override
//   State<GroupJoinedChatInforr> createState() => _GroupJoinedChatInforrState();
// }

// class _GroupJoinedChatInforrState extends State<GroupJoinedChatInforr> {
//   Stream? members;

//   @override
//   void initState() {
//     getUserMembers();
//     super.initState();
//   }

//   getUserMembers() async {
//     try {
//       List<String> val = await ChatDatabase(
//               uid: FirebaseAuth.instance.currentUser!.uid)
//           .groupMembers(widget.groupId)
//           .first; // Use `.first` to get the first value from the stream immediately
//       setState(() {
//         members = val as Stream?;
//       });
//     } catch (error) {
//       // Handle any potential errors that occurred during the database operation
//       print('Error: $error');
//     }
//   }

//   String getName(String r) {
//     return r.substring(r.indexOf("_") + 1);
//   }

//   String getId(String res) {
//     return res.substring(0, res.indexOf("_"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text("Group Info"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text("Exit"),
//                     content:
//                         const Text("Are you sure you want to exit the group?"),
//                     actions: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.cancel,
//                           color: Colors.red,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () async {
//                           await ChatDatabase(
//                             uid: FirebaseAuth.instance.currentUser!.uid,
//                           )
//                               .toggleGroupJoin(
//                             widget.groupId,
//                             getName(widget.admin),
//                             widget.groupName,
//                           )
//                               .whenComplete(() {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const Communities(),
//                               ),
//                             );
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.done,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             icon: const Icon(Icons.exit_to_app),
//           ),
//         ],
//       ),
//       body: DefaultTabController(
//         length: 2,
//         child: Column(
//           children: [
//             TabBar(
//               tabs: [
//                 Tab(text: 'Group Details'),
//                 Tab(text: 'Pending Request'),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ListTile(
//                             leading: const CircleAvatar(
//                               radius: 50,
//                               backgroundImage:
//                                   AssetImage('assets/images/placeholderr.jpg'),
//                             ),
//                             title: Text(
//                               widget.groupName,
//                               style: const TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: const Text(
//                               '4 members',
//                               style: TextStyle(fontSize: 19),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Description',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Align(
//                             alignment: Alignment.topLeft,
//                             child: Text(
//                               widget.description,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Purpose',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Align(
//                             alignment: Alignment.topLeft,
//                             child: Text(
//                               widget.purpose,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Rules',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Align(
//                             alignment: Alignment.topLeft,
//                             child: Text(
//                               widget.rules,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                               textAlign: TextAlign.justify,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           // memberUsersList(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: const Text("Content for Tab as an adminstrator"),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 leading: const CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage('assets/images/placeholderr.jpg'),
//                 ),
//                 title: Text(
//                   widget.groupName,
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: const Text(
//                   '4 members',
//                   style: TextStyle(fontSize: 19),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Description',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.description,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Purpose',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.purpose,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Rules',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   widget.rules,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // memberUsersList(),
//             ],
//           ),
//         ),
//       ),
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/navigation/main_home.dart';
import 'package:relate/screens/community/communities_screen.dart';
import 'package:relate/services/chat_database_services.dart';

class GroupJoinedChatInfor extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String admin;
  final String rules;
  final String description;
  final String purpose;

  const GroupJoinedChatInfor({
    Key? key,
    required this.admin,
    required this.groupName,
    required this.purpose,
    required this.rules,
    required this.description,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupJoinedChatInfor> createState() => _GroupJoinedChatInforState();
}

class _GroupJoinedChatInforState extends State<GroupJoinedChatInfor> {
  bool get isAdmin => FirebaseAuth.instance.currentUser!.uid == widget.admin;

  Stream? members;

  @override
  void initState() {
    getUserMembers();
    super.initState();
  }

  getUserMembers() async {
    try {
      List<String> val =
          await ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
              .groupMembers(widget.groupId)
              .first;
      setState(() {
        members = val as Stream?;
      });
    } catch (error) {
      print('Error: $error');
    }
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
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Exit"),
                    content:
                        const Text("Are you sure you want to exit the group?"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ChatDatabase(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                          )
                              .toggleGroupJoin(
                            widget.groupId,
                            getName(widget.admin),
                            widget.groupName,
                          )
                              .whenComplete(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Communities(),
                              ),
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: isAdmin
          ? DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Group Details'),
                      Tab(text: 'Pending Request'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                        'assets/images/placeholderr.jpg'),
                                  ),
                                  title: Text(
                                    widget.groupName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Admin: ${getName(widget.admin)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Purpose",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.purpose,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Rules",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.rules,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: const Text(
                            "Content for Tab as an administrator",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/placeholderr.jpg'),
                      ),
                      title: Text(
                        widget.groupName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        "Admin: ${getName(widget.admin)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Purpose",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.purpose,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Rules",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.rules,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
