import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/navigation/drawer/drawer_community.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/text_string.dart';
// import 'package:relate/screens/community/section_divider.dart';
import 'package:relate/screens/create_group/CreateGroup.dart';
import 'package:relate/services/chat_database_services.dart';
// import 'section_divider.dart';

// class Communities extends StatelessWidget {
//   const Communities ({Key? key}) : super(key: key);

class Communities extends StatefulWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  Stream? groups;

  gettingUserData() async {
    // await HelperFunctions.getUserEmailFromSF().then((value) {
    //   setState(() {
    //     email = value!;
    //   });
    // });
    // await HelperFunctions.getUserNameFromSF().then((val) {
    //   setState(() {
    //     userName = val!;
    //   });
    // });
    // getting the list of snapshots in our stream
    await ChatDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Groups",
            style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroup()),
              );
            },
          ),
        ],
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.black12 // set color for dark theme
            : Colors.white24, // set color for light theme
        bottomOpacity: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      drawer: const DrawerMain(),
      // body: SectionDivider(),
      bottomNavigationBar: const NavigationBarMain(),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return Text("will");
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
