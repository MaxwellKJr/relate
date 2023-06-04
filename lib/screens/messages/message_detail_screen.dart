import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'messages_screen.dart';

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
  File? _attachedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _sendMessage(String message) async {
    try {
      if (_attachedImage != null) {
        final storageRef =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
        await storageRef.putFile(_attachedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('conversations')
            .doc(widget.conversationId)
            .collection('messages')
            .add({
          'text': message,
          'timestamp': Timestamp.now(),
          'userId': widget.userId,
          'imageUrl': imageUrl,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('conversations')
            .doc(widget.conversationId)
            .collection('messages')
            .add({
          'text': message,
          'timestamp': Timestamp.now(),
          'userId': widget.userId,
        });
      }

      _messageController.clear();
      setState(() {
        _attachedImage = null;
      });
    } catch (error) {
      // Handle error
      print('Failed to send message: $error');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _attachedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesScreen(),
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
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () => _pickImage(),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      border: InputBorder.none,
                      hintText: 'Type your message...',
                    ),
                    onSubmitted: (message) => _sendMessage(message),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
