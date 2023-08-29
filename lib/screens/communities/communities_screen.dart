import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/communities/all_groups.dart';
import 'package:relate/screens/communities/create_group/create_group_screen.dart';
import 'package:relate/screens/communities/group_cards.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Communities extends StatefulWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream? groups;
  late final String userName, email, groupId, purpose, description, rules;
  Stream? allGroupsStream;
  Stream<List<DocumentSnapshot<Map<String, dynamic>>>>? myGroupsStream;

  // New alterations
  bool hasUserSearched = false;
  bool isJoined = false;

  // String manipulation
  String getUsertId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getUserName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getGroupName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getEmail(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    gettingUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch user data from SharedPreferences and Firestore
  gettingUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserName = prefs.getString('userName') ?? "";
    setState(() {
      userName = storedUserName;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    ChatDatabase chatDatabase = ChatDatabase(uid: userId);

    myGroupsStream = chatDatabase.getUserGroups();
    allGroupsStream = chatDatabase.getAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'My Groups'),
              Tab(text: 'All Groups'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Content for My Groups tab
                myGroupList(),
                // Content for All Groups tab
                allGroupList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                duration: const Duration(milliseconds: 400),
                child: const CreateGroup(),
              ));
        },
        backgroundColor: primaryColor,
        elevation: 3,
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      drawer: const DrawerMain(),
    );
  }

  // Widget for displaying the user's groups
  Widget myGroupList() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: myGroupsStream,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return noGroupWidget();
        }

        List<DocumentSnapshot> myGroups = snapshot.data!;

        return ListView.builder(
          itemCount: myGroups.length,
          itemBuilder: (context, index) {
            String groupId = myGroups[index].id;
            String imageUrl = myGroups[index].get('imageUrl');
            String groupName = myGroups[index].get('groupName');
            String purpose = myGroups[index].get('purpose');
            String admin = myGroups[index].get('admin');
            String description = myGroups[index].get('description');
            String rules = myGroups[index].get('rules');

            return GroupCards(
                imageUrl: imageUrl,
                groupId: groupId,
                userName: userName,
                groupName: groupName,
                rules: rules,
                admin: admin,
                description: description,
                purpose: purpose);
          },
        );
      },
    );
  }

  // Widget for displaying a message when the user has no groups
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "You have not joined any groups yet",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  // Widget for displaying the list of all groups
  Widget allGroupList() {
    return const AllGroups();
  }
}
