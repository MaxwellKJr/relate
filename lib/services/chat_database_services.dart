import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

// }

class ChatDatabase {
  final String? uid;
  ChatDatabase({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  final CollectionReference reasonsCollection =
      FirebaseFirestore.instance.collection('reasons');

  // saving the userdata
  Future savingUserData(String userName, String email) async {
    return await userCollection.doc(uid).set({
      "userName": userName,
      "email": email,
      "groups": [],
      // "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
// //working individual user
  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getUserGroups() {
    return userCollection.doc(uid).snapshots().switchMap(
      (DocumentSnapshot<Object?> userSnapshot) {
        final Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        final List<String> groupIds =
            List<String>.from(userData['groups'] ?? []);

        final List<Stream<DocumentSnapshot<Map<String, dynamic>>>>
            groupStreams = groupIds.map((groupId) {
          return groupCollection.doc(groupId).snapshots().map(
            (DocumentSnapshot<Object?> groupSnapshot) {
              return groupSnapshot as DocumentSnapshot<Map<String, dynamic>>;
            },
          );
        }).toList();

        return CombineLatestStream.list(groupStreams);
      },
    );
  }

//latest trial
  Stream<List<Map<String, dynamic>>> filteredList() {
    return userCollection.doc(uid).snapshots().switchMap(
      (DocumentSnapshot<Object?> userSnapshot) {
        final Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        final List<String> groupId =
            List<String>.from(userData['groups'] ?? ["dgrg"]);

        final List<Stream<DocumentSnapshot<Map<String, dynamic>>>>
            groupStreams = groupId.map((groupId) {
          return groupCollection.doc(groupId).snapshots().map(
            (DocumentSnapshot<Object?> groupSnapshot) {
              return groupSnapshot as DocumentSnapshot<Map<String, dynamic>>;
            },
          );
        }).toList();

        return CombineLatestStream.list(groupStreams).map(
          (groupSnapshotsList) {
            final List<Map<String, dynamic>> filteredGroups = groupSnapshotsList
                .where(
                  (groupSnapshot) {
                    final List<dynamic> members = List<dynamic>.from(
                        groupSnapshot.data()!['members'] ?? []);
                    return !members.contains(uid);
                  },
                )
                .map(
                  (groupSnapshot) => groupSnapshot.data()!,
                )
                .toList();
            print(filteredGroups);
            return filteredGroups;
          },
        );
      },
    );
  }

  //group members
  Stream<List<String>> groupMembers(groupId) {
    return userCollection.doc(uid).snapshots().switchMap(
      (DocumentSnapshot<Object?> userSnapshot) {
        final Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        final List<String> groupId =
            List<String>.from(userData['groups'] ?? []);

        final List<Stream<DocumentSnapshot<Map<String, dynamic>>>>
            groupStreams = groupId.map((groupId) {
          return groupCollection.doc(groupId).snapshots().map(
            (DocumentSnapshot<Object?> groupSnapshot) {
              return groupSnapshot as DocumentSnapshot<Map<String, dynamic>>;
            },
          );
        }).toList();

        return CombineLatestStream.list(groupStreams).map(
          (groupSnapshotsList) {
            final List<String> filteredUsers = [];
            for (DocumentSnapshot<Map<String, dynamic>> groupSnapshot
                in groupSnapshotsList) {
              final List<dynamic> members =
                  List<dynamic>.from(groupSnapshot.data()!['members'] ?? []);
              if (members.contains(uid)) {
                filteredUsers.add(groupSnapshot.data()!['name']);
              }
            }
            print(filteredUsers);
            return filteredUsers;
          },
        );
      },
    );
  }

  Stream<List<String>> groupMemberss(String groupId) {
    return groupCollection.doc(groupId).snapshots().switchMap(
      (DocumentSnapshot<Object?> groupSnapshot) {
        final List<dynamic> members = List<dynamic>.from((groupSnapshot.data()
                as Map<String, dynamic>)['members'] as List<dynamic>? ??
            []);
        final List<Stream<DocumentSnapshot<Object?>>> userStreams =
            members.map((uid) {
          return userCollection.doc(uid).snapshots();
        }).toList();

        return CombineLatestStream.list(userStreams).map(
          (userSnapshotsList) {
            final List<String> userNames = [];
            for (DocumentSnapshot<Object?> userSnapshot in userSnapshotsList) {
              final Map<String, dynamic> userData =
                  userSnapshot.data() as Map<String, dynamic>;
              final String userName = userData['userName'] as String;
              userNames.add(userName);
            }
            print(userNames);
            return userNames;
          },
        );
      },
    );
  }

  //creating reasons table
  Future<void> reasons(
      String userId, String groupId, String reason, String userName) async {
    await reasonsCollection.add({
      "userId": userId,
      "groupId": groupId,
      "reason": reason,
      "status": "NotApproved",
      "userName": userName
    });
  }

  Future<List<Map<String, dynamic>>> retrieveDataByGroupId(
      String groupId) async {
    List<Map<String, dynamic>> results = [];

    try {
      QuerySnapshot querySnapshot =
          await reasonsCollection.where('groupId', isEqualTo: groupId).get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data =
            doc.data() as Map<String, dynamic>; // Explicit cast
        results.add(data);
      });
    } catch (e) {
      // Handle error
      print('Error retrieving data: $e');
    }

    return results;
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName, String email,
      String purpose, String rules, String description) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "email": "$email",
      //add
      "purpose": purpose,
      "rules": rules,
      "description": description,
      "groupIcon": "",
      // "admin": "${id}_${userName}",
      "admin": "${id}",

      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}"]),
      "groupId": groupDocumentReference.id,
    });

