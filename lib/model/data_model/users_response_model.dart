
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String email;
  String username;
  String phone_number;
  String password;
  List? interests;
  // String id;

  UserModel({
    required this.email,
    required this.username,
    required this.phone_number,
    required this.password,
    this.interests,
    // required this.id
});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phone_number: json['phone_number'] ?? '',
      password: json['password'] ?? '',
      interests: json['interests'] ?? [],
      // interests: json['interests'] is Iterable ? List.from(json['interests']): null,
      // id: json['id'],
    );
  }

  factory UserModel.fromDocument(QueryDocumentSnapshot<Object?> documentSnapshot) {
    final data = documentSnapshot.data()! as Map<String, dynamic>;
    return UserModel.fromJson(data);
        // .copyWith(id: doc.id);
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": username,
    "phone_number": phone_number,
    "password": password,
    "interests": interests,
  };

}