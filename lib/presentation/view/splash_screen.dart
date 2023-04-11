
import 'package:data_app/main.dart';
import 'package:data_app/presentation/view/interests_screen.dart';
import 'package:data_app/presentation/view/sign_in_screen.dart';
import 'package:data_app/presentation/view/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/shared_preference.dart';
import '../../model/data_model/users_response_model.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }

}

class SplashScreenState extends State<SplashScreen>{
  var prefs = SharedPreference();
  late bool isLoggedIn;
  late bool isRegistered;
  late UserModel loginData;

  @override
  initState()  {
    navigate();
    super.initState();
  }

  navigate() async {

    isRegistered = await prefs.checkRegistered();
    isLoggedIn = await prefs.checkLoggedIn();
    loginData = UserModel.fromJson(await prefs.getString());
    await Future.delayed(const Duration(seconds: 1), () {
      if(isRegistered){
        if(isLoggedIn){
          if(loginData.interests!.isNotEmpty){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage(title: "title")),
                    (route) => false);
          }else{
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InterestScreen()),
                    (route) => false);
          }
        }else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false);
        }
      }else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                (route) => false);
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loggedIn.toString())));
      // print(loggedIn.toString());
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(child: Icon(Icons.supervised_user_circle, color: Colors.purple, size: 150,)),
    );

  }

}