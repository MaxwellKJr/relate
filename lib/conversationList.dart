import 'package:flutter/material.dart';

class ConversationList extends StatefulWidget {
  final String name;
  final String text;
  final String image;
  final String time;
  final bool isMessageRead;

  ConversationList({
    required this.name,
    required this.text,
    required this.image,
    required this.time,
    required this.isMessageRead,
  });

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.image),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(fontSize: 12, fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}