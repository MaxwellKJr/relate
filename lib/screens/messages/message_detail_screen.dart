import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageDetailScreen extends StatefulWidget {
  // final String uid;
  // final String professionalId;
  final String userName;
  final String professionallId;

  const MessageDetailScreen({
    // required this.uid,
    // required this.professionalId,
    required this.professionallId,
    required this.userName,
  });

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String chatRoomId;
  late String currentUserId;
  late String otherUserId;

  @override
  void initState() {
    super.initState();
    // currentUserId = widget.uid;
    // String currentUserId = FirebaseAuth.currentUser!.uid;
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    otherUserId = widget.professionallId;
    chatRoomId = _generateChatRoomId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageText = message['message'] as String;
                    final timestamp = message['timestamp'] as Timestamp;
                    final time = timestamp.toDate();

                    final isCurrentUserMessage =
                        message['senderId'] == currentUserId;

                    return Dismissible(
                      key: Key(message.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        _deleteMessage(message.id);
                      },
                      child: Card(
                        child: ListTile(
                          title: Wrap(
                            children: [
                              Text(
                                messageText,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          subtitle: Text(_formatDateTime(time)),
                          tileColor: isCurrentUserMessage
                              ? Colors.blue[100]
                              : Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          visualDensity: VisualDensity.compact,
                          trailing: isCurrentUserMessage
                              ? null
                              : Icon(Icons.account_circle),
                          leading: isCurrentUserMessage
                              ? Icon(Icons.account_circle)
                              : null,
                          // Customize the styling based on the message sender
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _generateChatRoomId() {
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    return ids.join("_");
  }

  String _formatDateTime(DateTime dateTime) {
    final timeFormat = DateFormat.Hm();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${timeFormat.format(dateTime)}';
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    _messageController.clear();

    if (message.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('messages')
          .add({
        'message': message,
        'timestamp': Timestamp.now(),
        'senderId': currentUserId,
        'receiverId': widget.professionallId,
      });

      FirebaseFirestore.instance
          .collection('professionals')
          .doc(widget.professionallId)
          .collection('messages')
          .add({
        'message': message,
        'timestamp': Timestamp.now(),
        'senderId': currentUserId,
        'receiverId': widget.professionallId,
      });
    }
  }

  void _deleteMessage(String messageId) {
    FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
