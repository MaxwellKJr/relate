// // import 'package:flutter/material.dart';
// // import 'package:relate/components/text_filter.dart';

// // class Flag_Keyword extends StatelessWidget {
// //   final List<String> bannedKeywords = [
// //     'fuck',
// //     'ass',
// //     'keyword3',
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Content Filtering Example',
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: Text('Content Filtering Example'),
// //         ),
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               TextFilter(
// //                 onSubmitted: (content) => flagOrFilterContent(context, content),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void flagOrFilterContent(BuildContext context, String content) {
// //     bool containsBannedKeyword = false;

// //     for (String keyword in bannedKeywords) {
// //       if (content.toLowerCase().contains(keyword.toLowerCase())) {
// //         containsBannedKeyword = true;
// //         break;
// //       }
// //     }

// //     if (containsBannedKeyword) {
// //       flagContentForReview(content);
// //       showDialog(
// //         context: context,
// //         builder: (context) => AlertDialog(
// //           title: Text('Content Violation'),
// //           content: Text('Your message contains banned keywords.'),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('OK'),
// //             ),
// //           ],
// //         ),
// //       );
// //     } else {
// //       // Proceed with normal handling of the content
// //       // ...
// //     }
// //   }

// //   void flagContentForReview(String content) {
// //     // Here, you can implement the logic to flag the content for manual review
// //     // You can store the flagged content in a database or notify your moderation team
// //     // for further action
// //     print('Content flagged for review: $content');
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:relate/components/content_filter.dart';
// import 'package:relate/components/textfield_filter.dart';

// class Flag_Keyword extends StatelessWidget {
//   final List<String> bannedKeywords = [
//     'fuck',
//     'ass',
//     'keyword3',
//   ];

//   final TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Content Filtering Example',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Content Filtering Example'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFilter(
//                 controller: controller,
//                 labelText: 'Enter your content galu iwe',
//                 onFieldSubmitted: (content) =>
//                     flagOrFilterContent(context, content, bannedKeywords),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
