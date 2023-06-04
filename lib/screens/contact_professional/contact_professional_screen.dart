import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/messages/message_detail_screen.dart';

class ContactProfessionalScreen extends StatefulWidget {
  const ContactProfessionalScreen({Key? key}) : super(key: key);

  @override
  State<ContactProfessionalScreen> createState() =>
      _ContactProfessionalScreenState();
}

class _ContactProfessionalScreenState extends State<ContactProfessionalScreen> {
  late CollectionReference<Map<String, dynamic>> professionalsRef;
  late CollectionReference<Map<String, dynamic>> conversationsRef;

  @override
  void initState() {
    super.initState();
    professionalsRef = FirebaseFirestore.instance.collection('professionals');
    conversationsRef = FirebaseFirestore.instance.collection('conversations');
  }

  Future<bool> checkExistingMessages(String professionalId) async {
    final userId = 'current_user_id'; // Replace with the actual user ID

    final querySnapshot = await conversationsRef
        .where('userId', isEqualTo: userId)
        .where('professionalId', isEqualTo: professionalId)
        .limit(1)
        .get();

    return querySnapshot.size > 0;
  }

  void navigateToMessageDetailPage(String professionalId) async {
    final userId = 'current_user_id'; // Replace with the actual user ID

    final querySnapshot = await conversationsRef
        .where('userId', isEqualTo: userId)
        .where('professionalId', isEqualTo: professionalId)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      final conversationId = querySnapshot.docs.first.id;
      final userName = 'User Name'; // Replace with the actual user name

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageDetailPage(
            conversationId: conversationId,
            userId: userId,
            userName: userName,
          ),
        ),
      );
    } else {
      final professionalName = 'Professional Name'; // Replace with the actual professional name

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageDetailPage(
            conversationId: '',
            userId: userId,
            userName: professionalName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: professionalsRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final professionals = snapshot.data!.docs.map((doc) {
              final data = doc.data();
              return Professional(
                id: doc.id,
                name: data['name'] ?? '',
              );
            }).toList();

            return ListView.builder(
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                final professional = professionals[index];

                return ListTile(
                  title: Text(professional.name),
                  trailing: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () async {
                      final hasExistingMessages =
                      await checkExistingMessages(professional.id);

                      if (hasExistingMessages) {
                        navigateToMessageDetailPage(professional.id);
                      } else {
                        // Handle logic when no previous messages exist
                        // For now, show a snackbar as an example
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No previous messages'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class Professional {
  final String id;
  final String name;

  Professional({
    required this.id,
    required this.name,
  });
}
