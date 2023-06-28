import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:relate/screens/messages/message_service.dart';

class MessageDetailScreen extends StatefulWidget {
  final String receiverId;
  final String userName;

  const MessageDetailScreen({
    required this.receiverId,
    required this.userName,
  });

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String professionalUsername = '';

  @override
  void initState() {
    super.initState();
    _loadProfessionalUsername();
  }

  Future<void> _loadProfessionalUsername() async {
    // Replace the 'your_professional_collection' with the actual collection name
    DocumentSnapshot professionalSnapshot = await FirebaseFirestore.instance
        .collection('your_professional_collection')
        .doc(widget.receiverId)
        .get();

    if (professionalSnapshot.exists) {
      setState(() {
        professionalUsername = professionalSnapshot['userName'];
      });
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _messageService.sendMessage(
          widget.receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(professionalUsername),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _messageService.getMessages(
        widget.receiverId,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;
        return ListView(
          children: messages.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderUserName']),
          Text(data['text']),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(hintText: 'Type your message'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _sendMessage,
        ),
      ],
    );
  }
}
