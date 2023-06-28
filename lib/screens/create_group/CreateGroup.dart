// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/components/navigation/navigation_bar.dart';
// import 'package:relate/screens/community/communities_screen.dart';
// import 'package:relate/screens/create_group/flag_keywords.dart';
// import 'package:relate/services/chat_database_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// //image
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class CreateGroup extends StatefulWidget {
//   const CreateGroup({Key? key}) : super(key: key);

//   @override
//   State<CreateGroup> createState() => _CreateGroupState();
// }

// class _CreateGroupState extends State<CreateGroup> {
//   String userName = "";
//   String email = "";
//   // AuthService authService = AuthService();
//   Stream? groups;
//   bool _isLoading = false;
//   String groupName = "";

//   //text editing controllers
//   TextEditingController rulesController = TextEditingController();
//   TextEditingController purposeController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController groupNameController = TextEditingController();

//   File? _selectedImage;
//   final _formKey = GlobalKey<FormState>();

// //this is static
//   final List<String> bannedKeywords = [
//     'fuck',
//     'ass',
//     'keyword3',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     getUserName();
//   }

//   Future<void> getUserName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('userName') ?? "";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_outlined),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Communities()),
//               );
//             },
//           ),
//           title: Text("Create Group"),
//           centerTitle: true,
//           // backgroundColor: Color(0xFF009688),
//         ),
//         body: Container(
//           padding: EdgeInsets.only(left: 15, top: 20, right: 15),
//           child: GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: StreamBuilder<Object>(
//               builder: (context, setState) {
//                 return StatefulBuilder(
//                   builder: (BuildContext context, StateSetter innerSetState) {
//                     return ListView(
//                       padding: EdgeInsets.only(left: 5, right: 5),
//                       children: [
//                         Center(
//                           child: Stack(
//                             children: [
//                               Container(
//                                 width: 130,
//                                 height: 139,
//                                 decoration: BoxDecoration(
//                                   border:
//                                       Border.all(width: 4, color: Colors.white),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       spreadRadius: 2,
//                                       blurRadius: 10,
//                                       color: Colors.black.withOpacity(0.1),
//                                     ),
//                                   ],
//                                   shape: BoxShape.circle,
//                                   image: DecorationImage(
//                                     image: NetworkImage(
//                                       'https://cdn.pixabay.com/photo/2023/05/01/15/17/water-7963286_960_720.jpg',
//                                     ),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                         width: 4, color: Colors.white),
//                                     color: Colors.blue,
//                                   ),
//                                   child: Icon(Icons.edit, color: Colors.white),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               SizedBox(height: 60),
//                               nameTextField(),
//                               SizedBox(height: 20),
//                               rulesTextField(),
//                               SizedBox(height: 30),
//                               purposeTextField(),
//                               SizedBox(height: 30),
//                               descriptionTextField(),
//                               SizedBox(height: 40),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             SizedBox(width: 50),
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('Cancel'),
//                               style: ElevatedButton.styleFrom(
//                                 fixedSize: Size(110, 20),
//                                 primary: Colors.red,
//                                 onPrimary: Colors.white,
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(40),
//                                 ),
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 if (_formKey.currentState.validate()) {
//                                   // Form is valid, perform the create group operation
//                                   innerSetState(() {
//                                     _isLoading = true;
//                                   });

//                                   // Retrieve the values from the controllers
//                                   String purpose = purposeController.text;
//                                   String rules = rulesController.text;
//                                   String description =
//                                       descriptionController.text;

//                                   await ChatDatabase(
//                                     uid: FirebaseAuth.instance.currentUser!.uid,
//                                   ).createGroup(
//                                     userName,
//                                     FirebaseAuth.instance.currentUser!.uid,
//                                     groupName,
//                                     email,
//                                     purpose,
//                                     rules,
//                                     description,
//                                   );

//                                   innerSetState(() {
//                                     _isLoading = false;
//                                   });

//                                   Navigator.of(context).pop();
//                                   showSnackbar(
//                                     context,
//                                     Colors.green,
//                                     "Group has been created successfully.",
//                                   );
//                                 }
//                               },
//                               child: const Text("Create Group"),
//                             ),
//                             SizedBox(width: 20),
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ));
//   }

//   Widget nameTextField() {
//     return TextFormField(
//       controller: groupNameController,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Colors.teal,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Color(0xFF009688),
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.group,
//           color: Colors.green,
//         ),
//         labelText: "Group Name",

//         // helperText: "Fields Can not be empty" should describe about the field
//       ),
//       onChanged: (value) {
//         groupName = value; // Assign the input value to the groupName variable
//       },
//     );
//   }

//   Widget purposeTextField() {
//     return TextFormField(
//       controller: purposeController,
//       maxLines: null,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Colors.teal,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Color(0xFF009688),
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.lightbulb,
//           color: Colors.green,
//         ),
//         labelText: "Group Purpose",
//         // helperText: "Fields Can not be empty" should describe about the field
//       ),
//     );
//   }

