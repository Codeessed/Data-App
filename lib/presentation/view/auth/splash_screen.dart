
import 'package:data_app/main.dart';
import 'package:data_app/presentation/view/bottom_nav/bottom_nav.dart';
import 'package:data_app/presentation/view/auth/interests_screen.dart';
import 'package:data_app/presentation/view/auth/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/shared_preference.dart';
import '../../../model/data_model/users_response_model.dart';
import 'sign_in_screen.dart';

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
    await Future.delayed(const Duration(seconds: 1), () async {
      if(isRegistered){
        if(isLoggedIn) {
          loginData = UserModel.fromJson(await prefs.getLoggedIn());
          if(loginData.interests!.isNotEmpty){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNav()),
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
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(child: Icon(Icons.supervised_user_circle, color: Theme.of(context).primaryColor, size: 150,)),
    );

  }

}