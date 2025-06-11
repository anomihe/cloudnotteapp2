/*
  This file defines the `HomeworkQuestionScreen`, a stateful widget that serves as the main 
  interface for students to answer homework questions. It provides functionalities such as 
  time tracking, answering questions (both theory and objective), navigation through questions, 
  and submission of answers. Features include:
  - Timer display and timeout handling.
  - Support for both multiple-choice and theory-based questions.
  - An interactive page view and expansion panel for question navigation.
  - Dynamic handling of selected answers and uploaded files.
*/

import 'dart:async';
import 'dart:developer';
import 'package:cloudnottapp2/src/components/global_widgets/clean.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_submission_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_submitted_screen.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/answer_notifier_boxes.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/option_boxes.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/upload_text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../data/models/exam_session_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/providers/exam_home_provider.dart';

class HomeworkQuestionScreen extends StatefulWidget {
  const HomeworkQuestionScreen(
      {super.key,
      required this.id,
      required this.spaceId,
      required this.examGroupId,
      required this.examId,
      required this.subject,
      required this.pin});

  final String id;
  final String spaceId;
  final String examGroupId;
  final String examId;
  final String pin;
  final String subject;
  static const String routeName = '/homework_question_screen';

  // final HomeworkModel homeworkModel;

  @override
  State<HomeworkQuestionScreen> createState() => _HomeworkQuestionScreenState();
}

Future<bool> _showExitConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit Homework?'),
          content: const Text(
              'Are you sure you want to leave this screen? Your progress will not be saved.'),
          actions: [
            TextButton(
              onPressed: () => context.pop(false), // Stay on screen
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => context.pop(true), // Exit screen
              child: const Text('Exit'),
            ),
          ],
        ),
      ) ??
      false; // Default to false if dialog is dismissed
}

