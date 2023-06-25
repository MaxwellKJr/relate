import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:relate/screens/community/alllgroups.dart';
import 'package:relate/screens/community/group_cards.dart';
// import 'package:relate/screens/community/search_and_join_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relate/components/navigation/drawer/drawer_community.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/navigation/navigation_bar.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/community/group_cards.dart';
import 'package:relate/screens/community/group_info_card.dart';
import 'package:relate/screens/community/search_and_join%20_screen.dart';
// import 'package:relate/screens/community/section_divider.dart';
import 'package:relate/screens/create_group/CreateGroup.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:relate/services/helper_functions.dart';
// import 'section_divider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class Communities extends StatefulWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream? groups;
  String userName = "";
  String email = "";
  String groupName = "";
  String groupId = "";
  String purpose = "";
  String description = "";
  String rules = "";
  Stream? allGroupsStream;
  // Stream<DocumentSnapshot<Map<String, dynamic>>>? myGroupsStream;
  Stream<List<DocumentSnapshot<Map<String, dynamic>>>>?
      myGroupsStream; // Updated type

  //new alterations
  bool hasUserSearched = false;
  bool isJoined = false;

//

  // string manipulation
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
      appBar: AppBar(
        title: const Text(tCommunityGroups,
            style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchAndJoin(
                          groupId: groupId,
                          // admin: admin,
                          groupName: groupName,
                          userName: userName,
                          description: description,
                          purpose: purpose,
                          rules: rules,
                        )),
              );
            },
          ),
        ],
      ),
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

  Widget myGroupList() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: myGroupsStream, // Updated stream type
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(
        //     child: CircularProgressIndicator(
        //       color: Theme.of(context).primaryColor,
        //     ),
        //   );
        // }

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
            String groupName = myGroups[index].get('groupName');
            String purpose = myGroups[index].get('purpose');
            String admin = myGroups[index].get('admin');
            String description = myGroups[index].get('description');

            String rules = myGroups[index].get('rules');

            return GroupCards(
                // groupId: myGroups[index].id,
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

  Widget allGroupList() {
    return AllGroups();
  }
}
