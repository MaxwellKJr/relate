import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/chat/message_detail_page.dart';
import 'package:relate/screens/profile/profile_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final CollectionReference<Map<String, dynamic>> chatsRef =
  FirebaseFirestore.instance.collection('chats');
  final CollectionReference<Map<String, dynamic>> usersRef =
  FirebaseFirestore.instance.collection('users');

  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> userData = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Chats',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchChats(value);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

                    return ListTile(
                      leading: CircleAvatar(
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
                              userId: chatData?['user']['userId'] ?? '',
                              userName: chatData?['chatName'] ?? '',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(),
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
}
