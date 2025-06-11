import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/awaiting_content.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/correct_circle.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/in_correct_circle.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/left_arrow.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/option_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FreeAiQuiz extends StatefulWidget {
  final String sessionId;
  final List<Map<String, dynamic>> quizQuestions;
  final bool isLoadingQuiz;
  final VoidCallback onReload;

  const FreeAiQuiz({
    super.key,
    required this.sessionId,
    required this.quizQuestions,
    required this.isLoadingQuiz,
    required this.onReload,
  });

  @override
  State<FreeAiQuiz> createState() => _FreeAiQuizState();
}

class _FreeAiQuizState extends State<FreeAiQuiz> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool showFeedback = false;
  bool showHint = false;

  void _selectOption(int index) {
    if (selectedOptionIndex == null) {
      setState(() {
        selectedOptionIndex = index;
        showFeedback = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedOptionIndex = null;
      showFeedback = false;
      showHint = false;
    });
  }

  void _autoSelectCorrect() {
    if (selectedOptionIndex == null && widget.quizQuestions.isNotEmpty) {
      final correctIndex = widget.quizQuestions[currentQuestionIndex]['options']
          .indexWhere((o) => o['isCorrect'] == true);
      if (correctIndex != -1) {
        _selectOption(correctIndex);
      }
    }
  }

  void _autoSelectIncorrect() {
    if (selectedOptionIndex == null && widget.quizQuestions.isNotEmpty) {
      final incorrectIndex = widget.quizQuestions[currentQuestionIndex]
              ['options']
          .indexWhere((o) => o['isCorrect'] == false);
      if (incorrectIndex != -1) {
        _selectOption(incorrectIndex);
      }
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        showFeedback = false;
        showHint = false;
      });
    }
  }

  Color _getOptionColor(int index, bool isHovered) {
    if (selectedOptionIndex != null) {
      if (index == selectedOptionIndex) {
        return widget.quizQuestions[currentQuestionIndex]['options'][index]
                ['isCorrect']
            ? Colors.green
            : Colors.red;
      } else if (widget.quizQuestions[currentQuestionIndex]['options'][index]
          ['isCorrect']) {
        return Colors.green;
      }
      return Colors.transparent;
    }
    return isHovered ? Colors.blue.shade100 : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Take Quiz",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 24.sp),
                onPressed: widget.onReload,
                tooltip: 'Reload Quiz',
              ),
            ],
          ),
          SizedBox(height: 10.h),
          widget.isLoadingQuiz || widget.quizQuestions.isEmpty
              ? const AwaitingContent(contentType: 'questions')
              : _buildQuizContent(),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    final currentQuestion = widget.quizQuestions[currentQuestionIndex];
    // Validate question structure
    if (!currentQuestion.containsKey('content') ||
        !currentQuestion.containsKey('options') ||
        currentQuestion['options'] is! List) {
      return const Center(child: Text('Invalid quiz data.'));
    }
    final totalQuestions = widget.quizQuestions.length;
    final content =
        currentQuestion['content'] as String? ?? 'No question available';
    final options = currentQuestion['options'] as List<dynamic>? ?? [];
    final explanation =
        currentQuestion['explanation'] as String? ?? 'No explanation provided';
    final hint = currentQuestion['hint'] as String? ?? 'No hint available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${currentQuestionIndex + 1}",
                style: Theme.of(context).textTheme.bodySmall),
            Container(
              height: 8.h,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                children: [
                  Expanded(
                    flex: currentQuestionIndex + 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.r),
                          bottomLeft: Radius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: totalQuestions - (currentQuestionIndex + 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.r),
                          bottomRight: Radius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text("$totalQuestions",
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          content,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 10.h),
        ...List.generate(options.length, (index) {
          final optionContent = options[index]['content'] as String? ?? '';
          return StatefulBuilder(
            builder: (context, setState) {
              bool isHovered = false;
              return MouseRegion(
                onEnter: (_) => setState(() => isHovered = true),
                onExit: (_) => setState(() => isHovered = false),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: OptionBoxes(
                    backgroundLetter: String.fromCharCode(65 + index),
                    optionText: optionContent,
                    isSelected: selectedOptionIndex == index,
                    isCorrect: options[index]['isCorrect'] ?? false,
                    onSelectOption: selectedOptionIndex == null
                        ? (_) => _selectOption(index)
                        : null,
                    highlightColor: _getOptionColor(index, isHovered),
                  ),
                ),
              );
            },
          );
        }),
        if (showFeedback && selectedOptionIndex != null) ...[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: options[selectedOptionIndex!]['isCorrect']
                  ? freeAiColors[1]
                  : freeAiColors[3],
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    options[selectedOptionIndex!]['isCorrect']
                        ? CorrectCircle()
                        : InCorrectCircle(),
                    SizedBox(width: 5.w),
                    Text(
                      options[selectedOptionIndex!]['isCorrect']
                          ? 'Correct Answer'
                          : 'Incorrect Answer',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: options[selectedOptionIndex!]['isCorrect']
                                ? freeAiColors[2]
                                : freeAiColors[4],
                          ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    explanation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: options[selectedOptionIndex!]['isCorrect']
                              ? freeAiColors[2]
                              : freeAiColors[4],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _resetQuiz,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(Icons.refresh, size: 15.sp),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap:
                      selectedOptionIndex == null ? _autoSelectCorrect : null,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(5.r),
                      color: selectedOptionIndex != null
                          ? Colors.grey.withOpacity(0.5)
                          : null,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 15.sp,
                      color: selectedOptionIndex != null
                          ? Colors.grey
                          : Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap:
                      selectedOptionIndex == null ? _autoSelectIncorrect : null,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(5.r),
                      color: selectedOptionIndex != null
                          ? Colors.grey.withOpacity(0.5)
                          : null,
                    ),
                    child: Text(
                      "Don't Know",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: selectedOptionIndex != null
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
                if (selectedOptionIndex != null &&
                    currentQuestionIndex < totalQuestions - 1) ...[
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _nextQuestion,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "Next",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: whiteShades[0]),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Divider(
            color: Theme.of(context).dividerColor, thickness: 1, height: 20.h),
        GestureDetector(
          onTap: () => setState(() => showHint = true),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Give me a hint",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                SizedBox(width: 5.w),
                LeftArrow(
                  width: 15,
                  height: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
        if (showHint) ...[
          SizedBox(height: 10.h),
          Text(
            "Hint: $hint",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ],
      ],
    );
  }
}
