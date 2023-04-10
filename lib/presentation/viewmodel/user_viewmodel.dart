
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_app/common/base_view_model.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:flutter/foundation.dart';

import '../../helpers/app_state.dart';

class UserViewModel extends BaseViewModel{

  final List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;
  //
  // final List<UserModel> _allUsers = [];
  // List<UserModel> get allUsers => _allUsers;

  final CollectionReference _users = FirebaseFirestore.instance.collection('users_data');

  // getUsers() async {
  //   _usersList = [];
  //   await _users.get().then((QuerySnapshot querySnapshot){
  //     _usersList.addAll((querySnapshot.docs)
  //         .map((e) => UserModel.fromDocument(e)));
  //   });
  //   print(_usersList.toList());
  // }

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

  Future<void> addUser(UserModel user) async {
    List<UserModel> existingUser = [];
    try {
      print('checking existing');
      var existings = await userExisting(user);
      existings.isEmpty? {
        print('start add'),
        await _users
            .add(user.toJson()).then((documentSnapShot) =>
        print("Data add with id -> ${documentSnapShot.id}")
        )
      }:
      // AppLoaderUtil.showSecondaryLoading(defaultLoadingMessage);

      // AppLoaderUtil.dismiss();
      getUsers();
    } catch (e) {
      print('error occurred adding -> $e');
      setAppState(AppState.idle);
    }
  }

}