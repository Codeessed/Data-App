import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{

  setString(value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(value));
  }

  getString() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString('user')!);
  }

  removeString() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  checkValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user');
  }

}