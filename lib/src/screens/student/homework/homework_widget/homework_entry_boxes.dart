/*
This file defines the `HomeworkEntryBoxes` widget used to represent individual
homework entries on the `HomeworkEntry` screen. Each box displays homework details
and navigates to the homework-ready screen when clicked.
*/

import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/exam_session_model.dart'
    show ExamDetailed, ExamGroupModel, ExamSession;
import '../homework_screens/homework_ready_screen.dart';

class HomeworkEntryBoxes extends StatelessWidget {
  const HomeworkEntryBoxes({
    super.key,
    required this.homeworkModel,
    required this.spaceId,
  });

  // final HomeworkModel homeworkModel;
  final ExamData homeworkModel;
  final String spaceId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          HomeworkReadyScreen.routeName,
          extra: {
            "id": homeworkModel.id,
            "spaceId": spaceId,
          },
        );
      },
      child: Container(
        height: 140.h,
        width: 361.w,
        decoration: BoxDecoration(
          color: greenShades[0],
          borderRadius: BorderRadius.circular(40.r),
        ),
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
              right: 15.w,
              bottom: 15.h,
              child: Container(
                width: 105.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: whiteShades[0],
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0.r),
                    child: Text(
                      homeworkModel?.name ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: setTextTheme(
                        fontSize: 10.sp,
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
                          homeworkModel.subject?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: setTextTheme(
                              fontSize: 28.sp,
                              color: whiteShades[0],
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.h),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          ExamData.formatDateWithSuffix(
                              DateTime.parse(homeworkModel.startDate)),
                          style: setTextTheme(
                              fontSize: 12.sp,
                              color: whiteShades[0],
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          ExamData.formatDateWithSuffix(
                              DateTime.parse(homeworkModel.endDate)),
                          style: setTextTheme(
                              fontSize: 12.sp,
                              color: whiteShades[0],
                              fontWeight: FontWeight.w400),
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
    );
  }
}

class GetHomeworkEntryBoxes extends StatelessWidget {
  const GetHomeworkEntryBoxes({
    super.key,
    required this.homeworkModel,
    required this.spaceId,
    // required this.lenght,
  });

  // final HomeworkModel homeworkModel;
  final ExamGroupModel homeworkModel;
  // final int lenght;
  final String spaceId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: blueShades[1],
      onTap: () {
          log('checking ${homeworkModel.examIds}');
        context.push(
          
          ExamSubmissionsScreen.routeName,
          extra: {
            "examGroupId": homeworkModel.id,
            "spaceId": spaceId,
            "title": homeworkModel.name,
            "examIds":homeworkModel.examIds,
            "classGroupId": context
                    .read<UserProvider>()
                    .singleSpace
                    ?.classInfo
                    ?.classGroupId ??
                '',
          },
        );
      },
      child: Container(
        height: 140.h,
        width: 361.w,
        decoration: BoxDecoration(
          color: greenShades[0],
          borderRadius: BorderRadius.circular(40.r),
        ),
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
              right: 15.w,
              bottom: 15.h,
              child: InkWell(
                onTap: () {
                 log('checking ${homeworkModel.examIds}');
                  context.push(
                    ExamSubmissionsScreen.routeName,
                    extra: {
                      "examGroupId": homeworkModel.id,
                      "spaceId": spaceId,
                      "title": homeworkModel.name,
                        "examIds":homeworkModel.examIds,
                      "classGroupId": context
                              .read<UserProvider>()
                              .singleSpace
                              ?.classInfo
                              ?.classGroupId ??
                          '',
                    },
                  );
                },
                child: Container(
                  width: 105.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: whiteShades[0],
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(5.0.r),
                      child: Text(
                        // homeworkModel?.exam.instruction ?? '',
                        'View Submissions',
                        overflow: TextOverflow.ellipsis,
                        style: setTextTheme(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
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
                          homeworkModel.name ?? '',
                          //'Subject',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: setTextTheme(
                              fontSize: 28.sp,
                              color: whiteShades[0],
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.h),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          homeworkModel.name ?? '',
                          style: setTextTheme(
                              fontSize: 12.sp,
                              color: whiteShades[0],
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "Exams: ${homeworkModel.examCount}",
                          style: setTextTheme(
                              fontSize: 12.sp,
                              color: whiteShades[0],
                              fontWeight: FontWeight.w400),
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
    );
  }
}
