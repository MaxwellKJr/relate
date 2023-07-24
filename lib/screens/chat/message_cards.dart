import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';

class MessageCards extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final int timestamp;

  const MessageCards({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<MessageCards> createState() => _MessageCardsState();
}

class _MessageCardsState extends State<MessageCards> {
  @override
  Widget build(BuildContext context) {
    final messageTime = DateTime.fromMillisecondsSinceEpoch(widget.timestamp);

    return Container(
      padding: EdgeInsets.only(
        top: 1,
        bottom: 1,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: widget.sentByMe ? primaryColor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              formatTime(messageTime),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
