// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/components/content_filter.dart';
// import 'package:relate/components/navigation/navigation_bar.dart';
// import 'package:relate/components/textfield_filter.dart';
// import 'package:relate/screens/community/communities_screen.dart';
// import 'package:relate/screens/create_group/flag_keywords.dart';
// import 'package:relate/services/chat_database_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//   Stream? groups;
//   bool _isLoading = false;
//   String groupName = "";
//   String imageUrl = '';

//   TextEditingController rulesController = TextEditingController();
//   TextEditingController purposeController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController groupNameController = TextEditingController();

//   File? _selectedImage;
//   final _formKey = GlobalKey<FormState>();

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

//   void flagOrFilterContent(
//       BuildContext context, String content, List<String> bannedKeywords) {
//     bool containsBannedKeyword =
//         checkForBannedKeywords(content, bannedKeywords);

//     if (containsBannedKeyword) {
//       flagContentForReview(content);
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Content Violation'),
//           content: const Text('Your message contains banned keywords.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Proceed with normal handling of the content
//     }
//   }

//   bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
//     for (String keyword in bannedKeywords) {
//       if (content.toLowerCase().contains(keyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

//   void flagContentForReview(String content) {
//     // Here, you can implement the logic to flag the content for manual review
//     // You can store the flagged content in a database or notify your moderation team
//     // for further action
//     print('Content flagged for review: $content');
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

//   void checkAndCreateGroup() async {
//     String groupName = groupNameController.text;
//     String rules = rulesController.text;
//     String purpose = purposeController.text;
//     String description = descriptionController.text;

//     // Check if any of the fields contain banned keywords
//     bool containsBannedKeyword = false;
//     List<String> contentList = [groupName, rules, purpose, description];
//     for (String content in contentList) {
//       if (checkForBannedKeywords(content, bannedKeywords)) {
//         containsBannedKeyword = true;
//         break;
//       }
//     }

//     if (containsBannedKeyword) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Content Violation'),
//           content: const Text('One or more fields contain banned keywords.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Proceed with creating the group
//       setState(() {
//         _isLoading = true;
//       });

//       // Retrieve the values from the controllers
//       Future<void> getUserName() async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         setState(() {
//           userName = prefs.getString('userName') ?? "";
//         });
//       }

//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       String email = ""; // Set the appropriate email value

//       await ChatDatabase(uid: uid).createGroup(
//         userName,
//         uid,
//         groupName,
//         email,
//         purpose,
//         rules,
//         description,
//       );

//       setState(() {
//         _isLoading = false;
//       });

//       Navigator.of(context).pop();
//       showSnackbar(
//         context,
//         Colors.green,
//         "Group has been created successfully.",
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_outlined),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Communities()),
//             );
//           },
//         ),
//         title: Text("Create Group"),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: EdgeInsets.only(left: 15, top: 20, right: 15),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: StreamBuilder<Object>(
//             builder: (context, setState) {
//               return StatefulBuilder(
//                 builder: (BuildContext context, StateSetter innerSetState) {
//                   return ListView(
//                     padding: EdgeInsets.only(left: 5, right: 5),
//                     children: [
//                       Center(
//                         child: Stack(
//                           children: [
//                             Container(
//                               width: 130,
//                               height: 139,
//                               decoration: BoxDecoration(
//                                 border:
//                                     Border.all(width: 4, color: Colors.white),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     spreadRadius: 2,
//                                     blurRadius: 10,
//                                     color: Colors.black.withOpacity(0.1),
//                                   ),
//                                 ],
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                     'https://cdn.pixabay.com/photo/2023/05/01/15/17/water-7963286_960_720.jpg',
//                                   ),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border:
//                                       Border.all(width: 4, color: Colors.white),
//                                   color: Colors.blue,
//                                 ),
//                                 child:
//                                     //       const Icon(Icons.edit, color: Colors.white),

//                                     OutlinedButton.icon(
//                                         onPressed: () async {
//                                           ImagePicker imagePicker =
//                                               ImagePicker();
//                                           XFile? file =
//                                               await imagePicker.pickImage(
//                                                   source: ImageSource.gallery);
//                                           print('${file?.path}');

