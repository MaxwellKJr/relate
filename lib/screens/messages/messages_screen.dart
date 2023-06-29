import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/messages/message_detail_screen.dart';
import '../contact_professional/contact_professional_screen.dart';

class MessagesScreen extends StatelessWidget {
  final String uid;
  // final String professionalId;

  const MessagesScreen({
    super.key,
    required this.uid,
    // required this.professionalId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversation1')
            .where('participants', arrayContains: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No conversations found.'));
          }

          final conversations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final participants =
                  conversation['participants'] as List<dynamic>;
              final professionalId =
                  participants.firstWhere((id) => id != uid) as String;

              return ListTile(
                title: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('professionals')
                      .doc(professionalId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...');
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.data() == null) {
                      return const Text('Professional not found');
                    }

                    final professionalData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final userName = professionalData['userName'] as String;

                    return Text(userName);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessageDetailScreen(
                        userName: '',
                        professionallId: 'professionallId',
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
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 400),
                child: const ContactProfessionalScreen(),
              ));
        },
        backgroundColor: primaryColor,
        elevation: 3,
        child: const Icon(
          Icons.message_rounded,
          color: whiteColor,
        ),
      ),
    );
  }
}
