import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:relate/screens/messages/messages_screen.dart';

class MessageDetailPage extends StatefulWidget {
  final String conversationId;
  final String userId;
  final String userName;

  MessageDetailPage({
    required this.conversationId,
    required this.userId,
    required this.userName,
  });

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendMessage(String message) async {
    try {
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.conversationId)
          .collection('messages')
          .add({
        'text': message,
        'timestamp': Timestamp.now(),
        'userId': widget.userId,
      });
      _messageController.clear();
    } catch (error) {
      // Handle error
      print('Failed to send message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MessagesScreen(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(widget.conversationId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  DateTime? previousDate;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          messages[index].data() as Map<String, dynamic>;
                      final text = message['text'];
                      final timestamp = message['timestamp'] as Timestamp;
                      final dateTime = timestamp.toDate();
                      final currentDate = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                      );

                      final formattedTime = DateFormat.Hm().format(dateTime);
                      final formattedDate = DateFormat.yMd().format(dateTime);

                      Widget dateWidget = Container();

                      if (previousDate == null ||
                          currentDate.difference(previousDate!).inDays != 0) {
                        dateWidget = Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      previousDate = currentDate;

                      final isSentMessage = message['userId'] == widget.userId;

                      return Column(
                        crossAxisAlignment: isSentMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          dateWidget,
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 16.0,
                            ),
                            child: Wrap(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  color: isSentMessage
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          text,
                                          style: TextStyle(
                                            color: isSentMessage
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                            color: isSentMessage
                                                ? Colors.white.withOpacity(0.8)
                                                : Colors.black.withOpacity(0.8),
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                border: InputBorder.none,
                hintText: 'Type your message...',
              ),
              onSubmitted: (message) => _sendMessage(message),
            ),
          ),
        ],
      ),
    );
  }
}
