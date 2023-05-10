import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/image_strings.dart';

class PostBottomIcons extends StatefulWidget {
  const PostBottomIcons({super.key});

  @override
  State<PostBottomIcons> createState() => _PostBottomIconsState();
}

class _PostBottomIconsState extends State<PostBottomIcons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool related = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (related == false) {
                  related == true;
                  _controller.forward();
                  Fluttertoast.showToast(
                      msg: "Post Related",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: primaryColor,
                      textColor: whiteColor,
                      fontSize: 16.0);
                } else {
                  related == true;
                  _controller.reverse;
                  Fluttertoast.showToast(
                      msg: "Post Unrelated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: primaryColor,
                      textColor: whiteColor,
                      fontSize: 16.0);
                }
              },
              child: Lottie.asset(relateHeart,
                  height: 50, width: 50, controller: _controller),
            ),
            const Icon(
              Icons.comment,
              size: 25,
            ),
            const Icon(
              Icons.share,
              size: 25,
            ),
          ],
        ));
  }
}