//                                           if (file == null) return;
//                                           String uniqueImageName =
//                                               DateTime.now()
//                                                   .millisecondsSinceEpoch
//                                                   .toString();

//                                           Reference referenceRoot =
//                                               FirebaseStorage.instance.ref();
//                                           Reference referenceDirImages =
//                                               referenceRoot.child('images');

//                                           Reference imageReferenceToUpload =
//                                               referenceDirImages
//                                                   .child(uniqueImageName);

//                                           await imageReferenceToUpload
//                                               .putFile(File(file.path));
//                                           imageUrl =
//                                               await imageReferenceToUpload
//                                                   .getDownloadURL();
//                                         },
//                                         icon: const Icon(Icons.edit,
//                                             color: Colors.white),
//                                         label: const Text("Choose Image")),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 60),
//                             TextFilter(
//                               controller: groupNameController,
//                               labelText: "Group Name",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Group name is required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             TextFilter(
//                               controller: rulesController,
//                               labelText: "Rules",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Rules are required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             TextFilter(
//                               controller: purposeController,
//                               labelText: "Purpose",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Purpose is required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             TextFilter(
//                               controller: descriptionController,
//                               labelText: "Description",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Description is required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Row(
//                         children: [
//                           const SizedBox(width: 13),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Cancel'),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(150, 50),
//                               primary: Colors.red,
//                               onPrimary: Colors.white,
//                               elevation: 5,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 30),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 checkAndCreateGroup();
//                               }
//                             },
//                             child: Text(
//                               "Create",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(140, 50),
//                               elevation: 5,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                               ), // Set the desired width and height
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//       // bottomNavigationBar:  NavigationBar(),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/components/content_filter.dart';
// import 'package:relate/components/navigation/navigation_bar.dart';
// import 'package:relate/components/textfield_filter.dart';
// import 'package:relate/screens/community/communities_screen.dart';
// import 'package:relate/screens/create_group/flag_keywords.dart';
// import 'package:relate/services/chat_database_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//   Stream? groups;
//   bool _isLoading = false;
//   String groupName = "";
//   String imageUrl = '';
//  File? _selectedImage;

//   TextEditingController rulesController = TextEditingController();
//   TextEditingController purposeController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController groupNameController = TextEditingController();

//   // File? _selectedImage;
//   final _formKey = GlobalKey<FormState>();

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

//   void flagOrFilterContent(
//       BuildContext context, String content, List<String> bannedKeywords) {
//     bool containsBannedKeyword =
//         checkForBannedKeywords(content, bannedKeywords);

//     if (containsBannedKeyword) {
//       flagContentForReview(content);
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Content Violation'),
//           content: const Text('Your message contains banned keywords.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Proceed with normal handling of the content
//     }
//   }

//   bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
//     for (String keyword in bannedKeywords) {
//       if (content.toLowerCase().contains(keyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

//   void flagContentForReview(String content) {
//     // Here, you can implement the logic to flag the content for manual review
//     // You can store the flagged content in a database or notify your moderation team
//     // for further action
//     print('Content flagged for review: $content');
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

//   void checkAndCreateGroup() async {
//     String groupName = groupNameController.text;
//     String rules = rulesController.text;
//     String purpose = purposeController.text;
//     String description = descriptionController.text;

//     // Check if any of the fields contain banned keywords
//     bool containsBannedKeyword = false;
//     List<String> contentList = [groupName, rules, purpose, description];
//     for (String content in contentList) {
//       if (checkForBannedKeywords(content, bannedKeywords)) {
//         containsBannedKeyword = true;
//         break;
//       }
//     }

//     if (containsBannedKeyword) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Content Violation'),
//           content: const Text('One or more fields contain banned keywords.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Proceed with creating the group
//       setState(() {
//         _isLoading = true;
//       });

//       // Retrieve the values from the controllers
//       Future<void> getUserName() async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         setState(() {
//           userName = prefs.getString('userName') ?? "";
//         });
//       }

//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       String email = ""; // Set the appropriate email value

