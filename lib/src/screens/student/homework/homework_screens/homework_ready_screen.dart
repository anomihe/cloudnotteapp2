/*
 * File: homework_ready_screen.dart
 * 
 * This file defines the `HomeworkReadyScreen`, a StatefulWidget that acts as a confirmation screen for students 
 * before they start a homework task. It displays a message prompting the user to confirm their readiness to begin 
 * the homework. The screen contains a styled confirmation dialog with two buttons:
 * 1. "Start" to proceed to the homework question screen.
 * 2. "I'm not ready" to return to the previous screen.
 * 
 * Key Features:
 * - Receives `HomeworkModel` data to dynamically populate the UI.
 * - Utilizes the `HomeworkContainer` widget for consistent layout and style.
 * - Implements navigation using `go_router` for smooth screen transitions.
 */

import 'dart:developer';
import 'dart:io';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_question_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/homework_container.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/student_submission_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/providers/exam_home_provider.dart';

class HomeworkReadyScreen extends StatefulWidget {
  const HomeworkReadyScreen({
    super.key,
    required this.id,
    required this.spaceId,
    required this.examGroupId,
    required this.examId,
    required this.pin,
  });
  final String id;
  final String spaceId;
  final String examGroupId;
  final String examId;
  final String pin;
  // final HomeworkModel homeworkModel;
  static const String routeName = '/homework_ready_screen';

  @override
  State<HomeworkReadyScreen> createState() => _HomeworkReadyScreenState();
}

class _HomeworkReadyScreenState extends State<HomeworkReadyScreen> {
  bool _mounted = false;
  TextEditingController _pinController = TextEditingController();
  bool isObscure = true;
  @override
  void initState() {
    super.initState();
    log('the pins ${widget.examGroupId} ${widget.examId}');
    _mounted = true;
    log('the pins ${widget.examGroupId} ${widget.examId}');
    _fetchExamData();
    // Provider.of<ExamHomeProvider>(context, listen: false)
    //     .getUserExam(context: context, spaceId: widget.spaceId, id: widget.id);
  }

  Future<void> _fetchExamData() async {
    try {
      final provider = Provider.of<ExamHomeProvider>(context, listen: false);
      await provider.getUserExam(
        context: context,
        spaceId: widget.spaceId,
        id: widget.id,
      );
    } catch (e) {
      if (_mounted) {
        log('Error fetching exam: $e');
      }
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExamHomeProvider>(builder: (context, value, _) {
        if (!_mounted) return const SizedBox.shrink();
        return Skeletonizer(
          enabled: value.isLoading,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 11.r, right: 11.r),
              child: HomeworkContainer(
                richText: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Are you sure you want to take ',
                      style: setTextTheme(
                          fontSize: 16.sp, fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      // text: value.exam?.subject.name ?? '',
                      text: value.exam?.name ?? '',
                      style: setTextTheme(
                          fontSize: 16.sp, fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text:
                          ' ? Once you start the exam, you can’t go back again.',
                      style: setTextTheme(
                          fontSize: 16.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                primaryButtonText: 'Start',
                secondaryButtonText: "I'm not ready",
                // used for navigating to the homework question screen
                onPrimaryButtonTap: () {
                  // context.push(
                  //   HomeworkQuestionScreen.routeName,
                  //   extra: {
                  //     'id': widget.id,
                  //     'spaceId': widget.spaceId,
                  //     'examGroupId': value.exam?.examGroup.id,
                  //     'examId': value.exam?.id,
                  //     'pin': value.exam?.pin,
                  //     'subject': value.exam?.subject.name,
                  //   },
                  // );
                  if (value.exam?.hasPin == true) {
                    showClassSelectionDialog(
                        context: context,
                        groupId: value.exam?.examGroup.id,
                        examId: value.exam?.id,
                        pin: value.exam?.pin,
                        subjectName: value.exam?.subject.name,
                        myPin: value.exam?.pin);
                  } else {
                    context.push(
                      HomeworkQuestionScreen.routeName,
                      extra: {
                        'id': widget.id,
                        'spaceId': widget.spaceId,
                        'examGroupId': value.exam?.examGroup.id,
                        'examId': value.exam?.id,
                        'pin': value.exam?.pin,
                        'subject': value.exam?.subject.name,
                      },
                    );
                  }
                },
                onSecondaryButtonTap: () {
                  context.pop();
                },
                primaryButtonColor: redShades[0],
                secondaryButtonBorderColor: redShades[0],
              ),
            ),
          ),
        );
      }),
    );
  }

