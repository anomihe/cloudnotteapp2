import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// a global widget for the button

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonColor,
    this.borderColor,
    required this.text,
    this.width = 320.47,
    this.height = 40.52,
    this.borderRadius = 18.74,
    this.textStyle,
    this.onTap,
    SizedBox? leading,
  });

  final Color? buttonColor;
  final Color? borderColor;
  final String text;
  final double width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: whiteShades[0],
                  fontSize: 15.48.sp,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
