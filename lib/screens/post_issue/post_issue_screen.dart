import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';

class PostIssueScreen extends StatefulWidget {
  const PostIssueScreen({super.key});

  @override
  State<PostIssueScreen> createState() => _PostIssueScreenState();
}

class _PostIssueScreenState extends State<PostIssueScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            title: const Text('Post'),
            leading: IconButton(
              icon: Icon(Icons.adaptive.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              FilledButton(
                onPressed: () {},
                child: const Text("Share Issue"),
              )
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Share your thoughts...',
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
        ),
        // bottomNavigationBar: const NavigationBarMain(),
      ),
    ));
  }
}
