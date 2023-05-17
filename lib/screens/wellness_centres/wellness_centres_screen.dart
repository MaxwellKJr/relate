import 'package:flutter/material.dart';

class WellnessCenter {
  final String name;
  final String address;
  final String phone;
  final String website;
  final String description;

//constructors
  WellnessCenter({
    required this.name,
    required this.address,
    required this.phone,
    required this.website,
    required this.description,
  });
}

//display list of wellness centers
class WellnessCenterScreen extends StatelessWidget {
  final List<WellnessCenter> wellnessCenters = [
    WellnessCenter(
      name: 'ABC Wellness Center',
      address: '123 Main St, Anytown USA',
      phone: '555-1234',
      website: 'http://www.abcwellness.com',
      description:
          'ABC Wellness Center provides a variety of health and wellness services, including massage therapy, acupuncture, and yoga classes.',
    ),
    WellnessCenter(
      name: 'XYZ Wellness Center',
      address: '456 Oak St, Anytown USA',
      phone: '555-5678',
      website: 'http://www.xyzwellness.com',
      description:
          'XYZ Wellness Center offers nutritional counseling, fitness training, and meditation classes to help clients achieve optimal health and wellbeing.',
    ),
    // add more wellness centers here
  ];

  WellnessCenterScreen({Key? key}) : super(key: key);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