  void showClassSelectionDialog(
      {required BuildContext context,
      required String? groupId,
      required String? examId,
      required String? pin,
      required String? subjectName,
      required String? myPin}) {
    String? selectedClass;
    String? classId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Enter Your Exam Pin",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Enter the exam pin to proceed",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _pinController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    onChanged: (value) {},
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                log('the pins ${_pinController.text} $myPin');
                if (_pinController.text == myPin) {
                  // Navigator.pop(context, selectedClass);
                  context.push(
                    HomeworkQuestionScreen.routeName,
                    extra: {
                      'id': widget.id,
                      'spaceId': widget.spaceId,
                      'examGroupId': groupId,
                      'examId': examId,
                      'pin': pin,
                      'subject': subjectName,
                    },
                  ).then(
                    (value) {
                      _pinController.clear();
                    },
                  );
                } else {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.error(
                      message: "Incorrect pin",
                    ),
                  );
                  // AlertDialog(
                  //   title: const Text("Invalid Pin"),
                  //   content: const Text(
                  //       "The pin you entered is incorrect. Please try again."),
                  //   actions: [
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //       child: const Text("OK"),
                  //     ),
                  //   ],
                  // );
                }
              },
              child: const Text("Proceed"),
            ),
          ],
        );
      },
    );
  }
}

// class ExamSubmissionsScreen extends StatelessWidget {
//   static const routeName = "/exam_submissions";
//   const ExamSubmissionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Exam Submissions: Mid Term Tests, 2022/23",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           bottom: const TabBar(
//             labelColor: Colors.red,
//             unselectedLabelColor: Colors.black54,
//             indicatorColor: Colors.red,
//             tabs: [
//               Tab(text: "Submissions"),
//               Tab(text: "Summary"),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             SubmissionsTab(),
//             SummaryTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ExamSubmissionsScreen extends StatefulWidget {
  final String classGroupId;
  final String examGroupId;
   final List<String> examIds;
  final String title;
  final String spaceId;

  static const routeName = "/exam_submissions";
  const ExamSubmissionsScreen(
      {super.key,
      required this.classGroupId,
      required this.examGroupId,
      required this.title,
       required this.examIds,
      required this.spaceId});

  @override
  State<ExamSubmissionsScreen> createState() => _ExamSubmissionsScreenState();
}

