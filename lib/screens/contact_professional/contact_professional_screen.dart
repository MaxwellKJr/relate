import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat/message_detail_page.dart';

class Professional {
  final String id;
  final String name;
  final String specialization;
  final String image;
  final String description;

  Professional({
    required this.id,
    required this.name,
    required this.specialization,
    required this.image,
    required this.description,
  });
}

class ProfessionalsScreen extends StatefulWidget {
  @override
  _ProfessionalsScreenState createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  final CollectionReference<Map<String, dynamic>> professionalsRef =
  FirebaseFirestore.instance.collection('professionals');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professionals'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: professionalsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final professionalDocs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: professionalDocs.length,
            itemBuilder: (context, index) {
              final professionalData = professionalDocs[index].data();

              final professional = Professional(
                id: professionalDocs[index].id,
                name: professionalData['name'] ?? '',
                specialization: professionalData['specialization'] ?? '',
                image: professionalData['image'] ?? '',
                description: professionalData['description'] ?? '',
              );

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(professional.image),
                ),
                title: Text(professional.name),
                subtitle: Text(professional.specialization),
                trailing: ElevatedButton(
                  onPressed: () {
                    _navigateToMessageDetailPage(context, professional);
                  },
                  child: Text('Contact'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToMessageDetailPage(
      BuildContext context, Professional professional) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPage(userId: professional.id),
      ),
    );
  }
}
