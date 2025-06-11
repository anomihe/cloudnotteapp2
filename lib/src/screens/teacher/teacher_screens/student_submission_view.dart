import 'dart:developer';

import 'package:cloudnottapp2/src/components/global_widgets/custom_pdf_viewer.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/models/student_model.dart';
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/answer_notifier_boxes.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/option_boxes.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/upload_text_box.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/homework_group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/models/exam_session_model.dart';
import '../../student/homework/homework_screens/homework_stats_screen.dart';


class StudentSubmissionView extends StatefulWidget {
  const StudentSubmissionView({
    super.key,
    required this.spaceId,
    required this.examGroupId,
    required this.examId,
    required this.id,
    required this.studentId,
  });

  final String spaceId;
  final String examGroupId;
  final String examId;
  final String id;
  final String studentId;

  static const String routeName = '/student_correction_screen';

  @override
  State<StudentSubmissionView> createState() => _StudentSubmissionViewState();
}

class _StudentSubmissionViewState extends State<StudentSubmissionView> {
  late FocusNode _textFieldFocusNode;
  late FocusNode _answerFocusNode;
  bool _isTextFieldFocused = false;
  bool _answerFocused = false;
  int? _currentIndex;
  TextEditingController? _scoreController;
  @override
  void initState() {
    super.initState();
    Provider.of<ExamHomeProvider>(context, listen: false).correctStudent(
        context: context,
        spaceId: widget.spaceId,
        examGroupId: widget.examGroupId,
        examid: widget.examId,
        id: widget.id,
        index: _currentIndex ?? 0,
        studentId: widget.studentId);
    _textFieldFocusNode = FocusNode();
    _answerFocusNode = FocusNode();

    _textFieldFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = _textFieldFocusNode.hasFocus;
      });
    });
    _scoreController = TextEditingController();
  }

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
              height: constraints.maxHeight * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.transparent,
              ),
              child: InteractiveViewer(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }



  final PageController _pageController = PageController();
  bool _isExpanded = true;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamHomeProvider>(builder: (context, value, _) {
      //  _scoreController?.text = value.score.toString();
        // double? currentScore = value.getScore(currentIndex);
// print('mt index $currentIndex $currentScore');
//     // Set the score in the controller only if it's different from the current text value
//     if (_scoreController?.text.isEmpty ?? true) {
//   _scoreController?.text = (currentScore ?? 0.0).toString();
// } else if (_scoreController?.text != (currentScore ?? 0.0).toString()) {
//   _scoreController?.text = (currentScore ?? 0.0).toString();
// }

      if (value.correct == null) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                context.pop();
                //  context.push(HomeworkGroupScreen.routeName, extra: {
                //       'classId': widget.classGroupId,
                //       'examId': widget.homeWorkGroup.examIds,
                //       "homeworkModel": widget.homeWorkGroup.category,
                //       "classGroupId": classId,
                //       // "classGroupId":
                //       //     widget.homeWorkGroup.classes.first.classGroupId,
                //       "examGroupId": widget.homeWorkGroup.id,
                //       "spaceId": widget.homeWorkGroup.session.spaceId,
                //     });
              },
              icon: Icon(Icons.arrow_back),
            ),
            backgroundColor: blueShades[11],
            actions: [
              GestureDetector(
                onTap: () {
                
                },
                child: Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0222), // ~8/360
                  width: MediaQuery.of(context).size.width * 0.1083, // ~39/360
                  height: MediaQuery.of(context).size.height * 0.04625,
                  decoration: BoxDecoration(
                    color: redShades[0],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/cil_graph_icon.svg',
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.0278),
            ],
            title: Text(
              // widget.homeworkModel.subject.length > 12
              //     ? '${widget.studentModel.name.substring(0, 12)}...'
              //     : widget.homeworkModel.subject,
              'No data',
              style: setTextTheme(fontSize: 20.sp),
            ),
          ),
        );
      }
      return Skeletonizer(
        enabled: value.isLoading,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(CupertinoIcons.back)),
            backgroundColor: blueShades[11],
            actions: [
              GestureDetector(
                onTap: () {
                      context.push(ExamSummaryScreen.routeName, extra: {
                     'spaceId': widget.spaceId,
            'studentId': widget.studentId,
            'examGroupId': widget.examGroupId,
            'examId': widget.examId,
            'id': widget.id
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0222),
                  width: MediaQuery.of(context).size.width * 0.1083,
                  height: MediaQuery.of(context).size.height * 0.04625,
                  decoration: BoxDecoration(
                    color: redShades[0],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/cil_graph_icon.svg',
                  ),
                ),
              ),
              //  SizedBox(width: 10.w),
              SizedBox(width: MediaQuery.of(context).size.width * 0.0278),
            ],
            title: Text(
              (value.correct?.examSession.exam.subject.name != null &&
                      (value.correct?.examSession.exam.subject.name.length ??
                              0) >
                          12)
                  ? '${value.correct?.examSession.exam.subject.name!.substring(0, 12)}...'
                  : value.correct?.examSession.exam.subject.name ?? '',
              style: setTextTheme(
                  fontSize: MediaQuery.of(context).size.width * 0.0556),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              _answerFocusNode.unfocus();
            },
            child: SafeArea(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    // key: PageStorageKey<String>('pageViewKey'),

                    // itemCount: value.correct?.corrections.length ?? 0,
                    itemCount:
                        value.correct?.examSession.exam.questions.length ?? 0,
                    // itemCount: widget.homeworkModel.questions.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final question =
                          value.correct?.examSession.exam.questions[index];
                      final session = value.correct?.examSession;
                      final answers = session?.answers ?? [];
                      final correction = value.correct?.corrections.firstWhere(
                        (c) => c.questionId == question?.id,
                        orElse: () => Correction(
                          lessonNoteId: '',
                          topic: '',
                          questionId: '',
                          question: '',
                          chosenAnswer: '',
                          correctAnswer: '',
                          isCorrect: false,
                          score: 0,
                        ),
                      );
                      // final selectedAnswerIndex = correction?.chosenAnswer ?? '';
                      // final correctAnswerIndex = correction?.correctAnswer ?? '';
                      final selectedAnswerIndex =
                          int.tryParse(correction?.chosenAnswer ?? '-1') ?? -1;
                      final correctAnswerIndex =
                          int.tryParse(correction?.correctAnswer ?? '-1') ?? -1;
                      final isAnswerCorrect =
                          selectedAnswerIndex == correctAnswerIndex;
                      final defaultAnswer = Answer(
                        answer: '',
                        score: 0.0,
                        isCorrect: false,
                        questionId: '',
                        resources: [],
                      );
                      final answer = answers.firstWhere(
                        (a) => a.questionId == question?.id,
                        orElse: () => defaultAnswer,
                      );
                     final double currentScore = value.getScore(question?.id ??'') ?? 0.0;


  // Set the controller text
  _scoreController?.text = currentScore.toString();
                      return Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.06375,
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.0225,
                        ),
                        child: Column(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              child: Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                thickness:
                                    MediaQuery.of(context).size.width * 0.01,
                                radius: Radius.circular(
                                    MediaQuery.of(context).size.width * 0.01),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${index + 1}',
                                          style: setTextTheme(
                                            color: whiteShades[1],
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.205,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02375),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                question?.question
                                                        .replaceAll('<p>', '')
                                                        .replaceAll('</p>', '')
                                                        .replaceAll('&nbsp', '')
                                                        .replaceAll('<br>', '')
                                                        .replaceAll(';', '') ??
                                                    '',
                                                style: setTextTheme(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0444,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                            if (session?.exam.questions[index]
                                                        .questionImage !=
                                                    null &&
                                                session!
                                                    .exam
                                                    .questions[index]
                                                    .questionImage!
                                                    .isNotEmpty) ...[
                                              GestureDetector(
                                                onTap: () => _showImageDialog(
                                                    context,
                                                    session!
                                                        .exam
                                                        .questions[index]
                                                        .questionImage!),
                                                child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      session!
                                                          .exam
                                                          .questions[index]
                                                          .questionImage!),
                                                  radius: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0556,
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Handle theory or objective questions
                            // question.examSession.exam.questions[index].type == QuestionType.theory
                            session?.exam.questions[index].type == 'theory'
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      UploadTeacherTextBox(
                                        node: _textFieldFocusNode,
                                        // fileName:
                                        //     widget.studentModel.uploadFiles[index],
                                        fileName: correction?.chosenAnswer
                                            .replaceAll('<p>', '')
                                            .replaceAll('</p>', '')
                                            .replaceAll('&nbsp', '')
                                            .replaceAll('<br>', ''),
                                        readOnly: true,
                                        examId: widget.examId,
                                        spaceId: widget.spaceId,
                                        examGroupId: widget.examGroupId,
                                        questionId:
                                            correction?.questionId ?? '',
                                        examSessionId: session?.id ?? '',
                                        myAnswer:
                                            correction?.chosenAnswer ?? '',
                                      ),
                                      SizedBox(height: 10.h),
                                      answer.resources != null &&
                                              answer.resources.isNotEmpty
                                          ? SizedBox(
                                              // height: 120.h,
                                              height: 80.h *
                                                  answer.resources.length,
                                              child: ListView.builder(
                                                // scrollDirection: Axis
                                                //     .horizontal, // Scrolls horizontally
                                                itemCount:
                                                    answer.resources.length,

                                                itemBuilder: (context, index) {
                                                  final resource =
                                                      answer.resources[index];
                                                  String fileName =
                                                      resource.split('/').last;
                                                  // _scoreController?.text =
                                                  //     answer.score.toString();
                                                  return GestureDetector(
                                                      onTap: () =>
                                                          showPdfDialog(context,
                                                              resource),
                                                      child: Container(
                                                        width: 150.r,
                                                        height: 50.h,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    8.r),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],

                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width:
                                                                  1), // Optional border
                                                          // image: DecorationImage(
                                                          //   image: AssetImage(resource),
                                                          //   fit: BoxFit.cover, // Adjust to fit the box properly
                                                          // ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '$fileName',
                                                            maxLines: 1,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: setTextTheme(
                                                              fontSize: 14.sp,
                                                              color:
                                                                  darkShades[0],
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ));
                                                },
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    
                                    ],
                                  )
                                : ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.440,
                                    ),
                                    child: ListView.separated(
                                      // itemCount: session?.answers.length ?? 0,
                                      itemCount: question?.options.length ?? 0,
                                      itemBuilder: (context, optionIndex) {
                                        return OptionBoxes(
                                          backgroundLetter: String.fromCharCode(
                                              65 + optionIndex), // A, B, C, D
                                          optionText: question
                                              ?.options[optionIndex].label
                                              .replaceAll('<p>', '')
                                              .replaceAll('</p>', ''),
                                          optionImage: question
                                              ?.options[optionIndex].image,
                                          isSelected: selectedAnswerIndex ==
                                              optionIndex,
                                          isCorrect: isAnswerCorrect,
                                          // isCorrect:
                                          //     correctAnswerIndex == optionIndex,
                                          highlightColor:
                                              selectedAnswerIndex == optionIndex
                                                  ? (selectedAnswerIndex ==
                                                          correctAnswerIndex
                                                      ? greenShades[0]
                                                      : redShades[0])
                                                  : (correctAnswerIndex ==
                                                          optionIndex
                                                      ? greenShades[0]
                                                      : whiteShades[0]),
                                          // highlightColor: selectedAnswerIndex ==
                                          //         optionIndex
                                          //     ? (selectedAnswerIndex ==
                                          //             correctAnswerIndex
                                          //         ? greenShades[0]
                                          //         : redShades[0])
                                          //     : (correctAnswerIndex == optionIndex
                                          //         ? greenShades[0]
                                          //         : whiteShades[0]),
                                        );
                                      },
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 5.h),
                                    ),
                                  ),
                               if(session?.exam.questions[index].type != 'theory')   if (selectedAnswerIndex == -1) // Or any other condition that means not answered
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      "Not Answered",
      style: TextStyle(
        fontSize: 16,
        color: Colors.red, // You can use a different color for the message
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
                  
                          ],
                        ),
                      );
                    },
                  ),
                  !_answerFocused
                      ? Positioned(
                          bottom: MediaQuery.of(context).size.width * 0.02,
                          left: 0,
                          right: 0,
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
                                  spacing: 8.r,
                                  runSpacing: 8.r,
                                  children: List.generate(
                                    value.correct?.corrections.length ?? 0,
                                    (index) => AnswerNotifierBoxes(
                                      questionNumber: index + 1,
                                      isCurrentQuestion: index == currentIndex,
                                      onSelectAnswerNotifier: () {
                                        _pageController.animateToPage(index,
                                            duration:
                                                Duration(microseconds: 10),
                                            curve: Curves.easeInOut);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }


// Assume all required imports are here: models, providers, widgets, themes, etc.

// class StudentSubmissionView extends StatefulWidget {
//   final String spaceId, examGroupId, examId, id, studentId;
// static const String routeName = '/student_correction_screen';
//   const StudentSubmissionView({
//     super.key,
//     required this.spaceId,
//     required this.examGroupId,
//     required this.examId,
//     required this.id,
//     required this.studentId,
//   });

//   @override
//   State<StudentSubmissionView> createState() => _StudentSubmissionViewState();
// }

// class _StudentSubmissionViewState extends State<StudentSubmissionView> {
//   late FocusNode _textFieldFocusNode;
//   late FocusNode _answerFocusNode;
//   bool _isTextFieldFocused = false;
//   bool _answerFocused = false;
//   int? _currentIndex;
//   late TextEditingController _scoreController;
//   final PageController _pageController = PageController();
//   bool _isExpanded = true;
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _textFieldFocusNode = FocusNode();
//     _answerFocusNode = FocusNode();
//     _scoreController = TextEditingController();

//     _textFieldFocusNode.addListener(() {
//       setState(() {
//         _isTextFieldFocused = _textFieldFocusNode.hasFocus;
//       });
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ExamHomeProvider>(context, listen: false).correctStudent(
//         context: context,
//         spaceId: widget.spaceId,
//         examGroupId: widget.examGroupId,
//         examid: widget.examId,
//         id: widget.id,
//         index: _currentIndex ?? 0,
//         studentId: widget.studentId,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _textFieldFocusNode.dispose();
//     _answerFocusNode.dispose();
//     _scoreController.dispose();
//     super.dispose();
//   }

//   void _showImageDialog(BuildContext context, String imagePath) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.r),
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Container(
//               width: constraints.maxWidth,
//               height: constraints.maxHeight * 0.6,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15.r),
//                 color: Colors.transparent,
//               ),
//               child: InteractiveViewer(
//                 child: Image.asset(
//                   imagePath,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ExamHomeProvider>(builder: (context, value, _) {
//       if (value.correct == null) {
//         return Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: Icon(Icons.arrow_back),
//             ),
//             backgroundColor: Colors.blue,
//             title: Text('No data'),
//           ),
//           body: Center(child: CircularProgressIndicator()),
//         );
//       }

//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(CupertinoIcons.back),
//           ),
//           backgroundColor: Colors.blue,
//           title: Text(value.correct!.examSession.exam.subject.name),
//         ),
//         body: PageView.builder(
//           controller: _pageController,
//           itemCount: value.correct!.examSession.exam.questions.length,
//           onPageChanged: (index) {
//             setState(() {
//               currentIndex = index;
//               _currentIndex = index;
//             });
//           },
//           itemBuilder: (context, index) {
//             final question = value.correct!.examSession.exam.questions[index];
//             final session = value.correct!.examSession;
//             final answers = session.answers;
//             final correction = value.correct!.corrections.firstWhere(
//               (c) => c.questionId == question.id,
//               orElse: () => Correction(
//                 lessonNoteId: '',
//                 topic: '',
//                 questionId: '',
//                 question: '',
//                 chosenAnswer: '',
//                 correctAnswer: '',
//                 isCorrect: false,
//                 score: 0,
//               ),
//             );
//             final answer = answers.firstWhere(
//               (a) => a.questionId == question.id,
//               orElse: () => Answer(
//                 answer: '',
//                 score: 0.0,
//                 isCorrect: false,
//                 questionId: '',
//                 resources: [],
//               ),
//             );
//             final currentScore = value.getScore(question.id) ?? 0.0;
//             _scoreController.text = currentScore.toString();

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 children: [
//                   Text(
//                     '${index + 1}. ${question.question.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 10),
//                   if (question.questionImage?.isNotEmpty ?? false)
//                     GestureDetector(
//                       onTap: () => _showImageDialog(context, question.questionImage!),
//                       child: Image.asset(question.questionImage!, height: 100),
//                     ),
//                   const SizedBox(height: 10),
//                   if (question.type == 'theory')
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Answer:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         Text(correction.chosenAnswer),
//                         const SizedBox(height: 10),
//                         ...answer.resources.map((res) {
//                           final fileName = res.split('/').last;
//                           return ListTile(
//                             title: Text(fileName),
//                             onTap: () => showPdfDialog(context, res),
//                           );
//                         }).toList(),
//                       ],
//                     )
//                   else
//                     Column(
//                       children: List.generate(question.options.length, (i) {
//                         final isSelected = int.tryParse(correction.chosenAnswer) == i;
//                         final isCorrect = int.tryParse(correction.correctAnswer) == i;
//                         return ListTile(
//                           leading: CircleAvatar(child: Text(String.fromCharCode(65 + i))),
//                           title: Text(question.options[i].label.replaceAll(RegExp(r'<[^>]*>'), '')),
//                           tileColor: isSelected
//                               ? isCorrect
//                                   ? Colors.green.withOpacity(0.3)
//                                   : Colors.red.withOpacity(0.3)
//                               : isCorrect
//                                   ? Colors.green.withOpacity(0.2)
//                                   : null,
//                         );
//                       }),
//                     ),
//                   if (question.type != 'theory' && correction.chosenAnswer.isEmpty)
//                     Text("Not Answered", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
//                 ],
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }


  void showPdfDialog(BuildContext context, String pdfUrl) {
    showDialog(
      context: context,
      builder: (context) => PrimaryScrollController.none(child: ReusablePdfViewer(
        sourceType: PdfSourceType.network,
        networkUrl: pdfUrl,
      ),),
      // builder: (context) => PrimaryScrollController.none(child: PdfViewerDialog(pdfUrl: pdfUrl)),
    );
  }
}
