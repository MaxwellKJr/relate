import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/screens/chat/message_detail_page.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference<Map<String, dynamic>> conversationsRef =
      FirebaseFirestore.instance.collection('conversations');

  Future<String?> _getConversationId(String userId) async {
    final currentUser =
        'current-user-id-here'; // Replace with the actual current user ID

    final snapshot = await conversationsRef
        .where('participants.$currentUser', isEqualTo: true)
        .where('participants.$userId', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final conversationId = snapshot.docs.first.id;
      return conversationId;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
      ),
      drawer: const DrawerMain(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                title: Text(user['userName'] ?? ''),
                subtitle: Text(user['email'] ?? ''),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final conversationId =
                        await _getConversationId(user['userId'] ?? '');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageDetailPage(
                          conversationId:
                              conversationId ?? '', // Handle null value
                          userId: user['uid'] ?? '',
                          userName: user['userName'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: const Text('Message'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
