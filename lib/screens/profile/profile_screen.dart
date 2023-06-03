import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/screens/chat/message_detail_page.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final CollectionReference<Map<String, dynamic>> usersRef =
  FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('User Profiles'),
  ),
  body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: usersRef.snapshots(),
  builder: (context, snapshot) {
  if (snapshot.hasError) {
  return Text('Error: ${snapshot.error}');
  }

  if (snapshot.connectionState == ConnectionState.waiting) {
  return CircularProgressIndicator();
  }

  final userData = snapshot.data?.docs ?? [];

  return ListView.builder(
  itemCount: userData.length,
  itemBuilder: (context, index) {
  final user = userData[index].data();

  return ListTile(
  leading: CircleAvatar(
  // Replace with user profile image
  backgroundImage: NetworkImage(user['profileImageUrl'] ?? ''),
  ),
  title: Text(user['name'] ?? ''),
  subtitle: Text(user['email'] ?? ''),
  trailing: ElevatedButton(
  onPressed: () {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => MessageDetailPage(
  userId: userData[index].id,
  ),
  ),
  );
  },
  child: Text('Message'),
  ),
  );
  },
  );
  },
  ),
  );
  }
  }
