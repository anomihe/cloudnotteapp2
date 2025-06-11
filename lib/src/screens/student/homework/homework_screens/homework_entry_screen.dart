/*
This file defines the `HomeworkEntry` screen, which displays a list of homework entries.
It allows users to filter by subject and task, dynamically rendering a list of homework
entries using the `HomeworkEntryBoxes` widget. The screen uses responsive design with
the `flutter_screenutil` package and integrates navigation and UI customization.
*/

import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    as space show BasicAssessment, SpaceSession, Student;

import 'package:cloudnottapp2/src/data/local/mockdata/homework_mockdata.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart' show CustomDropdownFormField;

import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/homework_entry_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../data/models/user_model.dart' show SpaceTerm;
import '../../../../data/providers/exam_home_provider.dart';
import '../../../../data/providers/user_provider.dart';

class HomeworkEntryTabScreen extends StatefulWidget {
  final String spaceId;
  static const String routeName = '/homework_entry_screen';
  const HomeworkEntryTabScreen({super.key, required this.spaceId});

  @override
  State<HomeworkEntryTabScreen> createState() => _HomeworkEntryTabScreenState();
}

class _HomeworkEntryTabScreenState extends State<HomeworkEntryTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
     Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
      context: context,
      alias: context.read<UserProvider>().alias,
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Computer Based Test',
                  style: setTextTheme(
                      fontSize: 24.sp, fontWeight: FontWeight.w600)),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF1F1F1),
                        borderRadius: BorderRadius.circular(30.r),
                        border:
                            Border.all(color: Color(0xffFCFCFC), width: 2.0),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorWeight: 1.0,
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelStyle: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        labelStyle: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        dividerColor: Colors.transparent,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: blueShades[1],
                        ),
                        tabs: [
                          Tab(
                            text: 'New',
                          ),
                          //Tab(text: 'Submitted'),
                          Tab(text: 'Submitted'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                HomeworkEntry(spaceId: widget.spaceId),
                //Text('Submitted'),
                GetHomeworkEntry(spaceId: widget.spaceId),
              ],
            )));
  }
}

class HomeworkEntry extends StatefulWidget {
  // static const String routeName = '/homework_entry_screen';
  final String spaceId;
  const HomeworkEntry({
    super.key,
    required this.spaceId,
    // required this.homeworkModel,
  });

  // final HomeworkModel homeworkModel;

  @override
  State<HomeworkEntry> createState() => _HomeworkEntryState();
}

