import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relate/screens/contact_professional/view_professionals_screen.dart';

class ContactProfessionalScreen extends StatelessWidget {
  const ContactProfessionalScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Professionals'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('professionals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // if (snapshot.hasError) {
          //   return Center(child: Text('Error: ${snapshot.error}'));
          // }
          // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          //   return const Center(
          //       child: Text('No verified professionals found.'));
          // }

          final professionals = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: professionals.length,
            itemBuilder: (context, index) {
              final professional = professionals[index];
              final String profilePicture = professional['profilePicture'];
              final userName = professional['userName'] as String;
              final isVerified = professional['isVerified'] as bool;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfessionalDetailsScreen(
                        userName: userName,
                        professionalId: professional['uid'],
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  profilePicture,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
