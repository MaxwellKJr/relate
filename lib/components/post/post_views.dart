import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relate/view_models/post_view_model.dart';
import 'package:relate/components/post/post_tile.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostViewModel>(context, listen: false).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Consumer<PostViewModel>(
        builder: (context, postViewModel, child) {
          return ListView.builder(
            itemCount: postViewModel.posts.length,
            itemBuilder: (context, index) {
              return PostTile(post: postViewModel.posts[index]);
            },
          );
        },
      ),
    );
  }
}
