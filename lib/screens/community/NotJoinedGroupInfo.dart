import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:relate/services/chat_database_services.dart';

// class NotJoinedGroupinfo extends StatefulWidget {
//   final String groupId;
//   final String groupName;
//   final String purpose;
//   final String description;
//   final String rules;
//   const NotJoinedGroupinfo({
//     Key? key,
//     required this.purpose,
//     required this.description,
//     required this.rules,
//     required this.groupName,
//     required this.groupId,
//   }) : super(key: key);
//   @override
//   State<NotJoinedGroupinfo> createState() => _NotJoinedGroupinfoState();
// }

// class _NotJoinedGroupinfoState extends State<NotJoinedGroupinfo> {
//   String admin = "";
//   Stream<QuerySnapshot>? chats;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         title: Text(
//           widget.groupName,
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.description,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             Text(
//               widget.purpose,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),
//             Text(
//               widget.description,
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),
//             Text(
//               widget.rules,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class NotJoinedGroupinfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String purpose;
  final String description;
  final String rules;

  NotJoinedGroupinfo({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.purpose,
    required this.description,
    required this.rules,
  }) : super(key: key);

  @override
  State<NotJoinedGroupinfo> createState() => _NotJoinedGroupinfoState();
}

class _NotJoinedGroupinfoState extends State<NotJoinedGroupinfo> {
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
        title:
            Text(widget.groupName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //start
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Purpose:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.purpose,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            const Text(
              'Rules:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.rules,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        //here
      ),
    );
  }
}
