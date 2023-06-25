import 'package:flutter/material.dart';

class Reason extends StatefulWidget {
  const Reason({super.key});

  @override
  State<Reason> createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  String reason = '';

  void _submitReason() {
    // Perform logic to submit the reason to the server or database
    // You can access the 'reason' variable to retrieve the user's input
    // and send it to the appropriate backend endpoint.
    // Example: groupJoinService.submitReason(reason);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Provide a reason for joining the group:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  reason = value;
                });
              },
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
