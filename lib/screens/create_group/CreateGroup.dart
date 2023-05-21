// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/screens/community/communities_screen.dart';
import 'package:relate/services/chat_database_services.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String userName = "";
  String email = "";
  // AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Communities()),
              );
            },
          ),
          title: Text("Create Group"),
          centerTitle: true,
          // backgroundColor: Color(0xFF009688),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: StreamBuilder<Object>(
              builder: (context, setState) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter innerSetState) {
                    return ListView(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 139,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://cdn.pixabay.com/photo/2023/05/01/15/17/water-7963286_960_720.jpg',
                                    ),
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
                                    border: Border.all(
                                        width: 4, color: Colors.white),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60),
                        nameTextField(),
                        SizedBox(height: 20),
                        rulesTextField(),
                        SizedBox(height: 30),
                        purposeTextField(),
                        SizedBox(height: 30),
                        descriptionTextField(),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            SizedBox(width: 50),
                            ElevatedButton(
                              onPressed: () async {
                                if (groupName != "") {
                                  innerSetState(() {
                                    _isLoading = true;
                                  });

                                  await ChatDatabase(
                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                  ).createGroup(
                                    userName,
                                    FirebaseAuth.instance.currentUser!.uid,
                                    groupName,
                                  );

                                  innerSetState(() {
                                    _isLoading = false;
                                  });

                                  Navigator.of(context).pop();
                                  showSnackbar(
                                    context,
                                    Colors.green,
                                    "Group created successfully.",
                                  );
                                }
                              },
                              child: const Text("Create Group"),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(110, 20),
                                primary: Colors.red,
                                onPrimary: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ));
  }

  Widget nameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Color(0xFF009688),
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.group,
          color: Colors.green,
        ),
        labelText: "Group Name",

        // helperText: "Fields Can not be empty" should describe about the field
      ),
      onChanged: (value) {
        groupName = value; // Assign the input value to the groupName variable
      },
    );
  }

  Widget purposeTextField() {
    return TextFormField(
      maxLines: null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Color(0xFF009688),
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.lightbulb,
          color: Colors.green,
        ),
        labelText: "Group Purpose",
        // helperText: "Fields Can not be empty" should describe about the field
      ),
    );
  }

  Widget descriptionTextField() {
    return TextFormField(
      maxLines: null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Color(0xFF009688),
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.description,
          color: Colors.green,
        ),
        labelText: "Group Description",
        // helperText: "Fields Can not be empty" should describe about the field
      ),
    );
  }

  Widget rulesTextField() {
    return TextFormField(
      maxLines: null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Color(0xFF009688),
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.rule,
          color: Colors.green,
        ),
        labelText: "Group rules",
        // helperText: "Fields Can not be empty" should describe about the field
      ),
    );
  }

  void showSnackbar(context, color, message) {
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
}
