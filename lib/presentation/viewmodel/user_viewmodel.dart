
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_app/common/base_view_model.dart';
import 'package:data_app/model/data_model/auth_model/login/login_data_model.dart';
import 'package:data_app/model/data_model/auth_model/login/login_model.dart';
import 'package:data_app/model/data_model/auth_model/login/login_response_model.dart';
import 'package:data_app/model/data_model/auth_model/register_response_model.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:flutter/foundation.dart';

import '../../helpers/app_state.dart';

class UserViewModel extends BaseViewModel{

  final List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;

  late LoginDataModel _user;
  LoginDataModel get user => _user;
  //
  // final List<UserModel> _allUsers = [];
  // List<UserModel> get allUsers => _allUsers;

  final CollectionReference _users = FirebaseFirestore.instance.collection('users_data');

  Future<void> getUsers() async {
    try {
      // AppLoaderUtil.showSecondaryLoading(defaultLoadingMessage);
      print('start get');
      _allUsers.clear();
      await _users.get().then((QuerySnapshot querySnapshot){
        _allUsers.addAll(querySnapshot.docs.map((e) => UserModel.fromDocument(e)));
      });
      // AppLoaderUtil.dismiss();
      print(_allUsers);
      notifyListeners();
    } catch (e) {
      print('error occurred getting');
      setAppState(AppState.idle);
    }
  }

  Future<List<String>> userExisting(UserModel user) async {
    List<String> existingItems = [];
    try{
      print('start checking');
      await _users.where(
        Filter.or(
            Filter("email", isEqualTo: user.email),
            Filter("username", isEqualTo: user.username),
            Filter("phone_number", isEqualTo: user.phone_number)
        )
      ).get().then((QuerySnapshot querySnapshot){
        for (var element in querySnapshot.docs) {
          if(UserModel.fromDocument(element).email == user.email){
            existingItems.add('email');
          }else if(UserModel.fromDocument(element).username == user.username){
            existingItems.add('username');
          }else if(UserModel.fromDocument(element).phone_number == user.phone_number){
            existingItems.add('phone number');
          }
        }});
      print('userExisting success');
    }catch(e){
      print('userExisting error $e');
      return existingItems;
    }
    return existingItems;
  }

  Future<RegisterResponseModel> addUser(UserModel user) async {
    var status = '';
    var message = '';
    var userData;
    var existings = await userExisting(user);
    try {
      print('checking existing');
      if(existings.isEmpty){
        var _usersDoc = _users.doc();
        await _usersDoc.set({
          "email": user.email,
          "username": user.username,
          "phone_number": user.phone_number,
          "password": user.password,
          "interests": user.interests,
          "id": _usersDoc.id,
        }).then((documentSnapShot){
              getUsers();
          message = "Registration successful";
          status = 'success';
          userData = user;
        });
      }else{
        status = 'error';
        message = "This ${existings[0]} already exists.";
        userData = null;
      }
      return RegisterResponseModel(status: status, message: message, data: userData);
    } catch (e) {
      message = e.toString();
      status = 'error';
      print('error occurred while registering -> $e');
      setAppState(AppState.idle);
    }
    return RegisterResponseModel(status: status, message: message, data: userData);
  }

  Future<LoginResponseModel> loginUser(LoginModel loginModel) async {
    late LoginResponseModel result;
    List<UserModel> user = [];
    try{
      await _users
          .where("email", isEqualTo: loginModel.email)
          .where("password", isEqualTo: loginModel.password)
          .get().then((QuerySnapshot querySnapshot){
        user.addAll((querySnapshot.docs).map((e) => UserModel.fromDocument(e)));
        if(user.isEmpty){
          result = LoginResponseModel(status: 'error', message: 'Email or password not correct.');
        }else{
          result = LoginResponseModel(status: 'success', message: 'Welcome ${user[0].username}', data: user[0]);
        }
      }, onError: (e) => result = LoginResponseModel(status: 'error', message: 'An error occurred $e'));
      // print(user);

      // _user = LoginDataModel(email: user[0].email, username: user[0].username, phoneNumber: user[0].phone_number);
    }catch (e){
      result = LoginResponseModel(status: 'error', message: 'Error occurred -> $e');
    }
    return result;
  }


  Future<LoginResponseModel> updateDetails(LoginModel loginModel) async {
    List<UserModel> user = [];
    try{
      await _users
          .where("email", isEqualTo: loginModel.email)
          .where("password", isEqualTo: loginModel.password)
          .get().then((QuerySnapshot querySnapshot){
        user.addAll((querySnapshot.docs).map((e) => UserModel.fromDocument(e)));
      });
      print(user);
      if(user.isEmpty){
        return LoginResponseModel(status: 'error', message: 'Email or password not correct.');
      }
      _user = LoginDataModel(email: user[0].email, username: user[0].username, phoneNumber: user[0].phone_number);
      return LoginResponseModel(status: 'success', message: 'Welcome ${user[0].username}');
    }catch (e){
      return LoginResponseModel(status: 'error', message: 'Error occurred -> $e');
    }
  }

  Future<RegisterResponseModel> updateUser(String id, String key, String value) async {
    late RegisterResponseModel updateResponse;
    try {
        await _users.doc(id).update({
          key:value
        }).then((documentSnapShot) async {
          getUsers();
          // await _users.doc(id).get().then((value) {
          //   updateResponse = RegisterResponseModel(status: 'success', message: '$key updated successfully', data: UserModel.fromJson(value.data() as Map<String, dynamic>));
          // }, onError: (e) => updateResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
        }, onError: (e) => updateResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
    } catch (e) {
      updateResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e');
      setAppState(AppState.idle);
    }
    return updateResponse;
  }


}