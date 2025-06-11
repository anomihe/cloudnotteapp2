import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// this is the circular boxes at the bottom of the question screen

class AnswerNotifierBoxes extends StatelessWidget {
  const AnswerNotifierBoxes({
    super.key,
    required this.questionNumber,
    required this.onSelectAnswerNotifier,
    required this.isCurrentQuestion,
    this.isAnswered = false,
  });

  final int questionNumber;
  final VoidCallback onSelectAnswerNotifier;
  final bool isCurrentQuestion;
  final bool? isAnswered;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectAnswerNotifier,
      child: Container(
        height: 30.h,
        width: 30.h,
        decoration: BoxDecoration(
          color: isCurrentQuestion
              ? redShades[0]
              : isAnswered!
                  ? blueShades[1]
                  : Colors.white,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isCurrentQuestion || isAnswered!
                ? Colors.transparent
                : redShades[0],
          ),
        ),
        child: Center(
            child: Text(
          '$questionNumber',
          style: setTextTheme(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: isCurrentQuestion || isAnswered!
                  ? Colors.white
                  : Colors.black),
        )),
      ),
    );
  }
}
