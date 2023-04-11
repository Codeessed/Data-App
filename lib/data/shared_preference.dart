import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{

  setString(value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(value));
  }

  setBool() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('register', true);
  }

  getString() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString('user')!);
  }

  getBool() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('register');
  }

  removeString() async{
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