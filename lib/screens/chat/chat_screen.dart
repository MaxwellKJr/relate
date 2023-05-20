import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:relate/constants/text_string.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/screens/chat/chat_screen_body.dart';
import 'package:page_transition/page_transition.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ChatScreenBody());
  }
        title:
        const Text(tRelate, style: TextStyle(fontWeight: FontWeight.w500)),
        actions: const [Icon(Icons.more_vert)],
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.black12 // set color for dark theme
            : Colors.white24, // set color for light theme
        bottomOpacity: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
        body: const ChatScreenBody(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(milliseconds: 400),
                    child: const ViewMessage(),)
              );
            },

          backgroundColor: primaryColor,
          elevation: 3,
          child: const Icon(
            Icons.add,
            color: whiteColor,
          ),
        ),
    );
  }
}