class _HomeworkQuestionScreenState extends State<HomeworkQuestionScreen> {
  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight * 0.6, // Adjustable height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.transparent,
              ),
              child: InteractiveViewer(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain, // Ensure the entire image is visible
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int? myTime;
  final PageController _pageController = PageController();
  // late Duration remainingTime;
  // Timer? timer;
  String title = '';
  late FocusNode _textFieldFocusNode;
  bool _isTextFieldFocused = false;
  @override
  void initState() {
    super.initState();
    log('my id ${context.read<UserProvider>().memberId} ${widget.examId} ${widget.examGroupId} ${widget.subject}');
    _textFieldFocusNode = FocusNode();
    _textFieldFocusNode.addListener(() {
      print("TextField focus changed: ${_textFieldFocusNode.hasFocus}");
      setState(() {
        _isTextFieldFocused = _textFieldFocusNode.hasFocus;
      });
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   KeyboardVisibilityController().onChange.listen((bool visible) {
    //     if (!visible) {
    //       FocusScope.of(context).unfocus(); // Unfocus when keyboard closes
    //     }
    //   });
    // });
    Provider.of<ExamHomeProvider>(context, listen: false)
        .getUserExamSession(
      context: context,
      spaceId: widget.spaceId,
      studentId: context.read<UserProvider>().memberId,
      examGroupId: widget.examGroupId,
      examId: widget.examId,
      pin: widget.pin,
    )
        .then((_) {
      Provider.of<ExamHomeProvider>(context, listen: false).startTimer(
          context: context,
          spaceId: widget.spaceId,
          examId: widget.examId,
          examGroupId: widget.examGroupId,
          questionId: questionId,
          answer: myAnswer);
      // final examProvider =
      //     Provider.of<ExamHomeProvider>(context, listen: false);
      // examProvider.startTimer();
      // examProvider.updateTimeLeft();

      // // Call submit if time is up
      // if (examProvider.timeLeft <= 0) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     showTimeUpDialog(widget.id, examProvider.examSession,
      //         examProvider.examSession?.id ?? '');
      //   });
      // }
    });
    // Provider.of<ExamHomeProvider>(context, listen: false).startTimer(
    //     context: context,
    //     spaceId: widget.spaceId,
    //     examId: widget.examId,
    //     examGroupId: widget.examGroupId,
    //     questionId: questionId,
    //     answer: myAnswer);
    Provider.of<ExamHomeProvider>(context, listen: false).updateTimeLeft();
    Provider.of<ExamHomeProvider>(context, listen: false).expectedEndTime;
    Provider.of<ExamHomeProvider>(context, listen: false).timeStarted;
    Provider.of<ExamHomeProvider>(context, listen: false).lastSavedAt;
    Provider.of<ExamHomeProvider>(context, listen: false).remainingTime;
    Provider.of<ExamHomeProvider>(context, listen: false).timeLeft;
    // remainingTime = Duration(minutes: 30); // Set the time limit
    // submit();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   submit();
    // });
    // widget.homeworkModel.questions.asMap().forEach((index, _) {
    //   uploadFiles[index] = null; // Initialize all to null
    // });
  }

  String questionId = '';
  String myAnswer = '';

  void submit() {
    if (Provider.of<ExamHomeProvider>(context, listen: false).timeLeft <= 0) {
      showTimeUpDialog(widget.id, context.read<ExamHomeProvider>().examSession,
          context.read<ExamHomeProvider>().examSession?.id ?? '');
    }
  }

  void showTimeUpDialog(String id, ExamSession? session, String examSessionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Time Up!'),
        content: const Text(
            'You have run out of time. Please submit your homework.'),
        actions: [
          TextButton(
            onPressed: () {
              log('my final answer $myAnswer');
              // Provider.of<ExamHomeProvider>(context, listen: false)
              //     .updateExamSession(
              //         context: context,
              //         examSessionInput: ExamSessionInput(
              //           examId: widget.examId,
              //           spaceId: widget.spaceId,
              //           id: examSessionId,
              //           examGroupId: widget.examGroupId,
              //           studentId: context.read<UserProvider>().memberId,
              //           status: "completed",

              //           // ),
              //         ))
              //     .then((_) {
              //   Provider.of<ExamHomeProvider>(context, listen: false)
              //       .stopTimer();
              //   log('my datasssssa id $id session $session examsessionId $examSessionId questionId $questionId myAnswer $myAnswer');
              //   context.push(
              //     // HomeworkSubmissionScreen.routeName,
              //     HomeworkSubmittedScreen.routeName,
              //     // '/homework_submission_screen',
              //     extra: {
              //       // 'homeworkModel': widget.homeworkModel,
              //       // 'selectedAnswers': selectedAnswers,
              //       // 'chosenAnswer': chosenAnswer,
              //       // 'uploadFiles': uploadFiles,
              //       "session": session
              //     },
              //   );
              // });
              context.push(
                // HomeworkSubmissionScreen.routeName,
                HomeworkSubmittedScreen.routeName,
                // '/homework_submission_screen',
                extra: {
                  // 'homeworkModel': widget.homeworkModel,
                  // 'selectedAnswers': selectedAnswers,
                  // 'chosenAnswer': chosenAnswer,
                  // 'uploadFiles': uploadFiles,
                  "session": session
                },
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // timer?.cancel();
    super.dispose();
    _pageController.dispose();
  }

  // void stopTimer() {
  //   timer?.cancel();
  // }

  void navigateToSubmissionScreen(
      String id, ExamSession session, String examSessionId) {
    //  populateChosenAnswers();
    log('my datasssssa id $id session $session examsessionId $examSessionId questionId $questionId myAnswer $myAnswer');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Submit'),
            content: const Text(
                'Are you sure you want to submit? You cannot go back once you submit.'),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<ExamHomeProvider>(context, listen: false)
                      .updateExamSession(
                          context: context,
                          examSessionInput: ExamSessionInput(
                            examId: widget.examId,
                            spaceId: widget.spaceId,
                            id: examSessionId,
                            examGroupId: widget.examGroupId,
                            studentId: context.read<UserProvider>().memberId,
                            status: "completed",
                            //questionId: answer!.id,
                            // answer: AnswerInput(
                            //   questionId: questionId,
                            //   // answer: myAnswer,
                            //   resources: [],

                            //   // score: 0.0,
                            //   // isCorrect: false,
                            //   //score: answer?.options[optionIndex].score,
                            // ),
                          ))
                      .then((_) {
                    Provider.of<ExamHomeProvider>(context, listen: false)
                        .stopTimer();
                    log('my datasssssa id $id session $session examsessionId $examSessionId questionId $questionId myAnswer $myAnswer');
                    context.push(
                      // HomeworkSubmissionScreen.routeName,
                      HomeworkSubmittedScreen.routeName,
                      // '/homework_submission_screen',
                      extra: {
                        // 'homeworkModel': widget.homeworkModel,
                        // 'selectedAnswers': selectedAnswers,
                        // 'chosenAnswer': chosenAnswer,
                        // 'uploadFiles': uploadFiles,
                        "session": session
                      },
                    );
                  });
                },
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: redShades[1])),
              ),
            ],
          );
        });
    // context.push(
    //   '/homework_submission_screen',
    //   extra: {
    //     // 'homeworkModel': widget.homeworkModel,
    //     'selectedAnswers': selectedAnswers,
    //     'chosenAnswer': chosenAnswer,
    //     'uploadFiles': uploadFiles,
    //     'timer': timer, // Pass the timer
    //   },
    // );
  }

  //:TODO catch this error   [GraphQLError(message: Student already has an exam Session already exists, locations: [ErrorLocation(line: 3, column: 3)], path: [createExamSession], extensions: {code: INTERNAL_SERVER_ERROR})]

// for implementing the user's answer
  Map<int, int?> selectedAnswers =
      {}; // Map to track selected answers per question
Map<String, String> myAnswers = {};
  Map<int, String?> uploadFiles =
      {}; // Store both file names and text inputs per question
Map<String, FocusNode> _focusNodes = {};
  List<String> chosenAnswer = [];
FocusNode _getFocusNodeForQuestion(String questionId) {
  if (!_focusNodes.containsKey(questionId)) {
    _focusNodes[questionId] = FocusNode();
    _focusNodes[questionId]!.addListener(() {
      setState(() {
        _isTextFieldFocused = _focusNodes[questionId]!.hasFocus;
      });
    });
  }
  return _focusNodes[questionId]!;
}
  void chooseAnswer(int questionIndex, int optionIndex) {
    setState(() {
      selectedAnswers[questionIndex] = optionIndex;
    });
  }

  // void populateChosenAnswers() {
  //   chosenAnswer.clear(); // Clear previous values
  //   for (int i = 0; i < widget.homeworkModel.questions.length; i++) {
  //     final selectedOptionIndex = selectedAnswers[i];
  //     final uploadedFileOrText = uploadFiles[i];

  //     if (selectedOptionIndex != null && selectedOptionIndex != -1) {
  //       // Add selected option answer
  //       chosenAnswer.add(widget
  //           .homeworkModel.questions[i].shuffledAnswers[selectedOptionIndex]);
  //     } else if (uploadedFileOrText != null && uploadedFileOrText.isNotEmpty) {
  //       // Add uploaded file or text if provided
  //       chosenAnswer.add("Uploaded: $uploadedFileOrText");
  //     } else {
  //       // If neither selected answer nor upload is provided
  //       chosenAnswer.add("No answer provided");
  //     }
  //   }
  // }

  bool _isExpanded = true; // Track the expansion state for ExpansionPanelList
  int currentIndex = 0; // for the pageview.builder //remove

  @override
  Widget build(BuildContext context) {
    print("Is TextField Focused? $_isTextFieldFocused");
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog or prevent back navigation
        bool shouldLeave = await _showExitConfirmationDialog(context);
        return shouldLeave; // Return true to allow exit, false to block
      },
      child: Consumer<ExamHomeProvider>(builder: (context, value, child) {
        print("Time Left: ${value.timeLeft}");

        int minutes = value.timeLeft ~/ 60;
        int seconds = value.timeLeft % 60;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: blueShades[11],
            actions: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: setTextTheme(fontSize: 24.sp),
              ),
              // Text(
              //   '${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
              //   style: setTextTheme(fontSize: 24.sp),
              // ),
              SizedBox(width: 5.w),
              GestureDetector(
                onTap: () {
                  if (value.examSession != null) {
                    navigateToSubmissionScreen(widget.id, value.examSession!,
                        value.examSession?.id ?? '');
                  }
                },
                child: SvgPicture.asset('assets/icons/power_icon.svg'),
              ),
              SizedBox(width: 10.w),
            ],
            title: Text(
              widget.subject.length > 12
                  ? '${widget.subject.substring(0, 12)}...'
                  : widget.subject,
              style: setTextTheme(fontSize: 20.sp),
            ),
            // title: Text(
            //   widget.homeworkModel.subject.length > 12
            //       ? '${widget.homeworkModel.subject.substring(0, 12)}...'
            //       : widget.homeworkModel.subject,
            //   style: setTextTheme(fontSize: 20.sp),
            // ),
          ),
          body: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Skeletonizer(
              enabled: value.isLoading,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      // PageView.builder in the main content
                       value.examSession?.exam.questions == null || value.examSession!.exam.questions.isEmpty
                ? Center(
                    child: Text(
                      'No questions available',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ):
                      PageView.builder(
                        controller: _pageController,
                        itemCount: value.examSession?.exam.questions.length,
                        // itemCount: widget.homeworkModel.questions.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          // final question = widget.homeworkModel.questions[index];
                          final question =
                              value.examSession?.exam.questions[index];
                                
                          questionId = question?.id ?? '';
                          log('the idss $questionId $question');
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 51.h,
                                  left: 18.w,
                                  right: 18.w,
                                  bottom: 18.h),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${index + 1}',
                                          style: setTextTheme(
                                            color: whiteShades[1],
                                            fontSize: 74.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 19),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                // question?.question
                                                //         .replaceAll(
                                                //             RegExp(r'<[^>]*>'), '')
                                                //         .replaceAll('&nbsp;', '').replaceAll('<>', replace)
                                                //         .trim() ??
                                                //     '',
                                                cleanHtml(question?.question),
                                                // question.question,
                                                style: setTextTheme(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                            if (question?.questionImage !=
                                                    null &&
                                                question!.questionImage!
                                                    .isNotEmpty) ...[
                                              GestureDetector(
                                                onTap: () {
                                                  if (question.questionImage !=
                                                      null) {
                                                    _showImageDialog(
                                                        context,
                                                        question
                                                            .questionImage!);
                                                  }
                                                },
                                                child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      question.questionImage!),
                                                  radius: 20.r,
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  question?.type != 'objective'
                                      ? Builder(
                                          builder: (BuildContext innerContext) {
                                          final questionIdInner =
                                              question?.id ??
                                                  ''; 
                                                  final fileName = uploadFiles[index];// Capture here!
                                          log('the  innerones $questionId ${myAnswer} ');
                                          return UploadTextBox(
                                            // node: _textFieldFocusNode,
                                            node: _getFocusNodeForQuestion(questionIdInner),
                                            fileName: uploadFiles[
                                                index], // passes current file name
                                            examId: widget.examId,
                                            spaceId: widget.spaceId,
                                            examGroupId: widget.examGroupId,
                                            //questionId: questionId,
                                            questionId: questionIdInner,
                                            examSessionId:
                                                value.examSession?.id ?? '',
                                               
                                                myAnswer: myAnswers[questionIdInner] ?? '',
                                            // myAnswer: myAnswer,
                                            onAddFileOrText: (String? newFileName, String? newText) {
                              setState(() {
                                if (newFileName != null) {
                                  uploadFiles[index] = newFileName;
                                }
                                if (newText != null) {
                                  myAnswers[questionIdInner] = newText; // Update the text answer
                                }
                                selectedAnswers[index] = -1; // Mark as answered
                            
                                     Provider.of<ExamHomeProvider>(context, listen: false).updateExamSession(
                                    context: context,
                                    examSessionInput: ExamSessionInput(
                                      examId: widget.examId,
                                      spaceId: widget.spaceId,
                                      id: value.examSession?.id ?? '',
                                      examGroupId: widget.examGroupId,
                                      studentId: context.read<UserProvider>().memberId,
                                      status: "inProgress",
                                      answer: AnswerInput(
                                        questionId: questionIdInner,
                                        answer: newText ?? '',
                                        resources: newFileName != null ? [newFileName] : [],
                                      ),
                                    ));
                              });
                            },
                                            // onAddFileOrText: (newFileNme) {
                                            //   setState(() {
                                            //     uploadFiles[index] = newFileNme;
                                            //     selectedAnswers[index] =
                                            //         -1; //marks as answered
                                            //   });
                                            // },
                                          );
                                        })
                                      : ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: 300.h,
                                          ),
                                          child: ListView.separated(
                                            itemCount: value
                                                    .examSession
                                                    ?.exam
                                                    .questions[index]
                                                    .options
                                                    .length ??
                                                0,
                                            // itemCount: question.a.length,
                                            itemBuilder:
                                                (context, optionIndex) {
                                              final answer = value.examSession
                                                  ?.exam.questions[index];
                                  
                                              // myAnswer = answer
                                              //         ?.options[optionIndex].label
                                              //         .replaceAll('<p>', '')
                                              //         .replaceAll('</p>', '') ??
                                              //     '';
                                  
                                              return OptionBoxes(
                                                backgroundLetter:
                                                    String.fromCharCode(
                                                        65 + optionIndex),
                                                        optionText: HtmlTagsCleaner
                                                            .clean(answer
                                                                ?.options[
                                                                    optionIndex]
                                                                .label ?? ''),
                                                // optionText: answer
                                                //     ?.options[optionIndex].label
                                                //     .replaceAll('<p>', '')
                                                //     .replaceAll('</p>', ''),
                                                optionImage: answer
                                                    ?.options[optionIndex]
                                                    .image,
                                                // optionText:
                                                //     question.shuffledAnswers[optionIndex],
                                                // optionImage:
                                                //     question.optionImages?[optionIndex],
                                                isSelected:
                                                    selectedAnswers[index] ==
                                                        optionIndex,
                                                onSelectOption: (_) {
                                                  chooseAnswer(
                                                      index, optionIndex);
                                                  myAnswer =
                                                      optionIndex.toString();
                                                  log('my index $index $optionIndex');
                                                  value.updateExamSession(
                                                      context: context,
                                                      examSessionInput:
                                                          ExamSessionInput(
                                                        examId: widget.examId,
                                                        id: value
                                                            .examSession?.id,
                                                        examGroupId:
                                                            widget.examGroupId,
                                                        spaceId: widget.spaceId,
                                                        studentId: context
                                                            .read<
                                                                UserProvider>()
                                                            .memberId,
                                                        status: "inProgress",
                                                        //questionId: answer!.id,
                                                        answer: AnswerInput(
                                                          questionId:
                                                              question?.id,
                                  
                                                          answer: optionIndex
                                                              .toString(),
                                                          // answer: answer
                                                          //     ?.options[optionIndex]
                                                          //     .label
                                                          //     ?.replaceAll(
                                                          //         RegExp(r'<[^>]*>'),
                                                          //         ''),
                                                          resources: [],
                                                          // status: "inProgress",
                                                          score: 0.0,
                                                          isCorrect: false,
                                                          //score: answer?.options[optionIndex].score,
                                                        ),
                                                      ));
                                                },
                                              );
                                            },
                                            separatorBuilder: (_, __) =>
                                                SizedBox(height: 3.h),
                                          ),
                                        ),
                                  // SizedBox(height: 5.h),
                                  // if (index == widget.homeworkModel.questions.length - 1)
                                  //   ElevatedButton(
                                  //     onPressed: () {
                                  //       navigateToSubmissionScreen();
                                  //     },
                                  //     style: ElevatedButton.styleFrom(
                                  //       backgroundColor: redShades[0],
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: 15.w, vertical: 5.h),
                                  //     ),
                                  //     child: Text(
                                  //       'Finish',
                                  //       style: setTextTheme(
                                  //         fontSize: 15.sp,
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // ExpansionPanelList positioned at the bottom
                      if (!_isTextFieldFocused ||
                          value.examSession?.exam.questions[currentIndex]
                                  .type ==
                              'objective')
                        Positioned(
                          bottom: 15,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ExpansionPanelList(
                              elevation: 0,
                              expandedHeaderPadding: EdgeInsets.zero,
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              children: [
                                ExpansionPanel(
                                  isExpanded: _isExpanded,
                                  headerBuilder: (_, __) =>
                                      const SizedBox.shrink(),
                                  body: Wrap(
                                    spacing: 3.r,
                                    runSpacing: 2.r,
                                    children: List.generate(
                                      value.examSession?.exam.questions
                                              .length ??
                                          0,
                                      // widget.homeworkModel.questions.length,
                                      (index) => AnswerNotifierBoxes(
                                        questionNumber: index + 1,

                                        isCurrentQuestion: index ==
                                            currentIndex, // Highlights the current index
                                        onSelectAnswerNotifier: () {
                                          _pageController.animateToPage(index,
                                              duration:
                                                  Duration(milliseconds: 10),
                                              curve: Curves.easeInOut);
                                        },
                                        isAnswered: selectedAnswers
                                                .containsKey(index) &&
                                            selectedAnswers[index] !=
                                                null, // Highlights the questions that have been answered
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _handleGraphQLError(ResponseError? error) {
    if (error == null || (error.message?.isEmpty ?? true)) {
      return Center(child: Text('An unexpected error occurred'));
    }

    // Extract GraphQL error message
    final errorMessage = error.message;

    if (errorMessage != null &&
        errorMessage
            .contains("Student already has an exam Session already exist")) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                color: Colors.red, size: 50), // Error icon
            SizedBox(height: 10),
            Text(
              "Exam session not found. Please check your details and try again.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your retry logic here
                context.pop();
              },
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    // Default error message
    return Center(child: Text(errorMessage ?? 'An unexpected error occurred'));
  }

  String cleanHtml(String? input) {
    if (input == null) return '';

    String cleaned = input
        // Remove HTML tags (includes <hr>, <hr/>, <hr class="...">)
        .replaceAll(RegExp(r'<[^>]*>|</[^>]*>|<[^>]*'), '')
        // Remove HTML comments
        .replaceAll(RegExp(r'<!--[\s\S]*?-->'), '')
        // Remove HTML entities
        .replaceAll(RegExp(r'&[#a-zA-Z0-9]+;'), '')
        // Remove leftover angle brackets
        .replaceAll(RegExp(r'[<>]'), '')
        .replaceAll('&nbsp;', '')
        // Normalize whitespace (including non-breaking spaces)
        .replaceAll(RegExp(r'[\u00A0\s]+'), ' ')
        .trim();

    return cleaned;
  }
}
