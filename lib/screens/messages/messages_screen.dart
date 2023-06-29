import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/screens/messages/message_detail_screen.dart';
import '../contact_professional/contact_professional_screen.dart';

class MessagesScreen extends StatelessWidget {
  final String uid;
  final String professionalId;

  const MessagesScreen({required this.uid, required this.professionalId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversation1')
            .where('participants', arrayContains: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No conversations found.'));
          }

          final conversations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final participants = conversation['participants'] as List<dynamic>;
              final professionalId = participants.firstWhere((id) => id != uid) as String;

              return ListTile(
                title: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('professionals').doc(professionalId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.data() == null) {
                      return Text('Professional not found');
                    }

                    final professionalData = snapshot.data!.data() as Map<String, dynamic>;
                    final userName = professionalData['userName'] as String;

                    return Text(userName);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageDetailScreen(
                        userName: '', professionallId: 'professionallId',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactProfessionalScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
