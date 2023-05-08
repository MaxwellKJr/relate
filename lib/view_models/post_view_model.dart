import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/models/post.dart';

class PostViewModel extends ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> getPosts() async {
    try {
      print('Fetching posts...');
      var postsRef = FirebaseFirestore.instance.collection('posts');
      var posts = await postsRef.get();
      // print('Fetched ${posts.docs.length} posts');

      _posts = posts.docs
          .map((doc) => Post(
                postedBy: doc.data()['postedBy'] ?? '',
                text: doc.data()['text'] ?? '',
                timestamp: doc.data()['timestamp'] ?? '',
                uid: doc.data()['uid'] ?? '',
              ))
          .toList();
      notifyListeners();
    } catch (e) {
      // print('Error is $e');
      // print('Error is ${_posts}');
    }
  }
}
