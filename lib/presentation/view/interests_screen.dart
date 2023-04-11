import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InterestScreen extends StatefulWidget{
  const InterestScreen({super.key});

  @override
  State<StatefulWidget> createState() => InterestScreenState();

}

class InterestScreenState extends State<InterestScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Interest Screen'),
      ),
    );
  }

}