import 'dart:developer';

import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    hide SubjectScore;
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/widgets/score_tile_widget.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/enter_score_model.dart';
import '../../../data/providers/theme_provider.dart';

class StudentScoreEntryScreen extends StatefulWidget {
  final List<SubjectReportModel> scoreWidgetModel;
  final String spaceId;
  final String classId;
  final String assessmentId;
  static const String routeName = "/student_score_entry_screen";

  const StudentScoreEntryScreen({
    Key? key,
    required this.scoreWidgetModel,
    required this.spaceId,
    required this.classId,
    required this.assessmentId,
  }) : super(key: key);

  @override
  State<StudentScoreEntryScreen> createState() =>
      _StudentScoreEntryScreenState();
}

class _StudentScoreEntryScreenState extends State<StudentScoreEntryScreen> {
  // Map to store assessment scores by subject ID
  final Map<String?, List<AssessmentScore>> subjectScoresMap = {};

  @override
  void initState() {
    super.initState();
    // Initialize the map with empty lists for each subject
    for (var model in widget.scoreWidgetModel) {
      subjectScoresMap[model.subject?.id] = [];
    }
  }

  // Update scores for a specific subject
  void updateScoresForSubject(String? subjectId, List<AssessmentScore> scores) {
    if (subjectId != null) {
      // Clear previous scores for this subject
      subjectScoresMap[subjectId]?.clear();
      // Add the new scores
      subjectScoresMap[subjectId]?.addAll(scores);
    }
  }

  // Prepare the final scores for submission
  List<SubjectScore> prepareScoresForSubmission() {
    return widget.scoreWidgetModel.map((report) {
      String? subjectId = report.subject?.id;
      return SubjectScore(
        subjectId: subjectId,
        scores: [
          UserScore(
            userId: report.userId,
            assessmentScores: subjectScoresMap[subjectId] ?? [],
          )
        ],
      );
    }).toList();
  }

  void _navigateBack(BuildContext context) {
    final role = localStore.get(
      'role',
      defaultValue: context.read<UserProvider>().role,
    );

    context.push(StudentLandingScreen.routeName, extra: {
      'id': widget.spaceId,
      'provider': context.read<UserProvider>(),
      'currentIndex': role == 'teacher' ? 3 : 4,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // context.push(StudentLandingScreen.routeName, extra: {
            //   'id': widget.spaceId,
            //   'provider': context.read<UserProvider>(),
            //   "currentIndex": 4,
            // });
            _navigateBack(context);
          },
          child: IconButton(
            onPressed: () {
              _navigateBack(context);
              // context.push(StudentLandingScreen.routeName, extra: {
              //   'id': widget.spaceId,
              //   'provider': context.read<UserProvider>(),
              //   "currentIndex": 4,
              // });
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ThemeProvider().isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        title: Text(
          '${widget.scoreWidgetModel.first.firstName ?? ''} ${widget.scoreWidgetModel.first.lastName ?? ''}',
          style: setTextTheme(fontSize: 24.sp),
        ),
        actions: [
          Consumer<ResultProvider>(
            builder: (context, resultProvider, child) {
              bool isLoading = resultProvider.isLoadingStateTwo ?? false;
              return Buttons(
                width: 110.w,
                height: 35.h,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                text: isLoading ? 'Saving...' : 'Save Score',
                isLoading: isLoading,
                onTap: isLoading
                    ? () {}
                    : () {
                        ManySubjectReportInput input = ManySubjectReportInput(
                          classId: widget.classId,
                          assessmentId: widget.assessmentId,
                          scores: prepareScoresForSubmission(),
                        );
                        resultProvider.enterStudentsScore(
                            context: context,
                            spaceId: widget.spaceId,
                            input: input);
                      },
              );
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemCount: widget.scoreWidgetModel.length,
          itemBuilder: (context, index) {
            final model = widget.scoreWidgetModel[index];
            final subjectId = model.subject?.id;

            return ScoreTileWidget(
              context: context,
              subjectName: model.subject?.name ?? '',
              subjects: model.scores ?? [],
              totalScore: model.total ?? 0.0,
              myScore: subjectScoresMap[subjectId] ?? [],
              onScoresUpdated: (updatedScores) {
                updateScoresForSubject(subjectId, updatedScores);
              },
            );
          },
        ),
      ),
    );
  }
}
