import 'package:flutter/material.dart';
import 'package:relate/constants/size_values.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Column(
            children: [
              const Text("Disclaimer"),
              const Text("Disclaimer Text"),
              SizedBox(
                height: tButtonHeight,
                child: FilledButton(
                    onPressed: () {}, child: const Text('Proceed')),
              )
            ],
          )
        ],
      ),
    )));
  }
}
