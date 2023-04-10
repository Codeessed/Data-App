import 'package:data_app/model/data_model/users_response_model.dart';

class RegisterResponseModel{
  String status;
  String message;
  UserModel? data;

  RegisterResponseModel({
    required this.status,
    required this.message,
    this.data
  });

}