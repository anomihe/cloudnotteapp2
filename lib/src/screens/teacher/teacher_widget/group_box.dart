import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/models/student_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../../../data/models/exam_session_model.dart' show ExamDetailed;
import '../teacher_screens/submission_screen.dart';

class GroupBox extends StatefulWidget {
  const GroupBox({
    super.key,
    required this.detailed,
    required this.classId,
    required this.examGroupId,
    required this.examId,
  });
  // final HomeworkModel homeworkModel;
  final ExamDetailed detailed;
  final String examGroupId;
  final List<String> examId;
  final String classId;
  @override
  State<GroupBox> createState() => _GroupBoxState();
}

class _GroupBoxState extends State<GroupBox> {
  bool isHovered = false;

  void _navigate() {
    context.push(SubmissionScreen.routeName, extra: {
      // "studentModel": StudentModel(
      //   name: '',
      //   image: '',
      //   score: '',
      //   dateTime: DateTime.now(),
      //   scoreCount: 20,
      //   selectedAnswers: {},
      //   chosenAnswer: [],
      //   uploadFiles: {},
      //   options: {},
      // ),
      "spaceId": context.read<UserProvider>().spaceId,
      "examGroupId": widget.examGroupId,
      "examId": [widget.detailed.id],
      "classId": widget.classId,
    }
        // extra: StudentModel(
        //   name: '',
        //   image: '',
        //   score: '',
        //   dateTime: DateTime.now(),
        //   scoreCount: 20,
        //   selectedAnswers: {},
        //   chosenAnswer: [],
        //   uploadFiles: {},
        //   options: {},
        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    //remember to a add this shade greyShades[0]
    Color boxColor = isHovered ? redShades[1] : Colors.white;
    Color textColor = isHovered ? whiteShades[0] : Color(0xff172B4D);

    return GestureDetector(
      onTapDown: (_) => setState(() => isHovered = true),
      onTapUp: (_) {
        setState(() => isHovered = false);
        _navigate();
      },
      onTapCancel: () => setState(() => isHovered = false),
      onLongPress: () {
        setState(() => isHovered = true);
        _navigate();
      },
      onLongPressEnd: (_) => setState(() => isHovered = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          height: 140.h,
          width: 361.w,
          decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: blueShades[7])),
          child: Stack(
            children: [
              Positioned(
                top: 10.h,
                right: 18.w,
                child: SvgPicture.asset(
                  'assets/icons/time_sand_icon.svg',
                  fit: BoxFit.none,
                ),
              ),
              Positioned(
                left: 65.w,
                bottom: 15.h,
                child: Text(
                  '${widget.detailed.examSessions.length} Submissions',
                  style: setTextTheme(
                    fontSize: 12.sp,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                right: 15.w,
                bottom: 8.h,
                child: Container(
                  width: 105.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                      color: whiteShades[0],
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: blueShades[7])),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(5.0.r),
                      child: Text(
                        "${widget.detailed.totalMark} mark",
                        overflow: TextOverflow.ellipsis,
                        style: setTextTheme(
                          fontSize: 10.sp,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Container(
                        width: 46.w,
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: redShades[4],
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/assignment_icon_small.svg',
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.detailed.name,
                            // widget.homeworkModel.subject,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: setTextTheme(
                              fontSize: 26.sp,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.h,
                            ),
                          ),
                          Text(
                            "Subject: ${widget.detailed.subject.name}",
                            // widget.homeworkModel.subject,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.h,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Start: ${formatDateTime(widget.detailed.startDate)}',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: textColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'End: ${formatDateTime(widget.detailed.endDate)}',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: textColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDateTime(String isoDate) {
    try {
      DateTime dateTime = DateTime.parse(isoDate).toLocal();
      return DateFormat("d'th' MMM yyyy - h:mma").format(dateTime);
    } catch (e) {
      log('Error parsing date: $isoDate');
      return 'Invalid Date';
    }
  }
}
