import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/community/reasons.dart';

class TrialPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String purpose;
  final String description;
  final String rules;
  final String userName;

  const TrialPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.purpose,
    required this.description,
    required this.rules,
    required this.userName,
  }) : super(key: key);

  @override
  State<TrialPage> createState() => _TrialPageState();
}

class _TrialPageState extends State<TrialPage> {
  String admin = "";
  bool isMember = false;

  @override
  void initState() {
    super.initState();
    checkMembership();
  }

  Future<void> checkMembership() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        final groupRef =
            FirebaseFirestore.instance.collection('groups').doc(widget.groupId);
        final snapshot = await groupRef.get();

        if (snapshot.exists) {
          final members = snapshot.data()?['members'] as List<dynamic>;
          final currentUserID = currentUser.uid;

          setState(() {
            isMember = members.contains(currentUserID);
          });
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rules:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.rules,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 50),
            if (isMember)
              const Text(
                'Already a Member',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )
            else
              Flexible(
                  child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Reason(
                            groupId: widget.groupId,
                            groupName: widget.groupName,
                            purpose: widget.purpose,
                            description: widget.description,
                            rules: widget.rules,
                            userName: widget.userName),
                      ),
                    );
                  },
                  child: const Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
          ],
        ),
      ),
    );
  }
}
// The TrialPage widget represents a page that displays the details of a group that the current user is not in.
// It includes the group name, purpose, description, and rules. 
// Users can join the group by clicking on the "Join Now" button if they are not already a member.
// The membership status is checked based on the current user's ID and the list of members stored in the Firestore database.
