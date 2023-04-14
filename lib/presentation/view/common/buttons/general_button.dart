import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:learnlyapp/helpers/constants/app-color.dart';
// import 'package:learnlyapp/views/common/widget/text.dart';

import '../../../../helpers/constants/app_color.dart';

class GeneralButton extends StatelessWidget {
  final String text;
  final double height, width, textSize, borderRadius;
  final Color color, textColor;
  final Function onTap;
  final FontWeight fontWeight;

  const GeneralButton(
      {required this.text,
        required this.onTap,
        this.height = 55,
        this.color = AppColor.secondaryColor,
        this.width = double.maxFinite,
        this.borderRadius = 15,
        this.textColor = Colors.white,
        this.textSize = 16,
        this.fontWeight = FontWeight.w700,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: textSize,
            color: textColor
          ),
        )
      ),
    );
  }
}
