
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String email;
  String username;
  String phone_number;
  String password;
  List? interests;
  String id;

  UserModel ({
    required this.email,
    required this.username,
    required this.phone_number,
    required this.password,
    this.interests,
    required this.id
});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phone_number: json['phone_number'] ?? '',
      password: json['password'] ?? '',
      interests: json['interests'] ?? [],
      id: json['id'] ?? ''
    );
  }

  factory UserModel.fromDocument(value) {
    final data = value.data()! as Map<String, dynamic>;
    return UserModel.fromJson(data);
        // .copyWith(id: documentSnapshot.id);
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": username,
    "phone_number": phone_number,
    "password": password,
    "interests": interests,
    "id": id
  };



}