    // await groupDocumentReference.update({
    //   "members": FieldValue.arrayUnion(["${uid}_$email"]),
    //   "groupId": groupDocumentReference.id,
    // });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}"])
    });
  }

  //getting Conversations
  getConversations(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

//brings the admin
  Future getGroupMainAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // Future<List<String>> getAllUserNames(String groupId) async {
  //   List<String> memberIds = [];
  //   List<String> userNames = [];

  //   DocumentSnapshot groupSnapshot = await groupCollection.doc(groupId).get();
  //   if (groupSnapshot.exists) {
  //     final data = groupSnapshot.data()
  //         as Map<String, dynamic>?; // Explicit type annotation
  //     memberIds = List<String>.from(data?['members'] ?? []);
  //   }

  //   QuerySnapshot userSnapshot =
  //       await userCollection.where('userId', whereIn: memberIds).get();
  //   userSnapshot.docs.forEach((userDoc) {
  //     final userName = (userDoc.data() as Map<String, dynamic>)['userName'];
  //     if (userName != null) {
  //       userNames.add(userName);
  //     }
  //   });

  //   return userNames;
  // }

  // Stream<List<String>> getAllUserNames(String groupId) {
  //   return groupCollection.doc(groupId).snapshots().map((groupSnapshot) {
  //     List<String> memberIds = [];
  //     List<String> userNames = [];

  //     if (groupSnapshot.exists) {
  //       final groupData = groupSnapshot.data()
  //           as Map<String, dynamic>?; // Explicit type annotation
  //       memberIds = List<String>.from(groupData?['members'] ?? []);
  //     }

  //     userCollection
  //         .where('userId', whereIn: memberIds)
  //         .get()
  //         .then((userSnapshot) {
  //       userSnapshot.docs.forEach((userDoc) {
  //         final userName = (userDoc.data() as Map<String, dynamic>)['userName'];
  //         if (userName != null) {
  //           userNames.add(userName);
  //         }
  //       });
  //     });

  //     return userNames;
  //   });
  // }

  //used to get every member in a group
  getAllGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }
  // Future<QuerySnapshot> getAllGroupMembers(String groupId) async {
  //   // Fetch group members from the group collection
  //   DocumentSnapshot groupSnapshot = await groupCollection.doc(groupId).get();
  //   List<String> memberIds = List<String>.from(groupSnapshot.data()['members']);

  //   // Fetch user information from the user collection
  //   QuerySnapshot userSnapshot =
  //       await userCollection.where('userId', whereIn: memberIds).get();

  //   return userSnapshot;
  // }

  Stream<DocumentSnapshot> getGroupData(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots();
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    chatMessageData["timeStamp"] =
        DateTime.now(); // Add timestamp to the message data
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

//retrieve all groups
  Stream<List<Map<String, dynamic>>> getAllGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // //retrieve groups where the user is not in there
  // Stream<List<Map<String, dynamic>>> getAllGroups(String currentUserUid) {
  //   return FirebaseFirestore.instance
  //       .collection('groups')
  //       .where('members', isNotIn: [currentUserUid])
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  // }

//This function is used to search groups
  searchGroupName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  //check if a user is in a group using boolean //the collect one
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    // if (groups.contains("${groupId}_$groupName")) {
    if (groups.contains("${groupId}")) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    // if (groups.contains("${groupId}_$groupName")) {
    if (groups.contains("${groupId}")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}"])
      });
    }
  }
}

  
  //This function is used to add or remove a user
  // Future toggleGroupJoin(
  //     String groupId, String userName, String groupName) async {
  //   // doc reference
  //   DocumentReference userDocumentReference = userCollection.doc(uid);
  //   DocumentReference groupDocumentReference = groupCollection.doc(groupId);

  //   DocumentSnapshot documentSnapshot = await userDocumentReference.get();
  //   List<dynamic> groups = await documentSnapshot['groups'];

  //   // if user has our groups -> then remove then or also in other part re join
  //   // if (groups.contains("${groupId}_$groupName")) {
  //   if (groups.contains("${groupId}")) {
  //     await userDocumentReference.update({
  //       // "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
  //       "groups": FieldValue.arrayRemove(["${groupId}"])
  //     });
  //     await groupDocumentReference.update({
  //       // "members": FieldValue.arrayRemove(["${uid}_$userName"])
  //       "members": FieldValue.arrayRemove(["${uid}"])
  //     });
  //   } else {
  //     await userDocumentReference.update({
  //       // "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
  //       "groups": FieldValue.arrayUnion(["${groupId}"])
  //     });
  //     await groupDocumentReference.update({
  //       // "members": FieldValue.arrayUnion(["${uid}_$userName"])
  //       "members": FieldValue.arrayUnion(["${uid}"])
  //     });
  //   }
  // }`

  // This function is used to add or remove a user
  // Future toggleGroupJoin(
  //     String groupId, String userName, String groupName) async {'
