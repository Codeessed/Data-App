
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_app/common/base_view_model.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:flutter/foundation.dart';

import '../../helpers/app_state.dart';
import '../../model/auth_model/login/login_model.dart';
import '../../model/auth_model/login/login_response_model.dart';
import '../../model/auth_model/register_response_model.dart';

class UserViewModel extends BaseViewModel{

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  final List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;

  late UserModel? _user;
  UserModel? get user => _user;

  final CollectionReference _users = FirebaseFirestore.instance.collection('users_data');


  void setUser(UserModel? user){
    _user = user;
    notifyListeners();
  }

  void setIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

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
      setAppState(AppState.loading);
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
    }catch(e){
      print('userExisting error $e');
      return existingItems;
    }
    return existingItems;
  }

  Future<RegisterResponseModel> addUser(UserModel user) async {
    late RegisterResponseModel register;
    var existings = await userExisting(user);
    try {
      setAppState(AppState.loading);
      if(existings.isEmpty){
        var _userDoc = _users.doc();
        var userDataToAdd = {
          "email": user.email,
          "username": user.username,
          "phone_number": user.phone_number,
          "password": user.password,
          "interests": user.interests,
          "id": _userDoc.id,
        };
        await _userDoc.set(userDataToAdd).then((documentSnapShot) async {
          register = RegisterResponseModel(status: 'success', message: "Registration successful.", data: UserModel.fromJson(userDataToAdd));
        }, onError: (e) => register = RegisterResponseModel(status: 'error', message: "An error occurred while registering -> $e"));
      }else{
        register = RegisterResponseModel(status: 'error', message: "This ${existings[0]} already exists.");
      }
    } catch (e) {
      register = RegisterResponseModel(status: 'error', message: "An error occurred while registering -> $e");
    }
    setAppState(AppState.idle);
    return register;
  }

  Future<LoginResponseModel> loginUser(LoginModel loginModel) async {
    late LoginResponseModel result;
    List<UserModel> user = [];
    try{
      setAppState(AppState.loading);
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
    }catch (e){
      result = LoginResponseModel(status: 'error', message: 'Error occurred -> $e');
    }
    setAppState(AppState.idle);
    return result;
  }

  Future<RegisterResponseModel> updateUser(
      {required String id, required String key, value}) async {
    late RegisterResponseModel updateResponse;
    try {
      setAppState(AppState.loading);
      await _users.doc(id).update({
          key:value
        }).then((documentSnapShot) async{
          await _users.doc(id).get().then((value) {
            updateResponse = RegisterResponseModel(status: 'success', message: '$key updated successfully', data: UserModel.fromJson(value.data() as Map<String, dynamic>));
          }, onError: (e) => updateResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
        }, onError: (e) => updateResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
    } catch (e) {
      updateResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e');
    }
    setAppState(AppState.idle);
    return updateResponse;
  }

  Future<RegisterResponseModel> resetPassword(
      {required String email, required String password }) async {
    List<UserModel> emails = [];
    late RegisterResponseModel resetResponse;
    try {
      setAppState(AppState.loading);
      await _users
          .where("email", isEqualTo: email)
      .get().then((QuerySnapshot querySnapshot) async {
        emails.addAll(querySnapshot.docs.map((e) => UserModel.fromDocument(e)));
        if(email.isNotEmpty) {
          await _users.doc(emails[0].id).update({
            'password':password
          }).then((documentSnapShot) {
            resetResponse = RegisterResponseModel(status: 'success', message: 'Password updated successfully');
          }, onError: (e) => resetResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
        }else{
          resetResponse = RegisterResponseModel(status: 'error', message: 'Email does not exist');
        }
      }, onError: (e) => resetResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
    } catch (e) {
      resetResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e');
    }
    setAppState(AppState.idle);
    return resetResponse;
  }

  Future<RegisterResponseModel> authenticateAndUpdate(
      {required String password, required String id, required String key, required String value }) async {
    late RegisterResponseModel valuesResponse;
    List<UserModel> values = [];

    try {
      setAppState(AppState.loading);
      await _users.doc(id).get().then((document) async {
        var userData = UserModel.fromDocument(document);
        if(userData.password == password){
          switch(key) {
            case 'username': {
              if(userData.username == value){
                valuesResponse = RegisterResponseModel(status: 'error', message: 'This is already your $key');
              }else{
                await _users
                    .where(key, isEqualTo: value)
                    .get().then((QuerySnapshot querySnapshot) async {
                  values.addAll(querySnapshot.docs.map((e) => UserModel.fromDocument(e)));
                  if(values.isNotEmpty) {
                    valuesResponse = RegisterResponseModel(status: 'error', message: 'Another user has this $key');
                  }else{
                    await _users.doc(id).update({
                      key:value
                    }).then((documentSnapShot) {
                      valuesResponse = RegisterResponseModel(status: 'success', message: '$key updated successfully');
                    }, onError: (e) => valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred while updating -> $e'));
                  }
                }, onError: (e) => valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
              }
            }
            break;

            case 'email': {
              if(userData.email == value){
                valuesResponse = RegisterResponseModel(status: 'error', message: 'This is already your $key');
              }else{
                await _users
                    .where(key, isEqualTo: value)
                    .get().then((QuerySnapshot querySnapshot) async {
                values.addAll(querySnapshot.docs.map((e) => UserModel.fromDocument(e)));
                if(values.isNotEmpty) {
                valuesResponse = RegisterResponseModel(status: 'error', message: 'Another user has this $key');
                }else{
                await _users.doc(id).update({
                key:value
                }).then((documentSnapShot) {
                valuesResponse = RegisterResponseModel(status: 'success', message: '$key updated successfully');
                }, onError: (e) => valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred while updating -> $e'));
                }
                }, onError: (e) => valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
              }
            }
            break;

            case 'password': {
              if(userData.password == value){
                valuesResponse = RegisterResponseModel(status: 'error', message: 'This is already your $key');
              }else{
                await _users.doc(id).update({
                  key:value
                }).then((documentSnapShot) {
                  valuesResponse = RegisterResponseModel(status: 'success', message: '$key updated successfully');
                }, onError: (e) => valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred while updating -> $e'));
              }
            }
            break;

            default: {
              valuesResponse = RegisterResponseModel(status: 'error', message: 'Unknown key');
            }
            break;
          }
        }else{
          valuesResponse = RegisterResponseModel(status: 'error', message: 'Wrong Password');
        }
      });

    } catch (e) {
      valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e');
    }
    setAppState(AppState.idle);
    return valuesResponse;
  }


  Future<RegisterResponseModel> checkAndEditValue(String key, String value, String id) async {
    late RegisterResponseModel valuesResponse;
    List<UserModel> values = [];
    await _users
        .where(key, isEqualTo: value)
        .get().then((QuerySnapshot querySnapshot) async {
      values.addAll(querySnapshot.docs.map((e) => UserModel.fromDocument(e)));
      if(values.isNotEmpty) {
        valuesResponse = RegisterResponseModel(status: 'error', message: 'Another user has this $key');
      }else{
        await _users.doc(id).update({
          key:value
        }).then((documentSnapShot) {
          valuesResponse = RegisterResponseModel(status: 'success', message: '$key updated successfully');
        }, onError: (e) => valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred while updating -> $e'));
      }
    }, onError: (e) => valuesResponse = RegisterResponseModel(status: 'error', message: 'An error occurred -> $e'));
    return valuesResponse;
  }



}