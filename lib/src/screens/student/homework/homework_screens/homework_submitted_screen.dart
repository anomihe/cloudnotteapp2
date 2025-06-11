import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/exam_session_model.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/custom_button.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeworkSubmittedScreen extends StatelessWidget {
  const HomeworkSubmittedScreen({
    super.key,
    // required this.selectedAnswers,
    // required this.homeworkModel,
    // required this.chosenAnswer,
    // required this.uploadFiles,
    required this.session,
  });
  final ExamSession session;
  // final HomeworkModel homeworkModel;
  // final Map<int, int?> selectedAnswers;
  // final List<String> chosenAnswer;
  // final Map<int, String?> uploadFiles;

  static const String routeName = '/homework_submitted_screen';

  @override
  Widget build(BuildContext context) {
     double totalScore = 0.0;
  
  // Sum up the scores from each answer
  for (var answer in session.answers) {
    if (answer.score != null) {
      totalScore += answer.score!;
    }
  }
  
  // Get the total possible score from the exam
  final totalPossibleScore = session.exam.totalMark;
    // final summaryItem =
    //     generateSummaryInfo(selectedAnswers, chosenAnswer, homeworkModel);
    // final numberOfTotalQuestions = homeworkModel.questions.length;
    // final numberOfCorrectAnswers = summaryItem.where(
    //   (data) {
    //     return data['chosen_answer'] == data['correct_answer'];
    //   },
    // ).length;
    return WillPopScope(
      onWillPop: () async {
        // Prevent navigating back by returning false
        return false;
      },
      child: Scaffold(
        body: session.exam.showScoreOnSubmission
            ? Center(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/app/paparazi_image_a.png'),
                      SizedBox(
                        height: 60.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "Assessment submitted successfully. You scored ${totalScore.toStringAsFixed(2)}/${session.exam.totalMark}",
                          // "Homework submitted successfully. You scored $numberOfCorrectAnswers/$numberOfTotalQuestions",
                          style: setTextTheme(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(StudentLandingScreen.routeName, extra: {
                            'id': context.read<UserProvider>().spaceId,
                            'provider': context.read<UserProvider>(),
                            'currentIndex': 2,
                          }
                              // '/homework_correction_screen',
                              // extra: {
                              //   'homeworkModel': homeworkModel,
                              //   'selectedAnswers': selectedAnswers,
                              //   'chosenAnswer': chosenAnswer,
                              //   'uploadFiles': uploadFiles,
                              // },
                              );
                        },
                        child: CustomButton(
                          text: 'Okay',
                          textStyle: setTextTheme(
                              fontSize: 15.48.sp,
                              fontWeight: FontWeight.w700,
                              color: whiteShades[0]),
                          buttonColor: redShades[0],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/app/paparazi_image_a.png'),
                      SizedBox(
                        height: 60.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "Homework submitted successfully.",
                          // "Homework submitted successfully. You scored $numberOfCorrectAnswers/$numberOfTotalQuestions",
                          style: setTextTheme(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(StudentLandingScreen.routeName, extra: {
                            'id': context.read<UserProvider>().spaceId,
                            'provider': context.read<UserProvider>(),
                            'currentIndex': 2,
                          }
                              // '/homework_correction_screen',
                              // extra: {
                              //   'homeworkModel': homeworkModel,
                              //   'selectedAnswers': selectedAnswers,
                              //   'chosenAnswer': chosenAnswer,
                              //   'uploadFiles': uploadFiles,
                              // },
                              );
                        },
                        child: CustomButton(
                          text: 'Okay',
                          textStyle: setTextTheme(
                              fontSize: 15.48.sp,
                              fontWeight: FontWeight.w700,
                              color: whiteShades[0]),
                          buttonColor: redShades[0],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
