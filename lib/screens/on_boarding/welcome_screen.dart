import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/text_string.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            const Image(image: AssetImage(tLogo)),
            const Text(tWelcomeText),
            const Text(tWelcomeDescription),
            Column(
              children: [
                ElevatedButton(onPressed: (){}, child: const Text(tGetStartedText)),
                OutlinedButton(onPressed: (){}, child: const Text(tLoginInsteadText, style: TextStyle(backgroundColor: primaryColor),)),
              ],
            )
          ],
      ),
    );
  }
}
