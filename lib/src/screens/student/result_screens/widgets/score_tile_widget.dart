import 'dart:math';
import 'dart:developer' as dev;
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/enter_score_model.dart';
import '../../../../data/models/enter_score_widget_model.dart';

class ScoreTileWidget extends StatefulWidget {
  final List<ScoreModel> subjects;
  final String subjectName;
  double totalScore;
  List<AssessmentScore> myScore;
  final Function(List<AssessmentScore>) onScoresUpdated;

  ScoreTileWidget({
    required BuildContext context,
    required this.totalScore,
    required this.subjects,
    Key? key,
    required this.subjectName,
    required this.myScore,
    required this.onScoresUpdated,
  }) : super(key: key);

  @override
  State<ScoreTileWidget> createState() => _ScoreTileWidgetState();
}

class _ScoreTileWidgetState extends State<ScoreTileWidget> {
  late int myLength;
  late List<TextEditingController> _scoreControllers;
  late List<int> maxPercentages;
  double totalScore = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  @override
  void didUpdateWidget(ScoreTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subjects.length != widget.subjects.length) {
      _initializeFields();
    }
  }

  void _initializeFields() {
    final myTerm = context.read<ResultProvider>().basicAssessmentSecond;
    myLength = widget.subjects.length;

    // Initialize controllers with existing values
    _scoreControllers = List.generate(myLength, (index) {
      // Try to find existing score for this subAssessmentId
      final existingScoreIndex = widget.myScore.indexWhere((score) =>
          score.subAssessmentId == widget.subjects[index].subAssessmentId);

      // If found, use the existing score, otherwise use the default
      if (existingScoreIndex >= 0) {
        return TextEditingController(
            text: widget.myScore[existingScoreIndex].score.toString());
      } else {
        String initialScore = widget.subjects[index].score?.toString() ?? '';
        return TextEditingController(text: initialScore);
      }
    });

    maxPercentages =
        myTerm?.components.map((e) => e.percentage ?? 0).toList() ?? [];
    _updateTotalScore();
  }

  void _updateTotalScore() {
    if (_scoreControllers.isEmpty || widget.subjects.isEmpty) {
      print("Skipping _updateTotalScore because lists are empty.");
      return;
    }

    double sum = 0;
    List<AssessmentScore> updatedScores = [];

    for (int i = 0; i < widget.subjects.length; i++) {
      if (i >= _scoreControllers.length) break;

      String scoreText = _scoreControllers[i].text;
      double score =
          scoreText.isNotEmpty ? (double.tryParse(scoreText) ?? 0) : 0;

      sum += score;

      // Create a new AssessmentScore with the current values
      updatedScores.add(AssessmentScore(
        score: score.toInt(),
        subAssessmentId: widget.subjects[i].subAssessmentId ?? '',
      ));
    }

    setState(() {
      totalScore = sum;
      widget.totalScore = sum;
    });

    // Only update the parent with the scores for this subject
    widget.onScoresUpdated(updatedScores);
  }

  @override
  void dispose() {
    for (var controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myTerm = context.read<ResultProvider>().basicAssessmentSecond;

    final List<String> assessment = myTerm?.components.map((component) {
          String name = component.subAssessment?.name ?? '';
          int percentage = component.percentage ?? 0;
          return '$name ($percentage%)';
        }).toList() ??
        [];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.r),
            color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[19],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 15.r,
                vertical: 5.h,
              ),
              initiallyExpanded: true,
              title: Row(
                children: [
                  Container(
                    width: 45.r,
                    height: 45.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: blueShades[0],
                    ),
                    child: Center(
                      child: Text(
                        widget.subjectName.isNotEmpty
                            ? widget.subjectName.toUpperCase()[0]
                            : 'S',
                        style: setTextTheme(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subjectName,
                        style: setTextTheme(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Total Score: ',
                          style: setTextTheme(
                            fontSize: 13.sp,
                            color: whiteShades[4],
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: totalScore.toString(),
                              style: setTextTheme(
                                fontSize: 12.sp,
                                color: whiteShades[4],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemCount: widget.subjects.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Make sure index is within bounds
                    final titleIndex = index < assessment.length ? index : 0;
                    final maxPercentageIndex =
                        index < maxPercentages.length ? index : 0;

                    return ScoreItem(
                      title: assessment.isNotEmpty
                          ? assessment[titleIndex]
                          : 'Assessment ${index + 1}',
                      controller: _scoreControllers[index],
                      onScoreChanged: _updateTotalScore,
                      maxPercentage: maxPercentageIndex < maxPercentages.length
                          ? maxPercentages[maxPercentageIndex].toDouble()
                          : 100.0,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ScoreItem extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback onScoreChanged;
  final double maxPercentage;

  const ScoreItem({
    super.key,
    required this.title,
    required this.controller,
    required this.onScoreChanged,
    required this.maxPercentage,
  });

  @override
  State<ScoreItem> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.r,
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          Text(
            widget.title,
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          SizedBox(
            width: 60,
            height: 30,
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,3}\.?(\d{1})?$')),
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: ThemeProvider().isDarkMode
                    ? blueShades[15]
                    : whiteShades[0],
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[3]
                        : whiteShades[3],
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[0]
                        : blueShades[1],
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[3]
                        : whiteShades[3],
                    width: 0.5,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[3]
                        : whiteShades[3],
                    width: 0.5,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final score = double.tryParse(value) ?? 0;
                  if (score > widget.maxPercentage) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.info(
                        message: "Score cannot exceed ${widget.maxPercentage}%",
                      ),
                    );
                    widget.controller.text =
                        widget.maxPercentage.toStringAsFixed(0);
                  }
                }
                widget.onScoreChanged();
              },
            ),
          )
        ],
      ),
    );
  }
}
