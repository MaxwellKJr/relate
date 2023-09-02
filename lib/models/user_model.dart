import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final int? colorCode;
  final bool isVerified;
  final bool isBanned;
  final List<String> relatesTo;
  final List<String> followers;
  final int followersCount;
  final List<String> following;
  final int followingCount;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.colorCode,
    this.isVerified = false,
    this.isBanned = false,
    this.followingCount = 0,
    this.followersCount = 0,
  })  : relatesTo = const [],
        followers = const [],
        following = const [];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'colorCode': colorCode,
      'isVerified': isVerified,
      'isBanned': isBanned,
      'relatesTo': relatesTo,
      'followers': followers,
      'followersCount': followersCount,
      'following': following,
      'followingCount': followingCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'],
        userName: map['userName'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        colorCode: map['colorCode']);
  }
}

// Function to query a specific user by username
Future<UserModel?> getUserByUsername(String uid) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(
            1) // Limit to 1 result since there should be only one matching user
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Extract the user data from the query result
      Map<String, dynamic> userData =
          querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Create a User object from the retrieved data
      UserModel user = UserModel.fromMap(userData);
      return user;
    } else {
      // Handle case where the user with the given username doesn't exist
      return null;
    }
  } catch (e) {
    // Handle any errors that may occur
    print('Error querying user by username: $e');
    return null;
  }
}