class _HomeworkEntryState extends State<HomeworkEntry> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<ExamHomeProvider>(context, listen: false).getUserExams(
      context: context,
      spaceId: widget.spaceId,
      pageSize: 100,
      offline: false,
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExamHomeProvider>(builder: (context, value, _) {
       
        return Skeletonizer(
          enabled: value.isLoading,
          child: value.examDate.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/app/paparazi_image_a.png'),
                      SizedBox(height: 60.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "No Assessment yet",
                          style: setTextTheme(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                    children: [
               
                      Expanded(
                        child: ListView.builder(
                          // itemCount: dummyHomework.length,
                          itemCount: value.examDate.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                HomeworkEntryBoxes(
                                  homeworkModel: value.examDate[index],
                                  spaceId: widget.spaceId,
                                ),
                                SizedBox(height: 10.h),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}

class GetHomeworkEntry extends StatefulWidget {
  // static const String routeName = '/homework_entry_screen';
  final String spaceId;
  const GetHomeworkEntry({
    super.key,
    required this.spaceId,
    // required this.homeworkModel,
  });

  // final HomeworkModel homeworkModel;

  @override
  State<GetHomeworkEntry> createState() => _GetHomeworkEntryState();
}

class _GetHomeworkEntryState extends State<GetHomeworkEntry> {
  String classSessionId = '';
  String termId = '';
  @override
  void initState() {
    log('my value ${widget.spaceId} v ${context.read<ExamHomeProvider>().exam?.examGroupId} vv ${context.read<ExamHomeProvider>().examSession?.examId}');
    classSessionId = localStore.get('sessionId',
        defaultValue: context.read<UserProvider>().classSessionId);
    termId = localStore.get('termId',
        defaultValue: context.read<UserProvider>().termId);
    Provider.of<ExamHomeProvider>(context, listen: false).getMyExamsGroup(
      context: context,
      spaceId: widget.spaceId,
      sessId: classSessionId,
      // examGroupId: context.read<ExamHomeProvider>().exam?.examGroupId ??
      //     '',
      // classGroupId: context.read<ExamHomeProvider>().examSession?.examId ??
      //     '', // replace with actual value
      classGroupId:
          context.read<UserProvider>().singleSpace?.classInfo?.classGroupId ??
              '',
      termId: termId,
    );
    super.initState();
  }
  String? sessionId;
  @override
  Widget build(BuildContext context) {
    //  final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
    return Scaffold(
      body: Column(
        children: [
        
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    //         child: Row(
    //           spacing: 10,
    //           children: [
    //              Expanded(
    //                 // fit: FlexFit.loose,
    //                 child: Consumer<ResultProvider>(
    //                   builder: (context, value, _) {
    //                     return CustomDropdownFormField<space.SpaceSession>(
    //                       hintText: 'Select Session',
    //                       onChanged: (value) {
    //                         setState(() {
    //                           sessionId = value?.id;
    //                         });
    //                  Provider.of<ExamHomeProvider>(context, listen: false).getMyExamsGroup(
    //   context: context,
    //   spaceId: widget.spaceId,
    //   sessId: sessionId ?? '',
    //   // examGroupId: context.read<ExamHomeProvider>().exam?.examGroupId ??
    //   //     '',
    //   // classGroupId: context.read<ExamHomeProvider>().examSession?.examId ??
    //   //     '', // replace with actual value
    //   classGroupId:
    //       context.read<UserProvider>().singleSpace?.classInfo?.classGroupId ??
    //           '',
    //   termId: termId,
    // );
              
    //                       },
    //                       items: value.space?.spaceSessions
    //                               ?.map(
    //                                 (session) => DropdownMenuItem<space.SpaceSession>(
    //                                   value: session,
    //                                   child: SizedBox(
    //                                     width: 100.w,
    //                                     child: Text(
    //                                       session.session,
    //                                       overflow: TextOverflow.ellipsis,
    //                                       maxLines: 1,
    //                                       softWrap: true,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               )
    //                               .toList() ??
    //                           [],
    //                     );
    //                   },
    //                 ),
    //               ),
    //                  Expanded(
    //                 child: CustomDropdownFormField<SpaceTerm>(
    //                   hintText: 'Select Term',
    //                   onChanged: (value) {
    //                     setState(() {
    //                       termId = value.id;
    //                     });
    //                       Provider.of<ExamHomeProvider>(context, listen: false).getMyExamsGroup(
    //   context: context,
    //   spaceId: widget.spaceId,
    //   sessId: sessionId??'',
  
    //   classGroupId:
    //       context.read<UserProvider>().singleSpace?.classInfo?.classGroupId ??
    //           '',
    //   termId: termId,
    // );
    //                   },
    //                   items: spaceTerms
    //                       .map(
    //                         (term) => DropdownMenuItem(
    //                           value: term,
    //                           child: SizedBox(
    //                             width: 100.w,
    //                             child: Text(
    //                               overflow: TextOverflow.ellipsis,
    //                               maxLines: 1,
    //                               softWrap: true,
    //                               term.name,
    //                               style: setTextTheme(),
    //                             ),
    //                           ),
    //                         ),
    //                       )
    //                       .toList(),
    //                 ),
    //               ),
    //         ],),
    //       ),
          
          Expanded(
            child: Consumer<ExamHomeProvider>(builder: (context, value, _) {
              return Skeletonizer(
                enabled: value.isLoading,
                child: value.examGroup.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/app/paparazi_image_a.png'),
                            SizedBox(height: 60.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Text(
                                "No Assessment Submitted yet",
                                style: setTextTheme(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            // CustomButton(
                            //   onTap: () {
                            //     context.pop();
                            //   },
                            //   text: 'Okay',
                            //   textStyle: setTextTheme(
                            //     fontSize: 15.48.sp,
                            //     fontWeight: FontWeight.w700,
                            //     color: whiteShades[0],
                            //   ),
                            //   buttonColor: redShades[0],
                            // ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(15.r),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                // itemCount: dummyHomework.length,
                                itemCount: value.examGroup.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GetHomeworkEntryBoxes(
                                        homeworkModel: value.examGroup[index],
                                        spaceId: widget.spaceId,
                                        // lenght: ,
                                      ),
                                      SizedBox(height: 10.h),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
