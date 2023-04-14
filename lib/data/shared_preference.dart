import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{

  setLoggedIn(value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(value));
  }

  setRegistered(value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('register', json.encode(value));
  }

  getLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString('user')!);
  }

  getRegistered() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString('register')!);
  }

  removeLogIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  checkLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user');
  }

  checkRegistered() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('register');
  }

}