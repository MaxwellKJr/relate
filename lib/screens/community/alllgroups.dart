import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/screens/community/trialpage.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllGroups extends StatefulWidget {
  const AllGroups({Key? key}) : super(key: key);

  @override
  State<AllGroups> createState() => _AllGroupsState();
}

class _AllGroupsState extends State<AllGroups> {
  String userName = "";
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // Get the current user's information
  getCurrentUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var storedUserName = localStorage.getString('userName');

    setState(() {
      userName = storedUserName ??
          ""; // Use the stored user name from shared preferences
    });

    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatDatabase().getAllGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          if (snapshot.hasData) {
            final groups = snapshot.data!;

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final imageUrl = group['imageUrl'];
                final groupId = group['groupId'];
                final groupName = group['groupName'];
                final admin = group['admin'];
                final purpose = group['purpose'];
                final description = group['description'];
                final rules = group['rules'];

                return StreamBuilder<DocumentSnapshot>(
                  stream: ChatDatabase().getGroupData(groupId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    if (snapshot.hasData) {
                      final groupData = snapshot.data!;

                      final isMember =
                          groupData['members'].contains(user?.uid ?? '');

                      return isMember
                          ? JoinedGroupTile(
                              userName: userName,
                              groupId: groupId,
                              groupName: groupName,
                              admin: admin,
                              purpose: purpose,
                              description: description,
                              rules: rules,
                              imageUrl: imageUrl,
                            )
                          : GroupTile(
                              userName: userName,
                              groupId: groupId,
                              groupName: groupName,
                              admin: admin,
                              purpose: purpose,
                              description: description,
                              rules: rules,
                              imageUrl: imageUrl,
                            );
                    }

                    return const SizedBox();
                  },
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

// Widget for displaying a group tile for groups the user is not a member of
class GroupTile extends StatelessWidget {
  final String userName,
      groupId,
      groupName,
      admin,
      purpose,
      description,
      rules,
      imageUrl;

  const GroupTile({
    super.key,
    required this.userName,
    required this.groupId,
    required this.groupName,
    required this.admin,
    required this.purpose,
    required this.description,
    required this.rules,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrialPage(
                groupId: groupId,
                groupName: groupName,
                purpose: purpose,
                description: description,
                rules: rules,
                userName: userName),
          ),
        );
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            )),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: SizedBox(
          child: FilledButton(
              onPressed: () async {
                await ChatDatabase(uid: user!.uid)
                    .toggleGroupJoin(groupId, userName, groupName);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Successfully joined the group"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                "Join",
                style: GoogleFonts.roboto(),
              )),
        ),
      ),
    );
  }
}

/// Widget for displaying a group tile for groups the user is already a member of
class JoinedGroupTile extends StatelessWidget {
  final String userName,
      groupId,
      groupName,
      admin,
      purpose,
      description,
      rules,
      imageUrl;

  const JoinedGroupTile({
    super.key,
    required this.userName,
    required this.groupId,
    required this.groupName,
    required this.admin,
    required this.purpose,
    required this.description,
    required this.rules,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          )),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: SizedBox(
        child: FilledButton(
            onPressed: () {},
            child: Text(
              "Already Joined",
              style: GoogleFonts.roboto(),
            )),
      ),
    );
  }
}
