import 'package:data_app/model/data_model/users_response_model.dart';

class LoginResponseModel{
  String status;
  String message;
  UserModel? data;

  LoginResponseModel({
    required this.status,
    required this.message,
    this.data
  });

}
