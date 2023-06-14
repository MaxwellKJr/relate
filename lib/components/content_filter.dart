import 'package:flutter/material.dart';

void flagOrFilterContent(
    BuildContext context, String content, List<String> bannedKeywords) {
  bool containsBannedKeyword = checkForBannedKeywords(content, bannedKeywords);

  if (containsBannedKeyword) {
    flagContentForReview(content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Content Violation'),
        content: Text('Your message contains banned keywords.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  } else {
    // Proceed with normal handling of the content
  }
}

bool checkForBannedKeywords(String content, List<String> bannedKeywords) {
  for (String keyword in bannedKeywords) {
    if (content.toLowerCase().contains(keyword.toLowerCase())) {
      return true;
    }
  }
  return false;
}

void flagContentForReview(String content) {
  // Here, you can implement the logic to flag the content for manual review
  // You can store the flagged content in a database or notify your moderation team
  // for further action
  print('Content flagged for review: $content');
}
