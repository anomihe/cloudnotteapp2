import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularProgressWithLabel extends StatelessWidget {
  final double value;
  final Color progressColor;
  final double size;

  const CircularProgressWithLabel({
    super.key,
    required this.value,
    required this.progressColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.r,
      height: size.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.flip(
            flipX: true,
            child: CircularProgressIndicator(
              value: value / 100,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              strokeWidth: 3.r,
              backgroundColor: ThemeProvider().isDarkMode
                  ? Colors.grey[800]
                  : Colors.grey[200],
            ),
          ),
          Text(
            '${value.toInt()}%',
            style: setTextTheme(fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
