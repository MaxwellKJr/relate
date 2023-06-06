import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/chat/group_chat_info.dart';
import 'package:relate/services/chat_database_services.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  // final String userName;
  const ChatScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    // required this.userName
  }) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String admin = "";
  Stream<QuerySnapshot>? chats;

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
      body: Center(
        child: Text("hie"),
      ),
    );
  }
}
