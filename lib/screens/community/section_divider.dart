import 'package:flutter/material.dart';

class SectionDivider extends StatefulWidget {
  @override
  SectionDividers createState() => SectionDividers();
}

class SectionDividers extends State<SectionDivider> {
  int activeSectionIndex = -1;

  void selectSection(int index) {
    setState(() {
      activeSectionIndex = index;
    });
  }

  Widget buildSection(int index, String title, Widget content) {
    final isActive = activeSectionIndex == index;
    return GestureDetector(
      onTap: () => selectSection(index),
      child: Container(
        color: isActive ? Colors.blue : Colors.white,
        child: Center(
          child: Text(title,style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (activeSectionIndex == 0) {
      return Container(
        // color: Colors.blue,
        // what to display in the existing group
        child: Center(

        ),
      );
    } else if (activeSectionIndex == 1) {
      return Container(
        // color: Colors.green,
        child: Center(
          // child: Text(
          //   'Content for Section 2',
          //   style: TextStyle(
          //     fontSize: 20.0,
          //     color: Colors.white,
          //   ),
          // ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              // width: 150.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSection(0, 'Existing Groups', Container()),
                  const SizedBox(width: 50.0),
                  const Divider(
                    color: Colors.red,thickness: 5,
                    height: 3.0,
                  ),
                  buildSection(1, 'Join Groups', Container()),
                ],
              ),
            ),
          ),
          Expanded(
            child: buildContent(),
          ),
        ],
      ),
    );
  }
}
