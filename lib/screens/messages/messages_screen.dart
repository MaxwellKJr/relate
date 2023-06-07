import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relate/components/navigation/drawer/drawer_main.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/screens/post_issue/view_post_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      drawer: const DrawerMain(),
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(layoutPadding),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final posts = snapshot.data?.docs;

                    // posts
                    //     ?.map((post) => post.data())
                    //     .forEach((post) => debugPrint(post.toString()));

                    return ListView.builder(
                        itemCount: posts?.length,
                        itemBuilder: (context, index) {
                          final post = posts![index];
                          final postId = post.id;

                          // debugPrint(postId);

                          final String text = post['text'];
                          final String focus = post['focus'];

                          final image = post['image'];

                          final String postedBy = post['postedBy'];
                          final Timestamp timestamp = post['timestamp'];
                          final String uid = post['uid'];

                          //Format date
                          final dateTime = timestamp.toDate();
                          final formattedDate =
                              DateFormat.yMMMMEEEEd().format(dateTime);
                          final formattedTime =
                              DateFormat.Hm().format(dateTime);
                          final formattedDateTime =
                              "$formattedDate @ $formattedTime";

                          return SizedBox(
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: layoutPadding - 10,
                                    right: layoutPadding - 10,
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewPost(
                                                          postId: postId,
                                                          text: text,
                                                          focus: focus,
                                                          image: image,
                                                          postedBy: postedBy,
                                                          formattedDateTime:
                                                              formattedDateTime,
                                                          uid: uid,
                                                        )));
                                          },
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Card(
                                                elevation: 0,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.teal,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: layoutPadding + 5,
                                                    left: layoutPadding - 10,
                                                    right: layoutPadding - 10,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            postedBy,
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .circle_rounded,
                                                            color: Colors.grey,
                                                            size: 6,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            focus,
                                                            style: GoogleFonts.poppins(
                                                                color:
                                                                    primaryColor,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        '$formattedDate @ $formattedTime',
                                                        style:
                                                            const TextStyle(),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        text,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 14.5),
                                                        maxLines: 10,
                                                      ),
                                                      if (post['image'] !=
                                                              null &&
                                                          post['image'] != '')
                                                        Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              child:
                                                                  Image.network(
                                                                image,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ))
                                                      else
                                                        Container(),
                                                      // Container(
                                                      //     padding:
                                                      //         EdgeInsets.only(top: 10),
                                                      //     child: Image.network(
                                                      //         post['image'])),

                                                      PostBottomIcons(
                                                        postId: postId,
                                                        relates: List<
                                                                String>.from(
                                                            post['relates'] ??
                                                                []),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ])));
                        });
                  }
                },
              ))),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:relate/screens/user_profile/user_profile_screen.dart';
// import 'package:relate/screens/messages/message_detail_screen.dart';
// import 'package:relate/components/navigation/drawer/drawer_main.dart';
// import 'package:relate/constants/text_string.dart';
// import 'package:relate/constants/colors.dart';
// import 'package:relate/screens/chat/message_detail_page.dart';
// import 'package:relate/screens/profile/profile_screen.dart';

// class MessagesScreen extends StatefulWidget {
//   const MessagesScreen({Key? key}) : super(key: key);

//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   final CollectionReference<Map<String, dynamic>> chatsRef =
//   FirebaseFirestore.instance.collection('chats');
//   final CollectionReference<Map<String, dynamic>> usersRef =
//   FirebaseFirestore.instance.collection('users');

//   TextEditingController _searchController = TextEditingController();
//   List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Messages'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               _searchChats(_searchController.text);
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: chatsRef.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }

//           final chatDocs = snapshot.data?.docs ?? [];

//           return ListView.builder(
//             itemCount: _searchResults.isNotEmpty
//                 ? _searchResults.length
//                 : chatDocs.length,
//             itemBuilder: (context, index) {
//               final chatData = _searchResults.isNotEmpty
//                   ? _searchResults[index].data()
//                   : chatDocs[index].data();
//               final chatId = chatDocs[index].id;

//               return Dismissible(
//                 key: Key(chatId),
//                 direction: DismissDirection.endToStart,
//                 background: Container(
//                   color: Colors.red,
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Icon(
//                     Icons.delete,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onDismissed: (_) {
//                   _deleteChat(chatId);
//                 },
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Theme.of(context).primaryColor,
//                     child: Container(), // Empty container as the child
//                   ),
//                   title: Text(chatData?['chatName'] ?? ''),
//                   subtitle: Text(chatData?['lastMessage'] ?? ''),
//                   trailing: Text(chatData?['lastMessageTime'] ?? ''),
//                   onTap: () async {
//                     final conversationId = await _getConversationId(chatId);

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MessageDetailPage(
//                           conversationId: conversationId ?? '',
//                           userId: chatData?['user']['uid'] ?? '',
//                           userName: chatData?['chatName'] ?? '',
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           Navigator.pushNamed(context, UserProfileScreen.userProfile);
//       appBar: AppBar(title: const Text("Messages")),
//       drawer: const DrawerMain(),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 labelText: 'Search Chats',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 _searchChats(value);
//               },
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//               stream: chatsRef.snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final chatDocs = snapshot.data?.docs ?? [];

//                 return ListView.builder(
//                   itemCount: _searchResults.isNotEmpty
//                       ? _searchResults.length
//                       : chatDocs.length,
//                   itemBuilder: (context, index) {
//                     final chatData = _searchResults.isNotEmpty
//                         ? _searchResults[index].data()
//                         : chatDocs[index].data();
//                     final chatId = chatDocs[index].id;

//                     return ListTile(
//                       leading: const CircleAvatar(
//                         // Replace with chat user's profile image
//                         backgroundImage:
//                             AssetImage('assets/images/profile.png'),
//                       ),
//                       title: Text(chatData?['chatName'] ?? ''),
//                       subtitle: Text(chatData?['lastMessage'] ?? ''),
//                       trailing: Text(chatData?['lastMessageTime'] ?? ''),
//                       onTap: () async {
//                         final conversationId = await _getConversationId(chatId);

//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MessageDetailPage(
//                               conversationId: conversationId ?? '',
//                               userId: chatData?['user']['uid'] ?? '',
//                               userName: chatData?['chatName'] ?? '',
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const UserProfileScreen(),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<String?> _getConversationId(String chatId) async {
//     final currentUser = 'current-user-id-here'; // Replace with the actual current user ID

//     final snapshot = await chatsRef
//         .doc(chatId)
//         .collection('conversations')
//         .where('participants.$currentUser', isEqualTo: true)
//         .limit(1)
//         .get();

//     if (snapshot.docs.isNotEmpty) {
//       final conversationId = snapshot.docs.first.id;
//       return conversationId;
//     }

//     return null;
//   }

//   void _searchChats(String searchTerm) {
//     if (searchTerm.isEmpty) {
//       setState(() {
//         _searchResults = [];
//       });
//       return;
//     }

//     FirebaseFirestore.instance
//         .collection('chats')
//         .where('chatName', isEqualTo: searchTerm)
//         .get()
//         .then((snapshot) {
//       setState(() {
//         _searchResults = snapshot.docs;
//       });
//     });
//   }
//   void _deleteChat(String chatId) {
//     chatsRef.doc(chatId).delete().then((_) {
//       // Chat deleted successfully
//     }).catchError((error) {
//       // Error occurred while deleting chat
//     });
//   }
// }
