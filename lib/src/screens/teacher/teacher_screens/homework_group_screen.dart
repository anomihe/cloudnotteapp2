import 'dart:developer';

import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/homework_mockdata.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/custom_button.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_widget/group_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/providers/exam_home_provider.dart';
import '../../../data/providers/user_provider.dart';
import '../../student/student_landing.dart' show StudentLandingScreen;

class HomeworkGroupScreen extends StatefulWidget {
  const HomeworkGroupScreen(
      {super.key,
      required this.homeworkModel,
      required this.classGroupId,
      required this.examGroupId,
      required this.examIds,
      required this.classId,
      required this.spaceId});

  final String homeworkModel;
  final String classGroupId;
  final String examGroupId;
  final String classId;
  final String spaceId;
  final List<String> examIds;
  static const String routeName = '/homework_group_screen';

  @override
  State<HomeworkGroupScreen> createState() => _HomeworkGroupScreenState();
}

class _HomeworkGroupScreenState extends State<HomeworkGroupScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ExamHomeProvider>(context, listen: false).getMyExams(
        context: context,
        spaceId: widget.spaceId,
        classGroupId: widget.classGroupId,
        examGroupId: widget.examGroupId);
  }

  void _navigateBack(BuildContext context) {
    final role = localStore.get(
      'role',
      defaultValue: context.read<UserProvider>().role,
    );
    print('my role $role');
    context.push(StudentLandingScreen.routeName, extra: {
      'id': context.read<UserProvider>().spaceId,
      'provider': context.read<UserProvider>(),
      'currentIndex': role == 'teacher' ? 1 : 2,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            //context.pop();
            _navigateBack(context);
            // context.push(StudentLandingScreen.routeName, extra: {
            //   'id': context.read<UserProvider>().spaceId,
            //   'provider': context.read<UserProvider>(),
            //   "currentIndex": 2,
            // });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(14.w, 6.h, 6.w, 4.h),
            child: SizedBox(
              child: Icon(
      Icons.arrow_back_ios_new_rounded,
      color:  Colors.black,
    ),
              // SvgPicture.asset(
              //   'assets/icons/appbar_leading_icon.svg',
              //   fit: BoxFit.none,
              //   // height: 50.h,
              //   // width: 50.w,
              // ),
            ),
          ),
        ),
        leadingWidth: 45.w,
        title: Text(
          "Assessments",
          // widget.homeworkModel,
          style: setTextTheme(fontSize: 24.sp, fontWeight: FontWeight.w600),
        ),
        // centerTitle: false,
        actions: [
           Buttons(
                width: 100.w,
                height: 30.h,
                fontSize: 12.sp,
                boxColor: blueShades[0],
                fontWeight: FontWeight.w400,
                text: 'Questions Bank',
                isLoading: false,
                onTap: () {
                  launchUrl(Uri.parse("https://cloudnottapp2-v3-webapp.vercel.app"));
                  // context.push(MakePaymentScreen.routeName);
                },
              ),
              SizedBox(width: 10.w),
        ],
      ),
      body: Consumer<ExamHomeProvider>(builder: (context, value, _) {
        return Padding(
          padding: EdgeInsets.all(15.r),
          child: Skeletonizer(
            enabled: value.isLoading,
            child: value.examSessionData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/app/paparazi_image_a.png'),
                        SizedBox(height: 60.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            "No Submission",
                            style: setTextTheme(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        GestureDetector(
                          onTap: () {
                            context
                                .push(StudentLandingScreen.routeName, extra: {
                              'id': context.read<UserProvider>().spaceId,
                              'provider': context.read<UserProvider>(),
                              "currentIndex": 2,
                            });
                          },
                          child: CustomButton(
                            text: 'Okay',
                            textStyle: setTextTheme(
                              fontSize: 15.48.sp,
                              fontWeight: FontWeight.w700,
                              color: whiteShades[0],
                            ),
                            buttonColor: redShades[0],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    // itemCount: dummyHomework.length,
                    itemCount: value.examSessionData.length,
                    itemBuilder: (context, index) {
                      log("values to be passes ${widget.examGroupId} ${widget.examIds} ${widget.classId} ${value.examSessionData[index].id}");

                      return Column(
                        children: [
                          GroupBox(
                            classId: widget.classId,
                            examGroupId: widget.examGroupId,
                            examId: widget.examIds,
                            detailed: value.examSessionData[index],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      );
                    },
                  ),
          ),
        );
      }),
    );
  }
}
