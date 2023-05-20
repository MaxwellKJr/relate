import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relate/components/post/post_bottom_icons.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:relate/screens/chat/view_message.dart';
import 'package:relate/screens/chat/chat_screen.dart';
import 'package:relate/conversationList.dart';

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
                              itemBuilder: (context, index){
                                return ConversationList(
                                  //name: [index].name,
                                  text: [index].Text,
                                  image: chatUsers[index].image,
                                  time: chatUsers[index].time,
                                  isMessageRead: (index == 0 || index == 3)?true:false,
                                );
                              },
                            ),


                              itemBuilder: (context, index) {
                                final message = messages![index];
                                final messageId = message.id;

                                final String text = message['text'];
                                final String focus = message['focus'];

                                final image = message['image'];

                                final String sentBy = message['sentBy'];
                                final Timestamp timestamp = message['timestamp'];
                                final String uid = message['uid'];

                                //Format date
                                final dateTime = timestamp.toDate();
                                final formattedDate = DateFormat.yMMMMEEEEd()
                                    .format(dateTime);
                                final formattedTime = DateFormat.Hm().format(
                                    dateTime);
                                final formattedDateTime = "$formattedDate @ $formattedTime";

                                return SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: layoutPadding - 10,
                                        right: layoutPadding - 10,
                                        bottom: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewMessage(
                                                      messageId: messageId,
                                                      text: text,
                                                      focus: focus,
                                                      image: image,
                                                      sentBy: sentBy,
                                                      formattedDateTime: formattedDateTime,
                                                      uid: uid,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Card(
                                              elevation: 1,
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    layoutPadding),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          sentBy,
                                                          style: GoogleFonts
                                                              .poppins(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight
                                                                  .w800),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Icon(
                                                          Icons.circle_rounded,
                                                          color: Colors.grey,
                                                          size: 6,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          focus,
                                                          style: GoogleFonts
                                                              .poppins(
                                                              color: primaryColor,
                                                              fontSize: 15,
                                                              fontWeight: FontWeight
                                                                  .w800),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      '$formattedDate @ $formattedTime',
                                                      style: const TextStyle(),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      text,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.5),
                                                      maxLines: 5,
                                                    ),
                                                    if (message['image'] !=
                                                        null &&
                                                        message['image'] != '')
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .only(top: 10),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(20.0),
                                                          child: Image.network(
                                                            image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Container(),
                                                    const PostBottomIcons(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
  }}