import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupData extends StatefulWidget {
  @override
  _GroupDataState createState() => _GroupDataState();
}

class _GroupDataState extends State<GroupData> {
  late Stream<QuerySnapshot> groupStream;

  @override
  void initState() {
    super.initState();
    groupStream = FirebaseFirestore.instance.collection('groups').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: groupStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final groups = snapshot.data!.docs;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final groupId = group.id;
                final groupName = group['name'];
                return ListTile(
                  title: Text(groupName),
                  subtitle: Text(groupId),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
