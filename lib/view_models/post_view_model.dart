import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/models/post.dart';

class PostViewModel extends ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> getPosts() async {
    try { 
    var postsRef = FirebaseFirestore.instance.collection('posts');
    var posts = await postsRef.get();

    _posts = posts.docs
        .map((doc) => Post(
            postedBy: doc['postedBy'],
            text: doc['text'],
            timestamp: doc['timestamp']))
        .toList();
    notifyListeners();
    } catch (e) {
      print('Error is $e');
    }
  }
}
