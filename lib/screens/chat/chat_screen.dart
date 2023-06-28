import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
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
  const ChatScreen(
      {Key? key,
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
    'keyword3',
  ];
  // Future<void> fetchBannedKeywords() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('bannedwords')
  //       .doc('keywords')
  //       .get();
  //   final data = snapshot.data() as Map<String, dynamic>;
  //   setState(() {
  //     bannedKeywords = List<String>.from(data['keywords']);
  //   });
  // }

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
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupJoinedChatInfor(
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
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      checkAndSendMessage();
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



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:relate/screens/chat/group_chat_info.dart';
// import 'package:relate/services/chat_database_services.dart';

// import 'message_cards.dart';

// class ChatScreen extends StatefulWidget {
//   final String groupId;
//   final String groupName;
//   final String userName;
//   final String description;
//   final String rules;
//   final String purpose;
//   final String admin;

//   const ChatScreen({
//     Key? key,
//     required this.groupId,
//     required this.admin,
//     required this.groupName,
//     required this.userName,
//     required this.description,
//     required this.purpose,
//     required this.rules,
//   }) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   String admin = "";
//   Stream<QuerySnapshot>? chats;
//   TextEditingController messageController = TextEditingController();
//   final List<String> bannedKeywords = [
//     'fuck',
//     'ass',
//     'keyword3',
//   ];
//   bool hasBannedKeyword = false;

//   @override
//   void initState() {
//     getChatandAdmin();
//     super.initState();
//   }

//   void getChatandAdmin() {
//     ChatDatabase().getConversations(widget.groupId).then((val) {
//       setState(() {
//         chats = val;
//       });
//     });
//   }

//   void flagOrFilterContent(BuildContext context, String content) {
//     bool containsBannedKeyword =
//         checkForBannedKeywords(content, bannedKeywords);

//     if (containsBannedKeyword) {
//       flagContentForReview(content);
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Content Violation'),
//           content: Text('Your message contains banned keywords.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Proceed with normal handling of the content
//       sendMessage();
//     }
//   }

//   bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
//     for (String keyword in bannedKeywords) {
//       if (content.toLowerCase().contains(keyword.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

//   void flagContentForReview(String content) {
//     // Here, you can implement the logic to flag the content for manual review
//     // You can store the flagged content in a database or notify your moderation team
//     // for further action
//     print('Content flagged for review: $content');
//   }

//   void sendMessage() {
//     String message = messageController.text;

//     ChatDatabase().sendMessage(
//       widget.groupId,
//       widget.userName,
//       message,
//     );

//     messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
//         backgroundColor: Theme.of(context).primaryColor,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => GroupJoinedChatInfor(
//                     groupId: widget.groupId,
//                     groupName: widget.groupName,
//                     admin: widget.admin,
//                     purpose: widget.purpose,
//                     rules: widget.rules,
//                     description: widget.description,
//                   ),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.info),
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: chats,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                       reverse: true,
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         final message = snapshot.data!.docs[index]['message'];
//                         final sender = snapshot.data!.docs[index]['sender'];
//                         final timestamp = snapshot.data!.docs[index]['timestamp'];

//                         return MessageCards(
//                           message: message,
//                           sender: sender,
//                           isMe: widget.userName == sender,
//                           timestamp: timestamp,
//                         );
//                       },
//                     );
//                   } else {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                         filled: true,
//                         fillColor: Colors.grey.shade200,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FloatingActionButton(
//                     onPressed: () {
//                       String content = messageController.text;
//                       if (content.isNotEmpty) {
//                         flagOrFilterContent(context, content);
//                       }
//                     },
//                     child: const Icon(Icons.send),
//                     backgroundColor: Theme.of(context).primaryColor,
//                     elevation: 0,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

