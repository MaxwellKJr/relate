import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const WellnessCentresScreen());
}

class WellnessCenter {
  final String name;
  final String background;
  final String services;
  final String criteria;

  WellnessCenter({
    required this.name,
    required this.background,
    required this.services,
    required this.criteria,
  });
}

class WellnessCenterDetailsScreen extends StatelessWidget {
  final WellnessCenter wellnessCenter;

  const WellnessCenterDetailsScreen({super.key, required this.wellnessCenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wellnessCenter.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            const Text('Background:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4.0),
            Text(wellnessCenter.background),
            const SizedBox(height: 16.0),
            const Text('Services Offered:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4.0),
            Text(wellnessCenter.services),
            const SizedBox(height: 16.0),
            const Text('Admission Criteria:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4.0),
            Text(wellnessCenter.criteria),
          ],
        ),
      ),
    );
  }
}

class WellnessCentresScreen extends StatelessWidget {
  const WellnessCentresScreen({super.key});

  void showMoreDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  // Add your sign out logic here
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  // Add your help logic here
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Add your settings logic here
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void navigateToWellnessCenterDetails(
      BuildContext context, WellnessCenter center) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WellnessCenterDetailsScreen(wellnessCenter: center),
      ),
    );
  }

  void openWellnessCentersURL() async {
    const url = 'https://example.com/wellness-centers';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<WellnessCenter> wellnessCenters = [
      WellnessCenter(
        name: 'Rehabilitation of Hope',
        background: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        services: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        criteria: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      ),
      WellnessCenter(
        name: 'Wellness Center 2',
        background: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        services: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        criteria: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      ),
      WellnessCenter(
        name: 'Wellness Center 3',
        background: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        services: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        criteria: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      ),
    ];

    return MaterialApp(
      title: 'Wellness Centres UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Wellness Centers',
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showMoreDetails(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: wellnessCenters.length,
                itemBuilder: (BuildContext context, int index) {
                  WellnessCenter center = wellnessCenters[index];
                  return ListTile(
                    title: Text(
                      center.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Tap to view details'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      navigateToWellnessCenterDetails(context, center);
                    },
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic for handling the button press
                },
                style: ElevatedButton.styleFrom(),
                child: const Text('Find More Wellness Centers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
