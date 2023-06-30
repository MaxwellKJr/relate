import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/screens/messages/message_detail_screen.dart';

class ViewProfessionalDetailsScreen extends StatelessWidget {
  final String professionalId, userName;

  const ViewProfessionalDetailsScreen({
    required this.professionalId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userName)),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('professionals')
            .doc(professionalId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final professionalData =
              snapshot.data!.data() as Map<String, dynamic>;
          final userName = professionalData['userName'] as String;
          final professionallId = professionalData['uid'] as String;
          final email = professionalData['email'] as String;
          final phoneNumber = professionalData['phoneNumber'] as String;

          final profilePicture = professionalData['profilePicture'] as String;
          final specializedIn =
              professionalData['specializedIn'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          profilePicture,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text('Email: $email'),
                const SizedBox(height: 16.0),
                Text('Phone Number: $phoneNumber'),
                const SizedBox(height: 16.0),
                Text('Specialized In: ${specializedIn.join(", ")}'),
                const SizedBox(height: 16.0),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageDetailScreen(
                          userName: userName,
                          professionallId: professionalId,
                        ),
                      ),
                    );
                  },
                  child: const Text('Send Message'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
