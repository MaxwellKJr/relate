import 'package:flutter/material.dart';
import 'package:relate/models/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    print('PostTile is being built with post: $post');
    return ListTile(
      title: Text("${post.postedBy}"),
      subtitle: Text("${post.timestamp.toString()} + ' - ' + ${post.text}"),
    );
  }
}
