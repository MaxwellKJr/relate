import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/community/reasons.dart';
import 'package:relate/services/chat_database_services.dart';

class TrialPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String purpose;
  final String description;
  final String rules;

  const TrialPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.purpose,
    required this.description,
    required this.rules,
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
        title:
            Text(widget.groupName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Purpose: Trial',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.purpose,
              style: TextStyle(fontSize: 16),
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
              style: TextStyle(fontSize: 16),
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
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 50),
            if (isMember)
              Text(
                'Already a Member',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )
            else
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Reason(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
