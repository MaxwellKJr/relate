import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/chat/message_detail_page.dart';
import 'package:relate/screens/profile/profile_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

import 'package:relate/screens/chat/group_chat_info.dart';
import 'package:relate/services/chat_database_services.dart';

import 'message_cards.dart';


class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatScreen(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);
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

class _ChatScreenState extends State<ChatScreen> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    ChatDatabase().getConversations(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    ChatDatabase().getGroupMainAdmin(widget.groupId).then((val) {
      print(widget.groupId);
      setState(() {
        admin = val;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body:
      Column(
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
    
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatInfor(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: [
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageCards(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      ChatDatabase().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }

  }
}
