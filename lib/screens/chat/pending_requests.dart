// // import 'package:flutter/material.dart';
// // import 'package:relate/services/chat_database_services.dart';

// // class PendingRequest extends StatefulWidget {
// //   final String groupId;

// //   const PendingRequest({Key? key, required this.groupId}) : super(key: key);

// //   @override
// //   State<PendingRequest> createState() => _PendingRequestState();
// // }

// // class _PendingRequestState extends State<PendingRequest> {
// //   List<Map<String, dynamic>> requestList = [];
// //   ChatDatabase chatDatabase =
// //       ChatDatabase(); // Create an instance of ChatDatabase

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchData();
// //   }

// //   Future<void> fetchData() async {
// //     List<Map<String, dynamic>> results = await chatDatabase
// //         .retrieveDataByGroupId(widget.groupId); // Use ChatDatabase instance
// //     setState(() {
// //       requestList = results;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: ListView.builder(
// //         itemCount: requestList.length,
// //         itemBuilder: (context, index) {
// //           return Card(
// //             child: ListTile(
// //               title: Text(requestList[index]['userName']),
// //               subtitle: Text(requestList[index]['reason']),
// //               // You can add more information from the request if needed
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:relate/services/chat_database_services.dart';
// import 'package:relate/screens/chat/Pending_request_details.dart';

// class PendingRequest extends StatefulWidget {
//   final String groupId;

//   const PendingRequest({Key? key, required this.groupId}) : super(key: key);

//   @override
//   State<PendingRequest> createState() => _PendingRequestState();
// }

// class _PendingRequestState extends State<PendingRequest> {
//   List<Map<String, dynamic>> requestList = [];
//   ChatDatabase chatDatabase =
//       ChatDatabase(); // Create an instance of ChatDatabase

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     List<Map<String, dynamic>> results = await chatDatabase
//         .retrieveDataByGroupId(widget.groupId); // Use ChatDatabase instance
//     setState(() {
//       requestList = results;
//     });
//   }

//   void navigateToDetailsPage(int index) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PendingRequestDetails(
//           groupId: requestList[index]['groupId'],
//           userId: requestList[index]['userId'],
//           userName: requestList[index]['userName'],
//           reason: requestList[index]['reason'],
//           // Pass any other required details
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: requestList.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text(requestList[index]['userName']),
//               subtitle: Text(requestList[index]['reason']),
//               onTap: () => navigateToDetailsPage(
//                   index), // Navigate to details page on tap
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:relate/services/chat_database_services.dart';
import 'package:relate/screens/chat/Pending_request_details.dart';

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
    List<Map<String, dynamic>> results =
        await chatDatabase.retrieveDataByGroupId(widget.groupId);
    setState(() {
      requestList =
          results.where((data) => data['status'] == 'NotApproved').toList();
    });
  }

  void navigateToDetailsPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendingRequestDetails(
          groupId: requestList[index]['groupId'],
          userId: requestList[index]['userId'],
          userName: requestList[index]['userName'],
          reason: requestList[index]['reason'],
        ),
      ),
    );
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
              onTap: () => navigateToDetailsPage(
                  index), // Navigate to details page on tap
            ),
          );
        },
      ),
    );
  }
}
