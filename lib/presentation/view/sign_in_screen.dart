import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget{
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => SignInScreenState();

}

class SignInScreenState extends State<SignInScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Sign In'),
      ),
    );
  }

}