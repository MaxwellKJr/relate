import 'package:flutter/material.dart';
import 'package:relate/screens/self_journey/self_journey_screen.dart';
import 'package:relate/screens/self_journey/SelfJourneyScreen.dart';

class SelfJourneyUpdatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Self Journey'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Which of the following below would you like',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  'to overcome?',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                // Handle Addiction button press
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelfJourneyUpdatedScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Addiction',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle Depression button
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelfJourneyUpdatedScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Depression',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
