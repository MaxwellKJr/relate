import 'package:flutter/material.dart';
import 'package:relate/models/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.postedBy.toString()),
      subtitle: Text("${post.timestamp} + ' - ' + ${post.text}"),
    );
  }
}
