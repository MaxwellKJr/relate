// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:relate/screens/self_journey/plan_detail_screen.dart';

// class SeeAllScreen extends StatelessWidget {
//   final String typeOfField;

//   SeeAllScreen(this.typeOfField);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All Plans - $typeOfField'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('plans')
//             .where('typeOfField', isEqualTo: typeOfField)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final plans = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: plans.length,
//               itemBuilder: (context, index) {
//                 final planData = plans[index].data() as Map<String, dynamic>;
//                 return ListTile(
//                   title: Text(planData['nameOfPlan']),
//                   subtitle: Text(planData['description']),
//                   onTap: () {
//                     // Navigate to the plan details screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PlanDetailScreen(planData),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relate/screens/self_journey/plan_detail_screen.dart';

class SeeAllScreen extends StatefulWidget {
  final String typeOfField;

  const SeeAllScreen({Key? key, required this.typeOfField}) : super(key: key);
  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Plans - ${widget.typeOfField}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('plans')
            .where('typeOfField', isEqualTo: widget.typeOfField)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final plans = snapshot.data!.docs;
            return ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final planData = plans[index].data() as Map<String, dynamic>;
                final imageURL = planData['image'];

                return GestureDetector(
                  onTap: () {
                    // Handle navigation to the detailed page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanDetailScreen(planData),
                      ),
                    );
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Image.network(
                          imageURL,
                          fit: BoxFit.cover,
                          height: 70,
                          width: 80,
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(planData['nameOfPlan']),
                            subtitle: Text(planData['description']),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
