import 'package:flutter/material.dart';
// import 'package:bulleted_list/bulleted_list.dart';

class SelfJourneyAddictionScreen extends StatelessWidget {
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
                      text: 'Addiction',
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
                    'An addiction is a chronic dysfunction of the brain system that involves reward, motivation, and memory. It’s about the way your body craves a substance or behavior, especially if it causes a compulsive or obsessive pursuit of "reward" and lack of concern over consequences.',
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
                      'Steps of recovery',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        // BulletedList(
                        //   listItems: [
                        //     'medical services, to help treat serious complications of addiction, like withdrawal during detox',
                        //     'psychotherapy, including behavioral, talk, and group therapies',
                        //     'medications, for mental disorders such as depression or schizophrenia',
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
                      'The decision to change is one of the most important steps in overcoming an addiction. By acknowledging that a change is needed, it means that you recognize that there is a problem and have a desire to address it',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Making the decision to change and deciding what that will look like is a process that often takes time. This is known as the contemplation stage because it involves thinking about whether to change and how.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Consulting a doctor, addiction counselor, or psychologist is particularly helpful at this stage as they can help you understand the risks and what can help alleviate them.',
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
