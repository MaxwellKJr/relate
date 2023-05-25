import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDetailPage extends StatefulWidget {
  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendMessage(String message) async {
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': message,
        'timestamp': Timestamp.now(),
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
        title: const Text('Send Message'),
    leading: IconButton(
    icon: Icon(Icons.adaptive.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
    ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].data() as Map<String, dynamic>;
                      final text = message['text'];
                      final timestamp = message['timestamp'] as Timestamp;
                      final dateTime = timestamp.toDate();

                      return ListTile(
                        title: Text(text),
                        subtitle: Text(dateTime.toString()),
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(MaterialApp(
    home: MessageDetailPage(),
  ));
}
