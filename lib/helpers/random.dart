import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'constants/app_color.dart';

class RandomFunction {
  static toast(String msg, {bool isError = false}) {
    showSimpleNotification(
        Text(msg),
        background: isError ? Colors.red : AppColor.secondaryColor);
  }
}
