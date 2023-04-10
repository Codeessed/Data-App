import 'package:data_app/model/data_model/users_response_model.dart';

class AuthResponseModel{
  String status;
  String message;
  UserModel? data;

  AuthResponseModel({
    required this.status,
    required this.message,
    this.data
  });

}