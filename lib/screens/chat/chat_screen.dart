import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/chat/group_chat_info.dart';
import 'package:relate/services/chat_database_services.dart';

import 'message_cards.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final String description;
  final String rules;
  final String purpose;
  final String admin;
  final String imageUrl;
  const ChatScreen(
      {Key? key,
      required this.imageUrl,
      required this.groupId,
      required this.admin,
      required this.groupName,
      required this.userName,
      required this.description,
      required this.purpose,
      required this.rules})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  // List<String> bannedKeywords = [];
  bool hasBannedKeyword = false;

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
    // fetchBannedKeywords();
  }

  final List<String> bannedKeywords = [
    'fuck',
    'ass',
    'keyword',
  ];

  //implementations for checking
  void checkAndSendMessage() {
    String message = messageController.text;
    hasBannedKeyword = checkForBannedKeywords(message, bannedKeywords);

    if (hasBannedKeyword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Content Violation'),
          content: Text('Your message contains banned keywords.'),
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
      // Proceed with sending the message
      sendMessage();
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

  ///checked
  getChatandAdmin() {
    ChatDatabase().getConversations(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    //   ChatDatabase().getGroupMainAdmin(widget.groupId).then((val) {
    //     print(widget.groupId);
    //     setState(() {
    //       admin = val;
    //     });
    //   });
    // }
//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.groupName),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupJoinedChatInfor(
                      imageUrl: widget.imageUrl,
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      userName: widget.userName,
                      admin: widget.admin,
                      purpose: widget.purpose,
                      rules: widget.rules,
                      description: widget.description),
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: chatMessages(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              // color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius value as needed
                      color: Colors.grey[700], // Change the color as desired
                    ),
                    child: TextFormField(
                      maxLines: null,
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      checkAndSendMessage();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chatMessages() {
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
                    sentByMe:
                        widget.userName == snapshot.data.docs[index]['sender'],
                    timestamp: snapshot.data.docs[index]
                        ['time'], // Add the timestamp argument here
                  );
                },
              )
            : Container();
      },
    );
  }

  void sendMessage() {
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
