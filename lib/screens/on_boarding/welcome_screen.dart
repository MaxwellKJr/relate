import 'package:flutter/material.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/image_strings.dart';
import 'package:relate/constants/text_string.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
      Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: const AssetImage(tLogo), height:height * 0.5,),
            Column(
              children: [
                Text(tWelcomeText.toUpperCase(), style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.left, ),
                Text(tWelcomeDescription.toUpperCase(), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.left,),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                    child: ElevatedButton(
                        onPressed: (){},
                        child: const Text(tGetStartedText),
                    ),
                ),
                SizedBox(
                  width: double.infinity,
                    child: OutlinedButton(
                        onPressed: (){}, child: const Text(tLoginInsteadText)
                    ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
