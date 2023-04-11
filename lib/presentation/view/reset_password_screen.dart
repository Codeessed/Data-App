import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget{
  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => ResetPasswordScreenState();

}

class ResetPasswordScreenState extends State<ResetPasswordScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Reset Password'),
      ),
    );
  }

}