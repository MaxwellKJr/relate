import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:relate/components/textfield_filter.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String imageUrl = '';
  File? _selectedImage;

  TextEditingController rulesController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> bannedKeywords = [
    'fuck',
    'ass',
    'keyword3',
  ];

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  // Retrieve the username from shared preferences
  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "";
    });
  }

  // Filter or flag the content based on banned keywords
  void flagOrFilterContent(
      BuildContext context, String content, List<String> bannedKeywords) {
    bool containsBannedKeyword =
        checkForBannedKeywords(content, bannedKeywords);

    if (containsBannedKeyword) {
      flagContentForReview(content);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Content Violation'),
          content: const Text('Your message contains banned keywords.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Proceed with normal handling of the content
    }
  }

  // Check if the content contains any banned keywords
  bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
    for (String keyword in bannedKeywords) {
      if (content.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  // Flag the content for manual review
  void flagContentForReview(String content) {
    print('Content flagged for review: $content');
  }

  // Show a snackbar with the specified message and color
  void showSnackbar(BuildContext context, Color color, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  void checkAndCreateGroup() async {
    if (_formKey.currentState!.validate()) {
      // Check if the image has been uploaded
      if (_selectedImage == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Image Upload'),
            content: const Text('Please upload an image for the group.'),
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
        return;
      }

      String groupName = groupNameController.text;
      String rules = rulesController.text;
      String purpose = purposeController.text;
      String description = descriptionController.text;

      // Check if any field is empty
      if (groupName.isEmpty ||
          rules.isEmpty ||
          purpose.isEmpty ||
          description.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Incomplete Fields'),
            content: const Text('Please fill in all the required fields.'),
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
      } else {
        // Check if any of the fields contain banned keywords
        bool containsBannedKeyword = false;
        List<String> contentList = [groupName, rules, purpose, description];
        for (String content in contentList) {
          if (checkForBannedKeywords(content, bannedKeywords)) {
            containsBannedKeyword = true;
            break;
          }
        }

        if (containsBannedKeyword) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Content Violation'),
              content:
                  const Text('One or more fields contain banned keywords.'),
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
        } else {
          // Proceed with creating the group
          setState(() {
            _isLoading = true;
          });

          String uid = FirebaseAuth.instance.currentUser!.uid;
          String email = ""; // Set the appropriate email value

          await ChatDatabase(uid: uid).createGroup(
            userName,
            uid,
            groupName,
            email,
            purpose,
            rules,
            description,
            imageUrl,
          );

          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).pop();
          showSnackbar(
            context,
            Colors.green,
            "Group has been created successfully.",
          );
        }
      }
    }
  }

  Future<void> selectImage() async {
    ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedImage = File(file.path);
      });
    }
    if (file == null) return;
    String uniqueImageName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference imageReferenceToUpload =
        referenceDirImages.child(uniqueImageName);

    setState(() {
      _isLoading = true;
    });

    UploadTask uploadTask = imageReferenceToUpload.putFile(File(file.path));

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    imageUrl = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 139,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : const NetworkImage(
                                        'https://cdn.pixabay.com/photo/2023/05/01/15/17/water-7963286_960_720.jpg',
                                      ) as ImageProvider<Object>,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                color: Colors.blue,
                              ),
                              child: InkWell(
                                onTap: selectImage,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    TextFilter(
                      controller: groupNameController,
                      labelText: "Group Name",
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
                          return "Group name is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFilter(
                      controller: rulesController,
                      labelText: "Rules",
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
                          return "Rules are required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFilter(
                      controller: purposeController,
                      labelText: "Purpose",
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
                          return "Purpose is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFilter(
                      controller: descriptionController,
                      labelText: "Description",
                      onFieldSubmitted: (content) => flagOrFilterContent(
                        context,
                        content,
                        bannedKeywords,
                      ),
                      validator: (content) {
                        if (content!.isEmpty) {
                          return "Description is required.";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  const SizedBox(width: 13),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 50),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: checkAndCreateGroup,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Create",
                            style: TextStyle(fontSize: 16),
                          ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(140, 50),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
