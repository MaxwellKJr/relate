import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relate/constants/colors.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:relate/constants/size_values.dart';

class PostIssueScreen extends StatefulWidget {
  const PostIssueScreen({super.key});

  @override
  State<PostIssueScreen> createState() => _PostIssueScreenState();
}

class _PostIssueScreenState extends State<PostIssueScreen> {
  final _postTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEmpty = false;

  final _focusController = TextEditingController();
  String focus = '';

  String imageUrl = '';

  Future<void> sendPost() async {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final professionalDoc = await FirebaseFirestore.instance
        .collection('professionals')
        .doc(uid)
        .get();
    String? userName;

    if (userDoc.exists) {
      userName = userDoc.data()!['userName'];
    } else if (professionalDoc.exists) {
      userName = professionalDoc.data()!['userName'];
    }

    final text = _postTextController.text;
    final currentTime = DateTime.now();

    focus = _focusController.text;

    if (focus == "") {
      focus = "General";
    }

    final post = {
      'text': text,
      'focus': focus,
      'image': imageUrl,
      'timestamp': Timestamp.fromDate(currentTime),
      'uid': uid,
      'postedBy': userName,
      'relates': []
    };

    if (text.isNotEmpty) {
      flagOrFilterContent(text, () {
        postContent(post);
      }, () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Content Violation'),
            content: const Text('Content contain banned keywords.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  void flagOrFilterContent(
    String content,
    Function postCallback,
    Function flagCallback,
  ) {
    final bannedKeywords = [
      'fuck',
      'keyword2',
      'keyword3',
    ];

    bool containsBannedKeyword =
        checkForBannedKeywords(content, bannedKeywords);

    if (containsBannedKeyword) {
      flagContentForReview(content);
      flagCallback();
    } else {
      // Proceed with posting the content
      postCallback();
    }
  }

  bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
    for (String keyword in bannedKeywords) {
      if (content.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  void flagContentForReview(String content) {
    // Here, you can implement the logic to flag the content for manual review
    // You can store the flagged content in a database or notify your moderation team
    // for further action
    print('Content flagged for review: $content');
  }

  void postContent(Map<String, dynamic> post) async {
    final user = FirebaseAuth.instance;
    final uid = user.currentUser?.uid;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final ref = FirebaseStorage.instance
          .ref()
          .child('issue_images')
          .child(uid!)
          .child(DateTime.now().toString() + '.jpg');

      final task = ref.putFile(File(imageUrl));

      final taskSnapshot = await task.whenComplete(() {});

      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(uid)
          .collection('userPosts')
          .add(post);

      _postTextController.clear();
      _focusController.clear();

      Fluttertoast.showToast(
        msg: "Issue Posted Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: primaryColor,
        textColor: whiteColor,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        isEmpty = true;
      });
    }
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      // imageUrl = pickedFile.path;
      imageUrl = pickedFile!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final hasText = ValueNotifier(false);

    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: Container(
                padding: const EdgeInsets.only(right: layoutPadding - 2),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                  ),
                ),
                child: AppBar(
                  title: const Text("Share"),
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
                          sendPost();
                        }
                      },
                      child: const Text("Post"),
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
                child: Stack(
                  children: [
                    Column(
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
                                controller: _postTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Share your thoughts...',
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              ),
                            )),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Flexible(
                            child: CustomDropdown(
                              fillColor: Colors.transparent,
                              listItemStyle: const TextStyle(color: blackColor),
                              selectedStyle:
                                  const TextStyle(color: Colors.teal),
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
                          OutlinedButton.icon(
                              onPressed: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? file = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                print('${file?.path}');

                                if (file == null) return;
                                String uniqueImageName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();

                                Reference referenceRoot =
                                    FirebaseStorage.instance.ref();
                                Reference referenceDirImages =
                                    referenceRoot.child('images');

                                Reference imageReferenceToUpload =
                                    referenceDirImages.child(uniqueImageName);

                                await imageReferenceToUpload
                                    .putFile(File(file.path));
                                imageUrl = await imageReferenceToUpload
                                    .getDownloadURL();
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Choose Image")),
                        ],
                      ),
                    )
                  ],
                ),
                // bottomNavigationBar: const NavigationBarMain(),
              ),
            )));
  }
}
