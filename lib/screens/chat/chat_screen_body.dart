import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:relate/screens/chat/view_message.dart';
import 'package:relate/conversationList.dart';
import 'package:flutter/cupertino.dart';

class ChatScreenBody extends StatefulWidget {
  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('messages').orderBy('timestamp', descending: true).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            final messages = snapshot.data?.docs;

                            return ListView.builder(
                              itemCount: messages?.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final message = messages![index];
                                final messageId = message.id;

                                final String text = message['text'];
                                final String focus = message['focus'];

                                final image = message['image'];

                                final String sentBy = message['sentBy'];
                                final Timestamp timestamp = message['timestamp'];
                                final String uid = message['uid'];

                                // Format date
                                final dateTime = timestamp.toDate();
                                final formattedDate = DateFormat.yMMMMEEEEd().format(dateTime);
                                final formattedTime = DateFormat.Hm().format(dateTime);
                                final formattedDateTime = "$formattedDate @ $formattedTime";

                                return ConversationList(
                                  name: sentBy,
                                  text: text,
                                  image: image,
                                  time: formattedDateTime,
                                  isMessageRead: (index == 0 || index == 3) ? true : false,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
