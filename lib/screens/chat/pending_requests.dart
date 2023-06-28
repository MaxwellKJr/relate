import 'package:flutter/material.dart';
import 'package:relate/services/chat_database_services.dart';

class PendingRequest extends StatefulWidget {
  final String groupId;

  const PendingRequest({Key? key, required this.groupId}) : super(key: key);

  @override
  State<PendingRequest> createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  List<Map<String, dynamic>> requestList = [];
  ChatDatabase chatDatabase =
      ChatDatabase(); // Create an instance of ChatDatabase

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> results = await chatDatabase
        .retrieveDataByGroupId(widget.groupId); // Use ChatDatabase instance
    setState(() {
      requestList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: requestList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(requestList[index]['userName']),
              subtitle: Text(requestList[index]['reason']),
              // You can add more information from the request if needed
            ),
          );
        },
      ),
    );
  }
}
