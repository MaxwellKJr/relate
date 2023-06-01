import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WellnessCentresApp());
}

class WellnessCentresApp extends StatelessWidget {
  const WellnessCentresApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness Centers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WellnessCentresScreen(),
    );
  }
}

class WellnessCentresScreen extends StatelessWidget {
  const WellnessCentresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WELLNESS CENTERS'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'help',
                child: Text('Help'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Log Out'),
              ),
            ],
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'settings') {
                // Handle settings selection
              } else if (value == 'help') {
                // Handle help selection
              } else if (value == 'logout') {
                // Handle logout selection
              }
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<QuerySnapshot>(
          future: getWellnessCenters(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Text('Error retrieving wellness centers');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No wellness centers found');
            }

            List<DocumentSnapshot> centers = snapshot.data!.docs;
            return ListView.builder(
              itemCount: centers.length,
              itemBuilder: (context, index) {
                var center = centers[index];
                var name = center['name'] ?? '';
                var address = center['address'] ?? '';

                return ListTile(
                  title: Text(name),
                  subtitle: Text(address),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WellnessDetailsScreen(center: center),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class WellnessDetailsScreen extends StatelessWidget {
  final DocumentSnapshot center;

  const WellnessDetailsScreen({required this.center, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = center['name'] ?? '';
    final background = center['background'] ?? '';
    final services = center['services'] ?? '';
    final address = center['address'] ?? '';
    final criteria = center['criteria'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Background',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(background),
            const SizedBox(height: 24.0),
            const Text(
              'Services',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(services),
            const SizedBox(height: 24.0),
            const Text(
              'Address',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(address),
            const SizedBox(height: 24.0),
            const Text(
              'Criteria',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(criteria),
          ],
        ),
      ),
    );
  }
}

Future<QuerySnapshot> getWellnessCenters() async {
  return FirebaseFirestore.instance.collection('wellnessCenters').get();
}
