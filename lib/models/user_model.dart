import 'package:flutter/material.dart';

class UserModel {
  final String? id;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? password;

  const UserModel({
    this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  toJson() {
    return {
      "userName": userName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password
    };
  }
}
