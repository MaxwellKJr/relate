import 'package:flutter/material.dart';
// import 'package:bulleted_list/bulleted_list.dart';

class SelfJourneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Self Journey',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              child: Text.rich(
                TextSpan(
                  text: 'What is ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Depression',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: '?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    'Depression is a mood disorder that causes a persistent feeling of sadness and loss of interest. It affects how you feel, think, and behave and can lead to various emotional and physical problems.',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      'Steps to Recovery',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        // BulletedList(
                        //   listItems: [
                        //     'Seek professional help: Reach out to a mental health professional or your primary care physician for an accurate diagnosis and appropriate treatment plan.',
                        //     'Build a support network: Surround yourself with understanding and supportive people who can provide emotional support and encouragement throughout your recovery.',
                        //     'Engage in therapy: Consider therapy options such as cognitive-behavioral therapy (CBT) or interpersonal therapy (IPT) to learn coping skills, address negative thoughts, and develop healthier behaviors.',
                        //     'Practice self-care: Prioritize self-care activities like regular exercise, maintaining a balanced diet, getting enough sleep, and engaging in activities you enjoy.',
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Text.rich(
                      TextSpan(
                        text: 'What to do if I ',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Relapse',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          TextSpan(
                            text: '?',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'If you experience a relapse in your depression symptoms, it\'s important to take action:',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    child: Text(
                      '1. Reach out for help: Contact your mental health professional or support network and let them know what you\'re going through.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    child: Text(
                      '2. Review your treatment plan: Evaluate your current treatment plan with a healthcare professional to determine if any adjustments or modifications are necessary.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    child: Text(
                      '3. Practice self-care: Prioritize self-care activities, continue engaging in healthy coping strategies, and ensure you\'re taking care of your physical and emotional well-being.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    child: Text(
                      '4. Stay connected: Maintain regular contact with your support network and lean on them for guidance and encouragement.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle start plan button press
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                ),
                child: Text(
                  'Start Plan',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
