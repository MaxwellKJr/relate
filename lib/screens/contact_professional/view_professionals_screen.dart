import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/screens/messages/message_detail_screen.dart';

class ViewProfessionalDetailsScreen extends StatelessWidget {
  final String professionalId;
  final String uid;

  const ViewProfessionalDetailsScreen({
    required this.professionalId,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Professional Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('professionals').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('Professional not found'));
          }

          final professionalData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = professionalData['userName'] as String;
          final email = professionalData['email'] as String;
          final phoneNumber = professionalData['phoneNumber'] as String;
          final specializedIn = professionalData['specializedIn'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 16.0),
                Text('Email: $email'),
                SizedBox(height: 16.0),
                Text('Phone Number: $phoneNumber'),
                SizedBox(height: 16.0),
                Text('Specialized In: ${specializedIn.join(", ")}'),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageDetailScreen(
                          userName: 'userName',
                          receiverId: 'receiverId',

                        ),
                      ),
                    );
                  },
                  child: Text('Send Message'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