//   Widget descriptionTextField() {
//     return TextFormField(
//       controller: descriptionController,
//       maxLines: null,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Colors.teal,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Color(0xFF009688),
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.description,
//           color: Colors.green,
//         ),
//         labelText: "Group Description",
//         // helperText: "Fields Can not be empty" should describe about the field
//       ),
//     );
//   }

//   Widget rulesTextField() {
//     return TextFormField(
//       controller: rulesController,
//       maxLines: null,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Colors.teal,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderSide: BorderSide(
//             color: Color(0xFF009688),
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.rule,
//           color: Colors.green,
//         ),
//         labelText: "Group rules",
//         // helperText: "Fields Can not be empty" should describe about the field
//       ),
//     );
//   }

//   void showSnackbar(context, color, message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(fontSize: 14),
//         ),
//         backgroundColor: color,
//         duration: const Duration(seconds: 2),
//         action: SnackBarAction(
//           label: "OK",
//           onPressed: () {},
//           textColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/content_filter.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/components/textfield_filter.dart';
import 'package:relate/screens/community/communities_screen.dart';
import 'package:relate/screens/create_group/flag_keywords.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  TextEditingController rulesController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();

  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();

  final List<String> bannedKeywords = [
    'fuck',
    'ass',
    'keyword3',
  ];

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "";
    });
  }

  void flagOrFilterContent(
      BuildContext context, String content, List<String> bannedKeywords) {
    bool containsBannedKeyword =
        checkForBannedKeywords(content, bannedKeywords);

    if (containsBannedKeyword) {
      flagContentForReview(content);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Content Violation'),
          content: const Text('Your message contains banned keywords.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Proceed with normal handling of the content
    }
  }

  bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
    for (String keyword in bannedKeywords) {
      if (content.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  void flagContentForReview(String content) {
    // Here, you can implement the logic to flag the content for manual review
    // You can store the flagged content in a database or notify your moderation team
    // for further action
    print('Content flagged for review: $content');
  }

  void showSnackbar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  void checkAndCreateGroup() async {
    String groupName = groupNameController.text;
    String rules = rulesController.text;
    String purpose = purposeController.text;
    String description = descriptionController.text;

    // Check if any of the fields contain banned keywords
    bool containsBannedKeyword = false;
    List<String> contentList = [groupName, rules, purpose, description];
    for (String content in contentList) {
      if (checkForBannedKeywords(content, bannedKeywords)) {
        containsBannedKeyword = true;
        break;
      }
    }

    if (containsBannedKeyword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Content Violation'),
          content: const Text('One or more fields contain banned keywords.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Proceed with creating the group
      setState(() {
        _isLoading = true;
      });

      // Retrieve the values from the controllers
      Future<void> getUserName() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          userName = prefs.getString('userName') ?? "";
        });
      }

      String uid = FirebaseAuth.instance.currentUser!.uid;
      String email = ""; // Set the appropriate email value

      await ChatDatabase(uid: uid).createGroup(
        userName,
        uid,
        groupName,
        email,
        purpose,
        rules,
        description,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
      showSnackbar(
        context,
        Colors.green,
        "Group has been created successfully.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Communities()),
            );
          },
        ),
        title: Text("Create Group"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StreamBuilder<Object>(
            builder: (context, setState) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter innerSetState) {
                  return ListView(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 139,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2023/05/01/15/17/water-7963286_960_720.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  color: Colors.blue,
                                ),
                                child:
                                    const Icon(Icons.edit, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            TextFilter(
                              controller: groupNameController,
                              labelText: "Group Name",
                              onFieldSubmitted: (content) =>
                                  flagOrFilterContent(
                                context,
                                content,
                                bannedKeywords,
                              ),
                              validator: (content) {
                                if (content.isEmpty) {
                                  return "Group name is required.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFilter(
                              controller: rulesController,
                              labelText: "Rules",
                              onFieldSubmitted: (content) =>
                                  flagOrFilterContent(
                                context,
                                content,
                                bannedKeywords,
                              ),
                              validator: (content) {
                                if (content.isEmpty) {
                                  return "Rules are required.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFilter(
                              controller: purposeController,
                              labelText: "Purpose",
                              onFieldSubmitted: (content) =>
                                  flagOrFilterContent(
                                context,
                                content,
                                bannedKeywords,
                              ),
                              validator: (content) {
                                if (content.isEmpty) {
                                  return "Purpose is required.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFilter(
                              controller: descriptionController,
                              labelText: "Description",
                              onFieldSubmitted: (content) =>
                                  flagOrFilterContent(
                                context,
                                content,
                                bannedKeywords,
                              ),
                              validator: (content) {
                                if (content.isEmpty) {
                                  return "Description is required.";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 13),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 50),
                              primary: Colors.red,
                              onPrimary: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                checkAndCreateGroup();
                              }
                            },
                            child: Text(
                              "Create",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(140, 50),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ), // Set the desired width and height
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
      // bottomNavigationBar:  NavigationBar(),
    );
  }
}
