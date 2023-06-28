import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/community/communities_screen.dart';

import '../../services/chat_database_services.dart';
import '../communities.dart'; // Import the desired page

class Reason extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String purpose;
  final String description;
  final String rules;
  const Reason({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.purpose,
    required this.description,
    required this.rules,
  }) : super(key: key);

  @override
  State<Reason> createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  TextEditingController reasonController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  ChatDatabase firebaseReasons = ChatDatabase();

  void _submitReason() {
    String reason = reasonController.text;
    String userId = uid; // Replace 'user_id' with the actual user ID
    String groupId =
        widget.groupId; // Replace 'group_id' with the actual group ID

    firebaseReasons.reasons(userId, groupId, reason);

    // Display a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request submitted successfully'),
      ),
    );

    // Navigate to another page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const Communities()), // Replace 'Communities' with the desired page
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Provide a reason for joining the group:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: reasonController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter your reason...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _submitReason();
                // Optionally, you can navigate back to the previous page or perform any other action
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
