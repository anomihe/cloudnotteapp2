import 'dart:developer';

import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/models/student_model.dart';
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_stats_screen.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/models/exam_session_model.dart';

import '../../../utils/alert_dialog.dart';
import '../teacher_screens/teacher_submission_view.dart';

class StudentSubmissions extends StatelessWidget {
  const StudentSubmissions({
    super.key,
    //required this.studentModel,
    required this.model,
    required this.examGroupId,
  });

  // final StudentModel studentModel;
  final String examGroupId;
  final ExamSessionData model;
  // final ExamSession model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(TeacherSubmissionView.routeName, extra: {
          // 'studentModel': StudentModel(
          //   name: 'Student Name',
          //   image: 'path/to/image',
          //   score: '0',
          //   dateTime: DateTime.now(),
          //   scoreCount: 0,
          //   selectedAnswers: <int, int?>{},
          //   chosenAnswer: <String>[],
          //   uploadFiles: <int, String?>{},
          //   options: <int, List<String>>{},
          // ),
          // 'homeworkModel': HomeworkModel(
          //   date: DateTime.now(),
          //   groupName: 'Group Name',
          //   subject: 'Subject',
          //   task: 'Task',
          //   questions: [],
          //   duration: Duration(seconds: 60),
          //   mark: 100,
          // ),
          'spaceId': context.read<UserProvider>().spaceId,
          'examGroupId': examGroupId,
          'examId': model.examId,
          'id': model.id,
          'studentId': model.studentId,
        });
      },
      onLongPress: () {
        // Provider.of<ExamHomeProvider>(context, listen: false).deleteStudent(
        //   context: context,
        //   spaceId: context.read<UserProvider>().spaceId,
        //   examGroupId: examGroupId,
        //   examid: model.examId,
        //   id: model.id,
        //   studentId: model.studentId,
        // );

        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Delete Submission'),
        //       content: SizedBox(
        //         height: 50.h,
        //         child: Column(
        //           children: [
        //             RichText(
        //                 text: TextSpan(
        //                     text: 'Are you sure you want to delete',
        //                     children: [
        //                   TextSpan(text: '${model.}'),
        //                   TextSpan(text: "submission")
        //                 ]))
        //           ],
        //         ),
        //       ),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             context.pop();
        //           },
        //           child: Text('Cancel'),
        //         ),
        //         TextButton(
        //           onPressed: () {},
        //           child: Text('Delet'),
        //         ),
        //       ],
        //     );
        //   },
        // );
      },
      child: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  // radius: MediaQuery.of(context).size.width * 0.0417,
                  // child: Text(model.exam.subject.name.substring(0)),
                  child: Text(model.student.user.lastName?[0] ?? ''),

                  //child: Text(model.exam.subject.name),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.student.user.lastName} ${model.student.user.firstName}',
                        style: setTextTheme(
                          color: blueShades[2],
                          fontSize: 16.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            "${model.totalScore.toStringAsFixed(2)}/${model.exam.totalMark}",
                            style: setTextTheme(
                              color: blueShades[2],
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '•',
                            style: setTextTheme(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: blueShades[2],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'view',
                            style: setTextTheme(
                                fontSize: 12.sp, fontWeight: FontWeight.w400),
                          ),
                        
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatDateTime(model.lastSavedAt),
                      style: setTextTheme(
                          fontSize: 12.sp,
                          color: blueShades[14],
                          fontWeight: FontWeight.w900),
                    ),
                    // Container(
                    //   height: 22.h,
                    //   width: 22.h,
                    //   decoration: BoxDecoration(
                    //     color: _getScoreColor(
                    //         model.totalScore, model.exam.totalMark),
                    //     borderRadius: BorderRadius.circular(100),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       '${model.totalScore}',
                    //       style: setTextTheme(
                    //         color: whiteShades[0],
                    //         fontSize: 10.sp,
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //   ),
                    // )
                   Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                      onTap: (){
                                     appCustomDialogThree(
  context: context,
  title: 'Reset Exam Session',
  content: SizedBox(
    height: 110,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
   
      children: [
        Text('Are you sure you want to reset this exam session? This will:',  style: setTextTheme(
                            fontSize: 12.sp,
                            color: blueShades[14],
                            fontWeight: FontWeight.w400),),
                            SizedBox(height: 5,),
        Text('  1. Extend the end time',  style: setTextTheme(
                            fontSize: 12.sp,
                            color: blueShades[14],
                            fontWeight: FontWeight.w400),),
                             SizedBox(height: 3,),
         Text('  2. Allow the student to retake the exam',  style: setTextTheme(
                            fontSize: 12.sp,
                            color: blueShades[14],
                            fontWeight: FontWeight.w400),),
                             SizedBox(height: 5,),
         Text('Note: This action cannot be undone.',   style: setTextTheme(
                            fontSize: 12.sp,
                            color: redShades[0],
                            fontWeight: FontWeight.w500),)
      ],
    ),
  ),
  action1: 'Cancel',
  action2: 'Reset',
  action1Function: (dialogContext) {
     Navigator.of(dialogContext, rootNavigator: true).pop();
  },
  action2Function: (dialogContext) async {
    final  inputData = ExamSessionInput(
                        id:model.id, 
                        spaceId:  context.read<UserProvider>().spaceId,
                        examGroupId: examGroupId,
                        examId: model.examId,
                        status: "inProgress", 
                        studentId: model.studentId,
                      ); 
    var data = await  Provider.of<ExamHomeProvider>(context, listen: false).resetExamSession(context: context, examSessionInput: inputData);

    if (data) {
         Alert.displaySnackBar(
                          context,
                          title: 'Success',
                          message: "Exam Session Reset Successful",
                        );
    Navigator.of(dialogContext, rootNavigator: true).pop();

    }else{
           Alert.displaySnackBar(
                          context,
                          title: 'Error',
                          message: "Unauthorized",
                        );
    Navigator.of(dialogContext, rootNavigator: true).pop();
    }
  },
);
                      },
                        child: Container(
                        height: 22.h,
                        width: 22.h,
                        decoration: BoxDecoration(
                          // color: _getScoreColor(
                          //     model.totalScore, model.exam.totalMark),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(CupertinoIcons.restart),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                          context.push(ExamSummaryScreen.routeName, extra: {
                     'spaceId': context.read<UserProvider>().spaceId,
            'studentId': model.studentId,
            'examGroupId': examGroupId,
            'examId': model.examId,
            'id': model.id
                  });
                      },
                        child: Container(
                        height: 22.h,
                        width: 22.h,
                        decoration: BoxDecoration(
                          // color: _getScoreColor(
                          //     model.totalScore, model.exam.totalMark),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(CupertinoIcons.chart_bar),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                      appCustomDialogTwo(
  context: context,
  title: 'Delete Submission',
  content: 'Are you sure you want to delete this submission?',
  action1: 'Cancel',
  action2: 'Delete',
  action1Function: (dialogContext) {
     Navigator.of(dialogContext, rootNavigator: true).pop();
  },
  action2Function: (dialogContext) async {
    var data = await Provider.of<ExamHomeProvider>(
      dialogContext,
      listen: false,
    ).deleteStudent(
      context: dialogContext,
      spaceId: dialogContext.read<UserProvider>().spaceId,
      examGroupId: examGroupId,
      examid: model.examId,
      id: model.id,
      studentId: model.studentId,
    );

    if (data) {
    Navigator.of(dialogContext, rootNavigator: true).pop();
    }
  },
);

                      },
                      child: Container(
                        height: 22.h,
                        width: 22.h,
                        decoration: BoxDecoration(
                          // color: _getScoreColor(
                          //     model.totalScore, model.exam.totalMark),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(CupertinoIcons.delete),
                      ),
                    )
                   ],)
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: greenShades[2],
          ),
        ],
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

  Color _getScoreColor(double totalScore, int totalMark) {
    if (totalMark == 0) return redShades[1];
    final percentage = (totalScore / totalMark) * 100;

    if (percentage >= 75) {
      return greenShades[0];
    } else if (percentage >= 50) {
      return goldenShades[0];
    } else {
      return redShades[1];
    }
  }
}
