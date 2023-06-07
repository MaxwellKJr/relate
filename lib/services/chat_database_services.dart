import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

// extension DocumentSnapshotExtension<T> on DocumentSnapshot<T> {
//   DocumentSnapshot<T> copyWith({
//     dynamic data,
//     SnapshotMetadata? metadata,
//     bool? exists,
//     String? id,
//   }) {
//     return DocumentSnapshot<T>(
//       this.firestore,
//       this.reference,
//       data ?? this.data(),
//       metadata ?? this.metadata,
//       exists ?? this.exists,
//     );
//   }
// }

class ChatDatabase {
  final String? uid;
  ChatDatabase({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

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

  // modifying here only
  // get user groups
  // getUserGroups() async {
  //   return userCollection.doc(uid).snapshots();
  // }

//working individual user
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserGroups() {
    return userCollection.doc(uid).snapshots().asBroadcastStream().map(
      (DocumentSnapshot<Object?> snapshot) {
        return snapshot as DocumentSnapshot<Map<String, dynamic>>;
      },
    );
  }

  // Stream<DocumentSnapshot<Map<String, dynamic>>> getUserGroups() {
  //   return userCollection.doc(uid).snapshots().asBroadcastStream().switchMap(
  //     (userSnapshot) {
  //       String groupId = userSnapshot.data()!['groupId'] as String;

  //       if (groupId.isNotEmpty) {
  //         return groupCollection.doc(groupId).snapshots().map(
  //           (groupSnapshot) {
  //             String groupName = groupSnapshot.data()!['groupName'] as String;

  //             // Adding the groupName field to the userSnapshot data
  //             Map<String, dynamic> userData =
  //                 Map<String, dynamic>.from(userSnapshot.data()!);
  //             userData['groupName'] = groupName;

  //             return userSnapshot.copyWith(data: userData);
  //           },
  //         );
  //       } else {
  //         return Stream.value(
  //           userSnapshot.copyWith(data: {}),
  //         );
  //       }
  //     },
  //   );
  // }

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
      "admin": "${id}_${userName}",
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

  //used to get every member in a group
  getAllGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
// /the reall deaL
  // Stream<List<Map<String, dynamic>>> getAllGroups() {
  //   return groupCollection.snapshots().map((QuerySnapshot querySnapshot) {
  //     return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
  //       String documentId = documentSnapshot.id;
  //       String groupName = documentSnapshot.get("groupName");
  //       String description = documentSnapshot.get("description");
  //       String rules = documentSnapshot.get("rules");
  //       String purpose = documentSnapshot.get("purpose");

  //       // Replace "groupName" with the actual field name

  //       return {
  //         "id": documentId,
  //         "groupName": groupName,
  //         "description": description,
  //         "rules": rules,
  //         "purpose": purpose
  //       };
  //     }).toList();
  //   });
  // }

  // Stream<List<Map<String, dynamic>>> getAllGroups() {
  //   return groupCollection.snapshots().map((QuerySnapshot querySnapshot) {
  //     return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
  //       String documentId = documentSnapshot.id;
  //       String groupName = documentSnapshot.get("groupName");
  //       String description = documentSnapshot.get("description");
  //       String rules = documentSnapshot.get("rules");
  //       String purpose = documentSnapshot.get("purpose");

  //       return {
  //         "id": documentId,
  //         "groupName": groupName,
  //         "description": description,
  //         "rules": rules,
  //         "purpose": purpose
  //       };
  //     }).toList();
  //   });
  // }

  Stream<List<Map<String, dynamic>>> getAllGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

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

  // Future toggleGroupJoin(
  //     String groupId, String userName, String groupName) async {
  //   // doc reference
  //   DocumentReference userDocumentReference = userCollection.doc(uid);
  //   DocumentReference groupDocumentReference = groupCollection.doc(groupId);

  //   DocumentSnapshot documentSnapshot = await userDocumentReference.get();
  //   List<dynamic> groups = await documentSnapshot['groups'];

  //   print('Current groups: $groups');

  //   if (groups.contains(groupId)) {
  //     print('User is already a member of the group');
  //     await userDocumentReference.update({
  //       "groups": FieldValue.arrayRemove([groupId])
  //     });
  //     await groupDocumentReference.update({
  //       "members": FieldValue.arrayRemove([uid])
  //     });
  //   } else {
  //     print('User is not a member of the group');
  //     await userDocumentReference.update({
  //       "groups": FieldValue.arrayUnion([groupId])
  //     });
  //     await groupDocumentReference.update({
  //       "members": FieldValue.arrayUnion([uid])
  //     });
  //   }
  // }

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
        // "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
        "groups": FieldValue.arrayRemove(["${groupId}"])
      });
      await groupDocumentReference.update({
        // "members": FieldValue.arrayRemove(["${uid}_$userName"])
        "members": FieldValue.arrayRemove(["${uid}"])
      });
    } else {
      await userDocumentReference.update({
        // "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
        "groups": FieldValue.arrayUnion(["${groupId}"])
      });
      await groupDocumentReference.update({
        // "members": FieldValue.arrayUnion(["${uid}_$userName"])
        "members": FieldValue.arrayUnion(["${uid}"])
      });
    }
  }
}
