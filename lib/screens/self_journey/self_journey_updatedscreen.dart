import 'package:flutter/material.dart';
import 'package:relate/screens/self_journey/self_journey_screen.dart';
import 'package:relate/screens/self_journey/SelfJourneyScreen.dart';

class SelfJourneyUpdatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Which of the following below would you like to overcome',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                // Handle Addiction button press
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelfJourneyAddictionScreen()),
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
                      builder: (context) => SelfJourneyDepressionScreen()),
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
