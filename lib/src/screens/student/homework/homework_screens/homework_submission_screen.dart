// import 'dart:async';

// import 'package:cloudnottapp2/src/config/config.dart';
// import 'package:cloudnottapp2/src/data/models/homework_model.dart';
// import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_submitted_screen.dart';
// import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/homework_container.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// class HomeworkSubmissionScreen extends StatelessWidget {
//   const HomeworkSubmissionScreen({
//     super.key,
//     required this.homeworkModel,
//     required this.selectedAnswers,
//     required this.chosenAnswer,
//     required this.uploadFiles,
//     required this.timer,
//   });

//   final HomeworkModel homeworkModel;
//   final Map<int, int?> selectedAnswers;
//   final List<String> chosenAnswer;
//   final Map<int, String?> uploadFiles;
//   final Timer? timer;

//   static const String routeName = '/homework_submission_screen';

//   // void navigateToSubmittedScreen(BuildContext context) {
//   //   timer?.cancel(); // Stop the timer
//   //   context.push(
//   //     HomeworkSubmittedScreen.routeName,
//   //     extra: {
//   //       'homeworkModel': homeworkModel,
//   //       'selectedAnswers': selectedAnswers,
//   //       'chosenAnswer': chosenAnswer,
//   //       'uploadFiles': uploadFiles,
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.only(left: 11.r, right: 11.r),
//           child: HomeworkContainer(
//             richText: TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'Are you sure you want to submit ',
//                   style: setTextTheme(
//                       fontSize: 16.sp, fontWeight: FontWeight.w400),
//                 ),
//                 TextSpan(
//                   text: '?. ',
//                   style: setTextTheme(
//                       fontSize: 16.sp, fontWeight: FontWeight.w700),
//                 ),
//                 TextSpan(
//                   text: 'Once you submit, you cant go back again.',
//                   style: setTextTheme(
//                       fontSize: 16.sp, fontWeight: FontWeight.w400),
//                 ),
//               ],
//             ),
//             primaryButtonText: 'I want to Submit',
//             secondaryButtonText: "Cancel",

//             // used for navigating to the homework submitted screen
//             onPrimaryButtonTap: () {
//               // final stopTimerCallback = extra['stopTimerCallback'];
//               // if (stopTimerCallback != null) {
//               //   stopTimerCallback();
//               // }
//               // navigateToSubmittedScreen(context);
//             },

//             onSecondaryButtonTap: () {
//               context.pop();
//             },
//             primaryButtonColor: redShades[0],
//             secondaryButtonBorderColor: redShades[0],
//           ),
//         ),
//       ),
//     );
//   }
// }
