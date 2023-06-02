import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/chat/message_detail_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final CollectionReference<Map<String, dynamic>> chatsRef =
  FirebaseFirestore.instance.collection('chats');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatData = chatDocs[index].data();
              final chatId = chatDocs[index].id;

              return ListTile(
                leading: CircleAvatar(
                  // Replace with chat user's profile image
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                title: Text(chatData['chatName']),
                subtitle: Text(chatData['lastMessage']),
                trailing: Text(chatData['lastMessageTime']),
                onTap: () {
                  // Handle chat item tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageDetailPage(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
