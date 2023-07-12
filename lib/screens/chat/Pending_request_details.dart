import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/screens/community/communities_screen.dart';

class PendingRequestDetails extends StatelessWidget {
  final String userName;
  final String reason;
  final String groupId;
  final String userId;

  const PendingRequestDetails({
    Key? key,
    required this.userName,
    required this.reason,
    required this.groupId,
    required this.userId,
  }) : super(key: key);

  Future<void> updateFirebaseData(BuildContext context, String status) async {
    try {
      if (status == 'Approved') {
        // Update members field in groups collection
        final groupsRef =
            FirebaseFirestore.instance.collection('groups').doc(groupId);
        await groupsRef.update({
          'members': FieldValue.arrayUnion([userId]),
        });

        // Update groups field in users collection
        final usersRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        await usersRef.update({
          'groups': FieldValue.arrayUnion([groupId]),
        });
      }

      // Update status field in reasons collection for the specific document
      final reasonsRef = FirebaseFirestore.instance.collection('reasons');
      final querySnapshot = await reasonsRef
          .where('groupId', isEqualTo: groupId)
          .where('userId', isEqualTo: userId)
          .get();
      final documents = querySnapshot.docs;
      if (documents.isNotEmpty) {
        final doc = documents.first;
        await doc.reference.update({
          'status': status,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted successfully'),
        ),
      );

      // Navigate to another page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Communities(),
        ),
      );
    } catch (e) {
      print('Error updating Firebase data: $e');
      // Show an error message or perform any other desired action
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Request Details'),
      ),
      body: Column(
        children: [
          Text('User Name: $userName'),
          Text('Reason: $reason'),
          // Display any other details as needed
          ElevatedButton(
            onPressed: () {
              updateFirebaseData(context, 'Approved');
            },
            child: Text('Accept'),
          ),
          ElevatedButton(
            onPressed: () {
              updateFirebaseData(context, 'Request Denied');
            },
            child: Text('Denied'),
          ),
        ],
      ),
    );
  }
}
