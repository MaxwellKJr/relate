import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

// ChatDatabse is a class that handles interactions with a Firebase Firestore database for chat-related operations.
class ChatDatabase {
  final String? uid;
  ChatDatabase({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference professionalCollection =
      FirebaseFirestore.instance.collection("professionals");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference reasonsCollection =
      FirebaseFirestore.instance.collection('reasons');

  // Returns a stream of lists of group snapshots representing the groups a user is a member of.
  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getUserGroups() {
    return userCollection
        .doc(uid)
        .snapshots()
        .switchMap((DocumentSnapshot<Object?> userSnapshot) {
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      final List<String> groupIds = List<String>.from(userData['groups'] ?? []);

      final List<Stream<DocumentSnapshot<Map<String, dynamic>>>> groupStreams =
          groupIds.map((groupId) {
        return groupCollection
            .doc(groupId)
            .snapshots()
            .map((DocumentSnapshot<Object?> groupSnapshot) {
          return groupSnapshot as DocumentSnapshot<Map<String, dynamic>>;
        });
      }).toList();

      return CombineLatestStream.list(groupStreams);
    });
  }

  // Returns a filtered list of groups that the user is not a member of.
  Stream<List<Map<String, dynamic>>> filteredList() {
    return userCollection
        .doc(uid)
        .snapshots()
        .switchMap((DocumentSnapshot<Object?> userSnapshot) {
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      final List<String> groupId =
          List<String>.from(userData['groups'] ?? ["dgrg"]);

      final List<Stream<DocumentSnapshot<Map<String, dynamic>>>> groupStreams =
          groupId.map((groupId) {
        return groupCollection
            .doc(groupId)
            .snapshots()
            .map((DocumentSnapshot<Object?> groupSnapshot) {
          return groupSnapshot as DocumentSnapshot<Map<String, dynamic>>;
        });
      }).toList();

      return CombineLatestStream.list(groupStreams).map((groupSnapshotsList) {
        final List<Map<String, dynamic>> filteredGroups = groupSnapshotsList
            .where((groupSnapshot) {
              final List<dynamic> members =
                  List<dynamic>.from(groupSnapshot.data()!['members'] ?? []);
              return !members.contains(uid);
            })
            .map((groupSnapshot) => groupSnapshot.data()!)
            .toList();
        print(filteredGroups);
        return filteredGroups;
      });
    });
  }

  // Retrieves the members of a group.
  // [groupId]: The ID of the group.
  Stream<List<String>> groupMembers(String groupId) {
    return userCollection
        .doc(uid)
        .snapshots()
        .switchMap((DocumentSnapshot<Object?> userSnapshot) {
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      final List<String> groupId = List<String>.from(userData['groups'] ?? []);

      final List<Stream<DocumentSnapshot<Map<String, dynamic>>>> groupStreams =
          groupId.map((groupId) {
        return groupCollection
            .doc(groupId)
            .snapshots()
            .map((DocumentSnapshot<Object?> groupSnapshot) {
          return groupSnapshot as DocumentSnapshot<Map<String, dynamic>>;
        });
      }).toList();

      return CombineLatestStream.list(groupStreams).map((groupSnapshotsList) {
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
      });
    });
  }

  // Retrieves the usernames of the members in a group.
  Stream<List<String>> groupMemberss(String groupId) {
    return groupCollection
        .doc(groupId)
        .snapshots()
        .switchMap((DocumentSnapshot<Object?> groupSnapshot) {
      final List<dynamic> members = List<dynamic>.from((groupSnapshot.data()
              as Map<String, dynamic>)['members'] as List<dynamic>? ??
          []);
      final List<Stream<DocumentSnapshot<Object?>>> userStreams =
          members.map((uid) {
        return userCollection.doc(uid).snapshots();
      }).toList();

      return CombineLatestStream.list(userStreams).map((userSnapshotsList) {
        final List<String> userNames = [];
        for (DocumentSnapshot<Object?> userSnapshot in userSnapshotsList) {
          final Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          final String userName = userData['userName'] as String;
          userNames.add(userName);
        }
        print(userNames);
        return userNames;
      });
    });
  }

  // creates reason in the reasons collection with the arguments:
  // [userId]: The ID of the user.
  // [groupId]: The ID of the group.
  // [reason]: The reason text.
  // [userName]: The username of the user.
  Future<void> reasons(
      String userId, String groupId, String reason, String userName) async {
    await reasonsCollection.add({
      "userId": userId,
      "groupId": groupId,
      "reason": reason,
      "status": "NotApproved",
      "userName": userName,
    });
  }

  // Retrieves data from the reasons collection based on a group ID.
  Future<List<Map<String, dynamic>>> retrieveDataByGroupId(
      String groupId) async {
    List<Map<String, dynamic>> results = [];

    try {
      QuerySnapshot querySnapshot =
          await reasonsCollection.where('groupId', isEqualTo: groupId).get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        results.add(data);
      });
    } catch (e) {
      print('Error retrieving data: $e');
    }

    return results;
  }

  // Creates a new group in the group collection.
  // [userName]: The username of the creator.
  // [id]: The ID of the creator.
  // [groupName]: The name of the group.
  // [email]: The email associated with the creator.
  // [purpose]: The purpose of the group.
  // [rules]: The rules of the group.
  // [description]: The description of the group.
  // [imageUrl]: The URL of the group's image.
  Future createGroup(String userName, String id, String groupName, String email,
      String purpose, String rules, String description, String imageUrl) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "email": "$email",
      "imageUrl": imageUrl,
      "purpose": purpose,
      "rules": rules,
      "description": description,
      "groupIcon": "",
      "admin": "${id}",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}"]),
    });
  }

  // Retrieves the conversations (messages) for a specific group.
  Future getConversations(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // Retrieves the main admin of a specific group.
  Future getGroupMainAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // Retrieves all the members of a specific group.
  // [groupId]: The ID of the group.
  Future getAllGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // Retrieves the data of a specific group.
  // [groupId]: The ID of the group.
  Stream<DocumentSnapshot> getGroupData(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots();
  }

  // Sends a message to a specific group.
  // [groupId]: The ID of the group.
  // [chatMessageData]: The data of the chat message.
  void sendMessage(String groupId, Map<String, dynamic> chatMessageData) {
    chatMessageData["timeStamp"] = DateTime.now();
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // Retrieves all groups from the groups collection.
  Stream<List<Map<String, dynamic>>> getAllGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Searches for a group by its name.
  // [groupName]: The name of the group to search for.
  Future<QuerySnapshot> searchGroupName(String groupName) {
    return groupCollection
        .where("groupName", isEqualTo: groupName.toLowerCase())
        .get();
  }

  // Checks if a user has joined a group.
  // [groupId]: The ID of the group.
  // [groupName]: The name of the group.
  // [userName]: The username of the user.
  // Returns a future that resolves to a boolean indicating whether the user has joined the group.
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}")) {
      return true;
    } else {
      return false;
    }
  }

  // Toggles a user's membership in a group.
  // [groupId]: The ID of the group.
  // [userName]: The username of the user.
  // [groupName]: The name of the group.
  Future<void> toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains("${groupId}")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}"]),
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}"]),
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}"]),
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}"]),
      });
    }
  }
}
