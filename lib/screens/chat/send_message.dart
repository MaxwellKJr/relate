import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relate/constants/colors.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final _messageTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEmpty = false;

  final _focusController = TextEditingController();

  String imageUrl = '';

  Future<void> sendMessage() async {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userName = userDoc.data()!['userName'];

    final text = _messageTextController.text;
    final currentTime = DateTime.now();

    final focus = _focusController.text;

    final message = {
      'text': text,
      'focus': focus,
      'image': imageUrl,
      'timestamp': Timestamp.fromDate(currentTime),
      'uid': uid, // Add the user's UID and userName to the post document
      'sentBy': userName
    };

    if (text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('messages')
          .add(message)
          .then((value) => {
        Fluttertoast.showToast(
            msg: "Message Sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: primaryColor,
            textColor: whiteColor,
            fontSize: 16.0),
        // if (Vibration.hasVibrator()) {Vibration.vibrate()}
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final hasText = ValueNotifier(false);

    return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              child: AppBar(
                title: const Text("send"),
                leading: IconButton(
                  icon: Icon(Icons.adaptive.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendMessage();
                      }
                    },
                    child: const Text("Send Message"),
                  )
                ],
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        key: _formKey,
                        child: SizedBox(
                          height: 100,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter some text';
                              }
                              return null;
                            },
                            controller: _messageTextController,
                            decoration: const InputDecoration(
                              hintText: 'Share your thoughts...',
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomDropdown(
                            hintText: 'Choose focus',
                            items: const [
                              'General',
                              'Depression',
                              'Addiction',
                              'Motivation'
                            ],
                            controller: _focusController,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OutlinedButton.icon(
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              print('${file?.path}');

                              if (file == null) return;
                              String uniqueImageName =
                              DateTime.now().millisecondsSinceEpoch.toString();

                              Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                              referenceRoot.child('images');

                              Reference imageReferenceToUpload =
                              referenceDirImages.child(uniqueImageName);

                              await imageReferenceToUpload.putFile(File(file.path));
                              imageUrl =
                              await imageReferenceToUpload.getDownloadURL();
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Choose Image"))
                      ],
                    )
                  ],
                )),
            // bottomNavigationBar: const NavigationBarMain(),
          ),
        ));
  }
}
