import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationModel {

  String title;
  Widget icon;
  Widget screen;

  BottomNavigationModel({
    required this.title,
    required this.icon,
    required this.screen,
  });

}