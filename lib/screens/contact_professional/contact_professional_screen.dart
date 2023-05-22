import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactProfessionalScreen extends StatefulWidget {
  const ContactProfessionalScreen({Key? key}) : super(key: key);

  @override
  _ContactProfessionalScreenState createState() =>
      _ContactProfessionalScreenState();
}

class _ContactProfessionalScreenState extends State<ContactProfessionalScreen> {
  final _postTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusController = TextEditingController();
  String imageUrl = '';

  Future<void> sendMessage() async {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userName = userDoc.data()!['userName'];

    final text = _postTextController.text;
    final currentTime = DateTime.now();

    final focus = _focusController.text;

    final post = {
      'text': text,
      'focus': focus,
      'image': imageUrl,
      'timestamp': Timestamp.fromDate(currentTime),
      'uid': uid, // Add the user's UID and userName to the post document
      'postedBy': userName
    };

    if (text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Messages')
          .add(post)
          .then((value) => {
        Fluttertoast.showToast(
            msg: "Message Sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Professional'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.arrow_drop_down_circle),
                    title: const Text('Card title 1'),
                    subtitle: Text(
                      'Secondary Text',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Perform some action
                        },
                        child: const Text('Message'),
                      ),
                    ],
                  ),
                  Image.asset('assets/card-sample-image.jpg'),
                  Image.asset('assets/card-sample-image-2.jpg'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
