// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:relate/screens/messages/message_detail_screen.dart';

// class UserProfileScreen extends StatefulWidget {
//   static const String userProfile = '/userProfile';
//   const UserProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final CollectionReference<Map<String, dynamic>> usersRef =
//   FirebaseFirestore.instance.collection('users');
//   final CollectionReference<Map<String, dynamic>> conversationsRef =
//   FirebaseFirestore.instance.collection('conversations');

//   Future<String?> _getConversationId(String userId) async {
//     final currentUser = 'current-user-id-here';

//     final snapshot = await conversationsRef
//         .where('participants.$currentUser', isEqualTo: true)
//         .where('participants.$userId', isEqualTo: true)
//         .limit(1)
//         .get();

//     if (snapshot.docs.isNotEmpty) {
//       final conversationId = snapshot.docs.first.id;
//       return conversationId;
//     }

//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profiles'),
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: usersRef.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           }

//           final userData = snapshot.data?.docs ?? [];

//           return ListView.builder(
//             itemCount: userData.length,
//             itemBuilder: (context, index) {
//               final user = userData[index].data();

//               return ListTile(
//                 leading: CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Theme.of(context).primaryColor,
//                   child: Container(), // Empty container as the child
//                 ),
//                 title: Text(user['userName'] ?? ''),
//                 subtitle: Text(user['email'] ?? ''),
//                 trailing: ElevatedButton(
//                   onPressed: () async {
//                     final conversationId =
//                     await _getConversationId(user['userId'] ?? '');

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MessageDetailPage(
//                           conversationId: conversationId ?? '',
//                           userId: user['userId'] ?? '',
//                           userName: user['name'] ?? '',
//                         ),
//                       ),
//                     );
//                   },
//                   child: Text('Message'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
