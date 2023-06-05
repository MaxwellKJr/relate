import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/user_profile/user_profile_screen.dart';
import 'package:relate/screens/messages/message_detail_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final CollectionReference<Map<String, dynamic>> chatsRef =
  FirebaseFirestore.instance.collection('chats');
  final CollectionReference<Map<String, dynamic>> usersRef =
  FirebaseFirestore.instance.collection('users');

  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchChats(_searchController.text);
            },
          ),
        ],
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

          final chatDocs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: _searchResults.isNotEmpty
                ? _searchResults.length
                : chatDocs.length,
            itemBuilder: (context, index) {
              final chatData = _searchResults.isNotEmpty
                  ? _searchResults[index].data()
                  : chatDocs[index].data();
              final chatId = chatDocs[index].id;

              return Dismissible(
                key: Key(chatId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) {
                  _deleteChat(chatId);
                },
                child: ListTile(
                  leading: const CircleAvatar(
                    // Replace with chat user's profile image
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  title: Text(chatData?['chatName'] ?? ''),
                  subtitle: Text(chatData?['lastMessage'] ?? ''),
                  trailing: Text(chatData?['lastMessageTime'] ?? ''),
                  onTap: () async {
                    final conversationId = await _getConversationId(chatId);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageDetailPage(
                          conversationId: conversationId ?? '',
                          userId: chatData?['user']['uid'] ?? '',
                          userName: chatData?['chatName'] ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserProfileScreen(),
            ),
          );
        },
      ),
    );
  }

  Future<String?> _getConversationId(String chatId) async {
    final currentUser = 'current-user-id-here'; // Replace with the actual current user ID

    final snapshot = await chatsRef
        .doc(chatId)
        .collection('conversations')
        .where('participants.$currentUser', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final conversationId = snapshot.docs.first.id;
      return conversationId;
    }

    return null;
  }

  void _searchChats(String searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    FirebaseFirestore.instance
        .collection('chats')
        .where('chatName', isEqualTo: searchTerm)
        .get()
        .then((snapshot) {
      setState(() {
        _searchResults = snapshot.docs;
      });
    });
  }

  void _deleteChat(String chatId) {
    chatsRef.doc(chatId).delete().then((_) {
      // Chat deleted successfully
    }).catchError((error) {
      // Error occurred while deleting chat
    });
  }
}
