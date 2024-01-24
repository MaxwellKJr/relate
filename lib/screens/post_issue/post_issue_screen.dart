import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
    int? colorCode;

    if (userDoc.exists) {
      userName = userDoc.data()!['userName'];
      colorCode = userDoc.data()!['colorCode'];
    } else if (professionalDoc.exists) {
      userName = professionalDoc.data()!['userName'];
      colorCode = professionalDoc.data()!['colorCode'];
    }

    final text = _postTextController.text;
    final currentTime = DateTime.now();

    focus = _focusController.text;

    if (focus == "") focus = "General";

    final post = {
      'text': text,
      'focus': focus,
      'image': imageUrl,
      'colorCode': colorCode,
      'timestamp': Timestamp.fromDate(currentTime),
      'uid': uid,
      'postedBy': userName,
      'relates': []
    };

    if (text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('posts')
          .add(post)
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Post Shared",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: primaryColor,
                    textColor: whiteColor,
                    fontSize: 16.0),
              });
      Navigator.pop(context);
    }
  }

  XFile? file;
  File? imageFile;

  Future<void> _openCamera() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) return;

    imageFile = File(file.path);

    String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

    final temporaryImage = XFile(file.path);
    setState(() => this.file = temporaryImage);

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference imageReferenceToUpload =
        referenceDirImages.child(uniqueImageName);

    await imageReferenceToUpload.putFile(File(file.path));
    imageUrl = await imageReferenceToUpload.getDownloadURL();
  }

  Future<void> _openGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    imageFile = File(file.path);

    String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

    final temporaryImage = XFile(file.path);
    setState(() => this.file = temporaryImage);

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference imageReferenceToUpload =
        referenceDirImages.child(uniqueImageName);

    await imageReferenceToUpload.putFile(File(file.path));
    imageUrl = await imageReferenceToUpload.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final hasText = ValueNotifier(false);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Post")),
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(layoutPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                                padding: EdgeInsets.only(bottom: layoutPadding),
                                child: Container(
                                  child: Column(children: [
                                    CustomDropdown(
                                      borderSide:
                                          const BorderSide(color: primaryColor),
                                      fillColor: Colors.transparent,
                                      hintStyle:
                                          const TextStyle(color: primaryColor),
                                      listItemStyle:
                                          const TextStyle(color: blackColor),
                                      selectedStyle:
                                          const TextStyle(color: primaryColor),
                                      fieldSuffixIcon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                      hintText: 'General',
                                      items: const [
                                        'General',
                                        'Depression',
                                        'Addiction',
                                        'Motivation'
                                      ],
                                      controller: _focusController,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Form(
                                          key: _formKey,
                                          child: SizedBox(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Post cannot be empty. This is not Twitter';
                                                }
                                                return null;
                                              },
                                              maxLength: 1000,
                                              controller: _postTextController,
                                              decoration: const InputDecoration(
                                                hintText: 'Let it out...',
                                                border: InputBorder.none,
                                              ),
                                              minLines: 1,
                                              maxLines: 100,
                                            ),
                                          )),
                                    )
                                  ]),
                                ))
                          ],
                        ))
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                file != null
                                    ? GestureDetector(
                                        onTap: () async {
                                          // final img = await _cropImage(imageFile: img);
                                          // setState(() => imageFile = img);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.file(
                                                imageFile!,
                                                width: 105,
                                                height: 105,
                                                fit: BoxFit.cover,
                                              )),
                                        ))
                                    : Container(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            decoration: BoxDecoration(
                                color: theme.colorScheme.background,
                                border: Border(
                                    top: BorderSide(
                                        color: primaryColor, width: 1.0))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    //Camera
                                    IconButton(
                                      onPressed: () => _openCamera(),
                                      icon: const Icon(
                                        CupertinoIcons.camera_fill,
                                        color: primaryColor,
                                      ),
                                    ),

                                    // Galley
                                    IconButton(
                                      onPressed: () => _openGallery(),
                                      icon: const Icon(
                                        CupertinoIcons.photo,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: 35,
                                    child: FilledButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          sendPost();
                                        }
                                      },
                                      child: const Text("Post"),
                                    ))
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
              // bottomNavigationBar: const NavigationBarMain(),
            )));
  }
}
