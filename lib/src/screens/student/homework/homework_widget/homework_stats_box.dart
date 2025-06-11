import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeworkStatsBox extends StatelessWidget {
  const HomeworkStatsBox({
    super.key,
    required this.boxColor,
    required this.title,
    required this.figure,
    required this.textColor,
  });

  final Color boxColor;
  final String title;
  final String figure;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: setTextTheme(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            figure,
            style: setTextTheme(
              color: textColor,
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
