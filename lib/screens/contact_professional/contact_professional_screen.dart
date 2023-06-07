// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:relate/screens/messages/message_detail_screen.dart';
// import '../chat/message_detail_page.dart';

// class ContactProfessionalScreen extends StatefulWidget {
//   const ContactProfessionalScreen({Key? key}) : super(key: key);

// class Professional {
//   final String id;
//   final String name;
//   final String specialization;
//   final String image;
//   final String description;

//   Professional({
//     required this.id,
//     required this.name,
//     required this.specialization,
//     required this.image,
//     required this.description,
//   });
// }

// class ProfessionalsScreen extends StatefulWidget {
//   @override
//   _ProfessionalsScreenState createState() => _ProfessionalsScreenState();
// }

// class _ContactProfessionalScreenState extends State<ContactProfessionalScreen> {
//   late CollectionReference<Map<String, dynamic>> professionalsRef;
//   late CollectionReference<Map<String, dynamic>> conversationsRef;

//   @override
//   void initState() {
//     super.initState();
//     professionalsRef = FirebaseFirestore.instance.collection('professionals');
//     conversationsRef = FirebaseFirestore.instance.collection('conversations');
//   }

//   Future<bool> checkExistingMessages(String professionalId) async {
//     final userId = 'current_user_id'; // Replace with the actual user ID

//     final querySnapshot = await conversationsRef
//         .where('uid', isEqualTo: userId)
//         .where('professionalId', isEqualTo: professionalId)
//         .limit(1)
//         .get();

//     return querySnapshot.size > 0;
//   }

//   void navigateToMessageDetailPage(String professionalId, String professionalName) async {
//     final userId = 'current_user_id'; // Replace with the actual user ID

//     final querySnapshot = await conversationsRef
//         .where('uid', isEqualTo: userId)
//         .where('professionalId', isEqualTo: professionalId)
//         .limit(1)
//         .get();

//     if (querySnapshot.size > 0) {
//       final conversationId = querySnapshot.docs.first.id;
//       final userName = 'User Name'; // Replace with the actual user name

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MessageDetailPage(
//             conversationId: conversationId,
//             userId: userId,
//             userName: userName,
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MessageDetailPage(
//             conversationId: '',
//             userId: userId,
//             userName: professionalName,
//           ),
//         ),
//       );
//     }
//   }
  
// class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
//   final CollectionReference<Map<String, dynamic>> professionalsRef =
//   FirebaseFirestore.instance.collection('professionals');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contact Professionals'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//           stream: professionalsRef.snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }

//             final professionals = snapshot.data!.docs.map((doc) {
//               final data = doc.data();
//               return Professional(
//                 id: doc.id,
//                 name: data['name'] ?? '',
//                 description: data['description'] ?? '',
//                 imageUrl: data['imageUrl'] ?? '',
//               );
//             }).toList();

//             return ListView.builder(
//               itemCount: professionals.length,
//               itemBuilder: (context, index) {
//                 final professional = professionals[index];

//                 return GestureDetector(
//                   onTap: () {
//                     navigateToMessageDetailPage(professional.id, professional.name);
//                   },
//                   child: Card(
//                     margin: EdgeInsets.all(8.0),
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundImage: NetworkImage(professional.imageUrl),
//                           ),
//                           SizedBox(width: 8.0),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   professional.name,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8.0),
//                                 Text(
//                                   professional.description,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.message),
//                             onPressed: () async {
//                               final hasExistingMessages = await checkExistingMessages(professional.id);
//                               navigateToMessageDetailPage(professional.id, professional.name);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//         title: Text('Professionals'),
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: professionalsRef.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }

//           final professionalDocs = snapshot.data?.docs ?? [];

//           return ListView.builder(
//             itemCount: professionalDocs.length,
//             itemBuilder: (context, index) {
//               final professionalData = professionalDocs[index].data();

//               final professional = Professional(
//                 id: professionalDocs[index].id,
//                 name: professionalData['name'] ?? '',
//                 specialization: professionalData['specialization'] ?? '',
//                 image: professionalData['image'] ?? '',
//                 description: professionalData['description'] ?? '',
//               );

//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(professional.image),
//                 ),
//                 title: Text(professional.name),
//                 subtitle: Text(professional.specialization),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _navigateToMessageDetailPage(context, professional);
//                   },
//                   child: Text('Contact'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _navigateToMessageDetailPage(
//       BuildContext context, Professional professional) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MessageDetailPage(userId: 'user-id-here', userName: 'user-name-here',conversationId: 'conversation-id-here'),
//       ),
//     );
//   }
// }

// class Professional {
//   final String id;
//   final String name;
//   final String description;
//   final String imageUrl;

//   Professional({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//   });
// }