//       await ChatDatabase(uid: uid).createGroup(
//         userName,
//         uid,
//         groupName,
//         email,
//         purpose,
//         rules,
//         description,
//       );

//       setState(() {
//         _isLoading = false;
//       });

//       Navigator.of(context).pop();
//       showSnackbar(
//         context,
//         Colors.green,
//         "Group has been created successfully.",
//       );
//     }
//   }

//   Future<void> selectImage() async {
//     ImagePicker imagePicker = ImagePicker();
//     XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
//     if (file != null) {
//       setState(() {
//         _selectedImage = File(file.path);
//       });
//     }
//   }

//   @override

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Create Group"),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(15),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ListView(
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 130,
//                       height: 139,
//                       decoration: BoxDecoration(
//                         border: Border.all(width: 4, color: Colors.white),
//                         boxShadow: [
//                           BoxShadow(
//                             spreadRadius: 2,
//                             blurRadius: 10,
//                             color: Colors.black.withOpacity(0.1),
//                           ),
//                         ],
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: _selectedImage != null
//                               ? FileImage(_selectedImage!)
//                               : NetworkImage(
//                                   'https://cdn.pixabay.com/photo/2023/05/01/15/17/water-7963286_960_720.jpg',
//                                 ) as ImageProvider<
//                                   Object>, // Specify the type here
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(width: 4, color: Colors.white),
//                           color: Colors.blue,
//                         ),
//                         child: OutlinedButton.icon(
//                           onPressed: selectImage,
//                           icon: const Icon(
//                             Icons.edit,
//                             color: Colors.white,
//                           ),
//                           label: const Text("Choose Image"),
//                         ),
//                       ),
//                     ),
//                      Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 60),
//                             TextFilter(
//                               controller: groupNameController,
//                               labelText: "Group Name",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Group name is required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             TextFilter(
//                               controller: rulesController,
//                               labelText: "Rules",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Rules are required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             TextFilter(
//                               controller: purposeController,
//                               labelText: "Purpose",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Purpose is required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             TextFilter(
//                               controller: descriptionController,
//                               labelText: "Description",
//                               onFieldSubmitted: (content) =>
//                                   flagOrFilterContent(
//                                 context,
//                                 content,
//                                 bannedKeywords,
//                               ),
//                               validator: (content) {
//                                 if (content.isEmpty) {
//                                   return "Description is required.";
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Row(
//                         children: [
//                           const SizedBox(width: 13),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Cancel'),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(150, 50),
//                               primary: Colors.red,
//                               onPrimary: Colors.white,
//                               elevation: 5,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 30),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 checkAndCreateGroup();
//                               }
//                             },
//                             child: Text(
//                               "Create",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(140, 50),
//                               elevation: 5,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                               ), // Set the desired width and height
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//       // bottomNavigationBar:  NavigationBar(),
//     );
//   }
// }

// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   // Handle button click
// //                 },
// //                 child: Text("Create Group"),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:relate/components/textfield_filter.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String imageUrl = '';
  File? _selectedImage;

  TextEditingController rulesController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();

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

      await ChatDatabase(uid: uid).createGroup(userName, uid, groupName, email,
          purpose, rules, description, imageUrl);

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

  Future<void> selectImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedImage = File(file.path);
      });
    }
    if (file == null) return;
    String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference imageReferenceToUpload =
        referenceDirImages.child(uniqueImageName);

    await imageReferenceToUpload.putFile(File(file.path));
    imageUrl = await imageReferenceToUpload.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 139,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : NetworkImage(
                                  'https://cdn.pixabay.com/photo/2023/05/01/15/17/water-7963286_960_720.jpg',
                                ) as ImageProvider<
                                  Object>, // Specify the type here
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
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.blue,
                        ),
                        child: OutlinedButton.icon(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: const Text("Choose Image"),
                        ),
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
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
                          return "Group name is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFilter(
                      controller: rulesController,
                      labelText: "Rules",
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
                          return "Rules are required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFilter(
                      controller: purposeController,
                      labelText: "Purpose",
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
                          return "Purpose is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFilter(
                      controller: descriptionController,
                      labelText: "Description",
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
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
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
