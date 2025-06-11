import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/course_items_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/courses/course_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RecommendedCoursesWidget extends StatelessWidget {
  final CourseItemsModel course;

  const RecommendedCoursesWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          CourseSummaryScreen.routeName,
          extra: course,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: ThemeProvider().isDarkMode
                ? Colors.transparent
                : blueShades[18],
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                    image: DecorationImage(
                      image: AssetImage(course.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                        color: whiteShades[8],
                        borderRadius: BorderRadius.circular(3.r)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 10.r),
                        SizedBox(width: 2.w),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: course.review,
                                style: setTextTheme(
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' | ${course.totalReviews} reviews',
                                style: setTextTheme(
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 5.w,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 3.r,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: redShades[10],
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            course.subject,
                            style: setTextTheme(
                              fontSize: 10.sp,
                              color: redShades[11],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        _formatDuration(course.totalLessonHours),
                        style: setTextTheme(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Text(
                    course.courseTitle,
                    style: setTextTheme(
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    course.summaryText,
                    style: setTextTheme(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage(course.teacherProfilePic),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        course.teacherName,
                        style: setTextTheme(
                          fontSize: 10.sp,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// helper method to formatting total duration
String _formatDuration(double totalMinutes) {
  if (totalMinutes <= 60) {
    return '${totalMinutes.toStringAsFixed(0)} mins';
  } else {
    final hours = (totalMinutes / 60).floor();
    final minutes = (totalMinutes % 60).toStringAsFixed(0);
    return '$hours hrs $minutes mins';
  }
}