class _ExamSubmissionsScreenState extends State<ExamSubmissionsScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch exam submissions for the current student/class
    Provider.of<ExamHomeProvider>(context, listen: false).getMySubmission(
      context: context,
      spaceId: widget.spaceId,
      classGroupId: widget.classGroupId,
      examGroupId: widget.examGroupId,
    );
  }

  void _navigateBack(BuildContext context) {
    final role = localStore.get(
      'role',
      defaultValue: context.read<UserProvider>().role,
    );

    context.push(StudentLandingScreen.routeName, extra: {
      'id': widget.spaceId,
      'provider': context.read<UserProvider>(),
      'currentIndex': role == 'teacher' ? 1 : 2,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: () => _navigateBack(context),
        ),
        title: Text(
          "Submissions",
          style: setTextTheme(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<ExamHomeProvider>(
        builder: (context, value, _) {
          return Skeletonizer(
            enabled: value.isLoading,
            child: value.examSessionDataSub.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/app/paparazi_image_a.png'),
                        SizedBox(height: 60.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            "No Submissions Found",
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
                : ListView.builder(
                    itemCount: value.examSessionDataSub.length,
                    itemBuilder: (context, index) {
                      final submission = value.examSessionDataSub[index];

                      // Defensive check to avoid index or null issues
                      if (submission.examSessions.isEmpty) {
                        return SizedBox.shrink(); // Skip rendering if empty
                      }

                      final session = submission.examSessions.first;

                      Color getScoreColor(double totalScore, int totalMark) {
                        if (totalMark == 0) return redShades[1];
                        double percentage = (totalScore / totalMark) * 100;
                        percentage = double.parse(percentage.toStringAsFixed(2));
                        if (percentage >= 75) {
                          return greenShades[0];
                        } else if (percentage >= 50) {
                          return goldenShades[0];
                        } else {
                          return redShades[1];
                        }
                      }

                      return ListTile(
                        onTap: () {
                          log('on pressed studentId: ${session.studentId} '
                              'examGroupId: ${widget.examGroupId} '
                              'examId: ${context.read<ExamHomeProvider>().examId} '
                              'id: ${session.id}''exid ${submission.id}');

                          if (submission.showCorrections == true) {
                            context.push(StudentSubmissionView.routeName, extra: {
                              'spaceId': context.read<UserProvider>().spaceId,
                              'examGroupId': widget.examGroupId,
                              'examId': submission.id,
                              'id': session.id,
                              'studentId':session.studentId
                            });
                          } else {
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.error(
                                message: 'Corrections Not Available',
                              ),
                            );
                          }
                        },
                        leading: CircleAvatar(
                          backgroundColor: blueShades[0],
                          child: Text(
                            submission.name.isNotEmpty ? submission.name[0] : "?",
                            style: setTextTheme(
                              fontWeight: FontWeight.w400,
                              color: whiteShades[0],
                            ),
                          ),
                        ),
                        title: Text(
                          submission.subject.name,
                          style: setTextTheme(),
                        ),
                        subtitle: Text(
                          'Score: ${session.totalScore.toStringAsFixed(2)}/${submission.totalMark} • ${submission.name}',
                          style: setTextTheme(fontWeight: FontWeight.w400),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('MMMM d, h:mm a').format(
                                DateTime.parse(session.lastSavedAt),
                              ),
                            ),
                            SizedBox(height: 4),
                            CircleAvatar(
                              backgroundColor: getScoreColor(
                                session.totalScore,
                                submission.totalMark,
                              ),
                              radius: 15.r,
                              child: Text(
                                session.totalScore.toStringAsFixed(2),
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

// class _ExamSubmissionsScreenState extends State<ExamSubmissionsScreen> {
//   @override
//   void initState() {
//     // print('classGroupId: ${widget.classGroupId}');
//     // print('examGroupId: ${widget.examGroupId}');
//     // print('title: ${widget.title}');
//     // print('spaceId: ${widget.spaceId}');
//     super.initState();
//     Provider.of<ExamHomeProvider>(context, listen: false).getMySubmission(
//       context: context,
//       spaceId: widget.spaceId,
//       classGroupId: widget.classGroupId,
//       examGroupId: widget.examGroupId,
//     );
//   }

//   void _navigateBack(BuildContext context) {
//     final role = localStore.get(
//       'role',
//       defaultValue: context.read<UserProvider>().role,
//     );

//     context.push(StudentLandingScreen.routeName, extra: {
//       'id': widget.spaceId,
//       'provider': context.read<UserProvider>(),
//       'currentIndex': role == 'teacher' ? 1 : 2,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final role = localStore.get('role',
//     //     defaultValue: '${context.read<UserProvider>().role}');
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
//           onPressed: () => _navigateBack(context),
//         ),

     
//         title: Text(
//           "Submissions",
//           // "${widget.title}",
//           style: setTextTheme(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: Consumer<ExamHomeProvider>(builder: (context, value, _) {
//         return Skeletonizer(
//           enabled: value.isLoading,
//           child: value.examSessionDataSub.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset('assets/app/paparazi_image_a.png'),
//                       SizedBox(height: 60.h),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 40.w),
//                         child: Text(
//                           "No Submmissions Found",
//                           style: setTextTheme(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       SizedBox(height: 40.h),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: value.examSessionDataSub.length,
//                   itemBuilder: (context, index) {
//                     final submission = value.examSessionDataSub[index];
//                    Color getScoreColor(double totalScore, int totalMark) {
//   if (totalMark == 0) return redShades[1];

//   double percentage = (totalScore / totalMark) * 100;

//   // Limit to 2 decimal places
//   percentage = double.parse(percentage.toStringAsFixed(2));

//   if (percentage >= 75) {
//     return greenShades[0];
//   } else if (percentage >= 50) {
//     return goldenShades[0];
//   } else {
//     return redShades[1];
//   }
// }


                
                

//                     return ListTile(
//                       onTap: (){
//                         log('on pressed studentId${submission.examSessions.first.studentId} examGroupId${widget.examGroupId} examId ${context.read<ExamHomeProvider>().examId} id${submission.examSessions.first.id} ');
//                        if(submission.showCorrections == true){
//                            context.push(StudentSubmissionView.routeName, extra: {
     
//           'spaceId': context.read<UserProvider>().spaceId,
//           'examGroupId': widget.examGroupId,
//           'examId': widget.examIds.first,
//           'id': submission.examSessions.first.id,
//           // 'studentId': submission.examSessions.first.studentId,
//         });
//                        }else{
//                            showTopSnackBar(
//           Overlay.of(context),
//           CustomSnackBar.error(
//             message: 'Corrections Not Available',
//           ),
//         );
//                        }
//                       },
//                       leading: CircleAvatar(
//                         backgroundColor: blueShades[0],
//                         // backgroundImage: AssetImage('assets/avatar.png'),
//                         child: Text(
//                           (submission.name.isNotEmpty)
//                               ? submission.name[0]
//                               : "?",
//                           style: setTextTheme(
//                               fontWeight: FontWeight.w400,
//                               color: whiteShades[0]),
//                         ),
//                       ),
//                       title: Text(
//                         submission.subject.name,
//                         style: setTextTheme(),
//                       ),
//                       subtitle: Text(
//                         'Score: ${submission.examSessions[index].totalScore.toStringAsFixed(2)}/${submission.totalMark} • ${submission.name}',
//                         style: setTextTheme(fontWeight: FontWeight.w400),
//                       ),
//                       trailing: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
                       
//                           Text(DateFormat('MMMM d, h:mm a').format(
//                               DateTime.parse(
//                                   submission.examSessions[index].lastSavedAt))),
//                           SizedBox(height: 4),
//                           CircleAvatar(
//                             // backgroundColor: color(
//                             //     submission.examSessions.first.totalScore.toInt()),
//                             backgroundColor: getScoreColor(
//                               double.parse(submission.examSessions[index].totalScore.toStringAsFixed(2)),
//                                 submission.totalMark),
//                             radius: 15.r,
//                             // backgroundColor: Color(int.parse(submission['color']!)),

//                             child: Text(
//                                 submission.examSessions[index].totalScore.toStringAsFixed(2),
//                                 style: TextStyle(
//                                     fontSize: 12, color: Colors.white)),
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//         );
//       }),
//     );
//   }
// }

class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Summary Data Here",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class ExamSubmission {
  final int serialNumber;
  final String subject;
  final double score;
  final double totalMark;
  final DateTime dateSubmitted;

  ExamSubmission({
    required this.serialNumber,
    required this.subject,
    required this.score,
    required this.totalMark,
    required this.dateSubmitted,
  });
}

//  Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columnSpacing: 12.0,
//                 headingRowColor: MaterialStateColor.resolveWith(
//                     (states) => Colors.grey.shade200),
//                 columns: const [
//                   DataColumn(
//                       label: Text("S/N",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text("Subject",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text("Score",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text("Total Mark",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text("Date Submitted",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//                 // rows: submissions.map((submission) {
//                 //   return DataRow(cells: [
//                 //     DataCell(Text(submission.serialNumber.toString())),
//                 //     DataCell(Text(submission.subject)),
//                 //     DataCell(Text(submission.score.toStringAsFixed(2))),
//                 //     DataCell(Text(submission.totalMark.toStringAsFixed(2))),
//                 //     DataCell(Text(DateFormat.yMMMMd()
//                 //         .add_jms()
//                 //         .format(submission.dateSubmitted))),
//                 //   ]);
//                 // }).toList(),
//                 rows: value.examSessionData.map((submission) {
//                   var sn = value.examSessionData.indexOf(submission) + 1;
//                   return DataRow(cells: [
//                     DataCell(Text(sn.toString())),
//                     DataCell(Text(submission.subject == null
//                         ? ""
//                         : submission.subject.name)),
//                     DataCell(Text(submission.examSessions
//                         .map((e) => e.totalScore.toStringAsFixed(2))
//                         .join())),
//                     DataCell(Text(submission.totalMark.toStringAsFixed(2))),
//                     DataCell(Text(DateFormat.yMMMMd().add_jms().format(
//                         DateTime.parse(submission.examSessions
//                             .map((e) => e.lastSavedAt)
//                             .first)))),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//           ),
