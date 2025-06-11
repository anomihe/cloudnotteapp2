import 'package:cloudnottapp2/src/components/global_widgets/custom_pdf_viewer.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/models/student_model.dart';
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_screens/homework_stats_screen.dart';
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

class TeacherSubmissionView extends StatefulWidget {
  const TeacherSubmissionView({
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

  static const String routeName = '/homework_correction_screen';

  @override
  State<TeacherSubmissionView> createState() => _TeacherSubmissionViewState();
}

// class _TeacherSubmissionViewState extends State<TeacherSubmissionView> {
//   late FocusNode _textFieldFocusNode;
//   late FocusNode _answerFocusNode;
//   bool _isTextFieldFocused = false;
//   bool _answerFocused = false;
//   int? _currentIndex;
//   TextEditingController? _scoreController;
 
//   late PageController _pageController ;
//    int currentIndex = 0;
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: currentIndex);
//     Provider.of<ExamHomeProvider>(context, listen: false).correctStudent(
//         context: context,
//         spaceId: widget.spaceId,
//         examGroupId: widget.examGroupId,
//         examid: widget.examId,
//         id: widget.id,
//         index: _currentIndex ?? 0,
//         studentId: widget.studentId);
//     _textFieldFocusNode = FocusNode();
//     _answerFocusNode = FocusNode();
//  _answerFocusNode.addListener(() {
//       if (!_answerFocusNode.hasFocus && _scoreController?.text.isNotEmpty == true) {
//         final provider = Provider.of<ExamHomeProvider>(context, listen: false);
//         final questionId = provider.correct?.examSession.exam.questions[_currentIndex ?? 0].id ?? '';
        
//         // Submit score when focus is lost
//         _submitScore(
//           index: _currentIndex ?? 0,
//           value: _scoreController!.text,
//           questionId: questionId
//         );
//         print('Submitting score: ${_scoreController!.text}');
//       }
//     });
//     _textFieldFocusNode.addListener(() {
//       setState(() {
//         _isTextFieldFocused = _textFieldFocusNode.hasFocus;
//       });
//     });
//     _scoreController = TextEditingController();
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

//   Future<void> _submitScore(
//       {required String value,
//       required String questionId,
//       required int index}) async {
//     int? score = int.tryParse(value);
//     if (score != null) {
//       Provider.of<ExamHomeProvider>(context, listen: false).markStudent(
//           context: context,
//           spaceId: widget.spaceId,
//           examGroupId: widget.examGroupId,
//           examId: widget.examId,
//           id: widget.id,
//           studentId: widget.studentId,
//           questionId: questionId,
//           index: index,
//           score: score);
//     } else {
//       print("Invalid Score");
//     }
//   }

//   bool _isExpanded = true;
  

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ExamHomeProvider>(builder: (context, value, _) {
    

//       if (value.correct == null) {
//         return Scaffold(
//           resizeToAvoidBottomInset: true,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             leading: IconButton(
//               onPressed: () {
//                 context.pop();
//                 //  context.push(HomeworkGroupScreen.routeName, extra: {
//                 //       'classId': widget.classGroupId,
//                 //       'examId': widget.homeWorkGroup.examIds,
//                 //       "homeworkModel": widget.homeWorkGroup.category,
//                 //       "classGroupId": classId,
//                 //       // "classGroupId":
//                 //       //     widget.homeWorkGroup.classes.first.classGroupId,
//                 //       "examGroupId": widget.homeWorkGroup.id,
//                 //       "spaceId": widget.homeWorkGroup.session.spaceId,
//                 //     });
//               },
//               icon: Icon(Icons.arrow_back),
//             ),
//             backgroundColor: blueShades[11],
//             actions: [
//               GestureDetector(
//                 onTap: () {},
//                 child: Container(
//                   padding: EdgeInsets.all(
//                       MediaQuery.of(context).size.width * 0.0222), // ~8/360
//                   width: MediaQuery.of(context).size.width * 0.1083, // ~39/360
//                   height: MediaQuery.of(context).size.height * 0.04625,
//                   decoration: BoxDecoration(
//                     color: redShades[0],
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: SvgPicture.asset(
//                     'assets/icons/cil_graph_icon.svg',
//                   ),
//                 ),
//               ),
//               SizedBox(width: MediaQuery.of(context).size.width * 0.0278),
//             ],
//             title: Text(
//               // widget.homeworkModel.subject.length > 12
//               //     ? '${widget.studentModel.name.substring(0, 12)}...'
//               //     : widget.homeworkModel.subject,
//               'No data',
//               style: setTextTheme(fontSize: 20.sp),
//             ),
//           ),
//         );
//       }
//       return Skeletonizer(
//         enabled: value.isLoading,
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             leading: IconButton(
//                 onPressed: () {
//                   context.pop();
//                 },
//                 icon: Icon(CupertinoIcons.back)),
//             backgroundColor: blueShades[11],
//             actions: [
//               GestureDetector(
//                 onTap: () {},
//                 child: Container(
//                   padding: EdgeInsets.all(
//                       MediaQuery.of(context).size.width * 0.0222),
//                   width: MediaQuery.of(context).size.width * 0.1083,
//                   height: MediaQuery.of(context).size.height * 0.04625,
//                   decoration: BoxDecoration(
//                     color: redShades[0],
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: SvgPicture.asset(
//                     'assets/icons/cil_graph_icon.svg',
//                   ),
//                 ),
//               ),
//               //  SizedBox(width: 10.w),
//               SizedBox(width: MediaQuery.of(context).size.width * 0.0278),
//             ],
//             title: Text(
//               (value.correct?.examSession.exam.subject.name != null &&
//                       (value.correct?.examSession.exam.subject.name.length ??
//                               0) >
//                           12)
//                   ? '${value.correct?.examSession.exam.subject.name!.substring(0, 12)}...'
//                   : value.correct?.examSession.exam.subject.name ?? '',
//               style: setTextTheme(
//                   fontSize: MediaQuery.of(context).size.width * 0.0556),
//             ),
//           ),
//           body: GestureDetector(
//             onTap: () {
//               _answerFocusNode.unfocus();
//             },
//             child: SafeArea(
//               child: Stack(
//                 children: [
//                   PageView.builder(
//                     controller: _pageController,
//                     // key: PageStorageKey<String>('pageViewKey'),

//                     // itemCount: value.correct?.corrections.length ?? 0,
//                     itemCount:
//                         value.correct?.examSession.exam.questions.length ?? 0,
//                     // itemCount: widget.homeworkModel.questions.length,
//                     onPageChanged: (index) {
//                       setState(() {
//                         currentIndex = index;
//                         _currentIndex = index;
//                       });
//                     },
//                     itemBuilder: (context, index) {
//                       final question =
//                           value.correct?.examSession.exam.questions[index];
//                       final session = value.correct?.examSession;
//                       final answers = session?.answers ?? [];
//                       final correction = value.correct?.corrections.firstWhere(
//                         (c) => c.questionId == question?.id,
//                         orElse: () => Correction(
//                           lessonNoteId: '',
//                           topic: '',
//                           questionId: '',
//                           question: '',
//                           chosenAnswer: '',
//                           correctAnswer: '',
//                           isCorrect: false,
//                           score: 0,
//                         ),
//                       );
//                       // final selectedAnswerIndex = correction?.chosenAnswer ?? '';
//                       // final correctAnswerIndex = correction?.correctAnswer ?? '';
//                       final selectedAnswerIndex =
//                           int.tryParse(correction?.chosenAnswer ?? '-1') ?? -1;
//                       final correctAnswerIndex =
//                           int.tryParse(correction?.correctAnswer ?? '-1') ?? -1;
//                       final isAnswerCorrect =
//                           selectedAnswerIndex == correctAnswerIndex;
//                       final defaultAnswer = Answer(
//                         answer: '',
//                         score: 0.0,
//                         isCorrect: false,
//                         questionId: '',
//                         resources: [],
//                       );
//                       final answer = answers.firstWhere(
//                         (a) => a.questionId == question?.id,
//                         orElse: () => defaultAnswer,
//                       );
//                      final double currentScore = value.getScore(question?.id ??'') ?? 0.0;
//   print('Page index: $index, score: $currentScore  realscores ${correction?.score} ${correction?.chosenAnswer}');

//   // Set the controller text
//   _scoreController?.text = currentScore.toString();
//                       return Padding(
//                         padding: EdgeInsets.only(
//                           top: MediaQuery.of(context).size.height * 0.06375,
//                           left: MediaQuery.of(context).size.width * 0.05,
//                           right: MediaQuery.of(context).size.width * 0.05,
//                           bottom: MediaQuery.of(context).size.height * 0.0225,
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               constraints: BoxConstraints(
//                                 maxHeight:
//                                     MediaQuery.of(context).size.height * 0.2,
//                               ),
//                               child: Scrollbar(
//                                 thumbVisibility: true,
//                                 trackVisibility: true,
//                                 thickness:
//                                     MediaQuery.of(context).size.width * 0.01,
//                                 radius: Radius.circular(
//                                     MediaQuery.of(context).size.width * 0.01),
//                                 child: SingleChildScrollView(
//                                   physics: BouncingScrollPhysics(),
//                                   child: Stack(
//                                     children: [
//                                       Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Text(
//                                           '${index + 1}',
//                                           style: setTextTheme(
//                                             color: whiteShades[1],
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.205,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 0.02375),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 question?.question
//                                                         .replaceAll('<p>', '')
//                                                         .replaceAll('</p>', '')
//                                                         .replaceAll('&nbsp', '')
//                                                         .replaceAll('<br>', '')
//                                                         .replaceAll(';', '') ??
//                                                     '',
//                                                 style: setTextTheme(
//                                                   fontSize:
//                                                       MediaQuery.of(context)
//                                                               .size
//                                                               .width *
//                                                           0.0444,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                                 softWrap: true,
//                                               ),
//                                             ),
//                                             if (session?.exam.questions[index]
//                                                         .questionImage !=
//                                                     null &&
//                                                 session!
//                                                     .exam
//                                                     .questions[index]
//                                                     .questionImage!
//                                                     .isNotEmpty) ...[
//                                               GestureDetector(
//                                                 onTap: () => _showImageDialog(
//                                                     context,
//                                                     session!
//                                                         .exam
//                                                         .questions[index]
//                                                         .questionImage!),
//                                                 child: CircleAvatar(
//                                                   backgroundImage: AssetImage(
//                                                       session!
//                                                           .exam
//                                                           .questions[index]
//                                                           .questionImage!),
//                                                   radius: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.0556,
//                                                 ),
//                                               ),
//                                             ]
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             // Handle theory or objective questions
//                             // question.examSession.exam.questions[index].type == QuestionType.theory
//                             session?.exam.questions[index].type == 'theory'
//                                 ? Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       UploadTeacherTextBox(
//                                         node: _textFieldFocusNode,
//                                         // fileName:
//                                         //     widget.studentModel.uploadFiles[index],
//                                         fileName: correction?.chosenAnswer
//                                             .replaceAll('<p>', '')
//                                             .replaceAll('</p>', '')
//                                             .replaceAll('&nbsp', '')
//                                             .replaceAll('<br>', ''),
//                                         readOnly: true,
//                                         examId: widget.examId,
//                                         spaceId: widget.spaceId,
//                                         examGroupId: widget.examGroupId,
//                                         questionId:
//                                             correction?.questionId ?? '',
//                                         examSessionId: session?.id ?? '',
//                                         myAnswer:
//                                             correction?.chosenAnswer ?? '',
//                                       ),
//                                       SizedBox(height: 10.h),
//                                       answer.resources != null &&
//                                               answer.resources.isNotEmpty
//                                           ? SizedBox(
//                                               // height: 120.h,
//                                               height: 80.h *
//                                                   answer.resources.length,
//                                               child: ListView.builder(
//                                                 // scrollDirection: Axis
//                                                 //     .horizontal, // Scrolls horizontally
//                                                 itemCount:
//                                                     answer.resources.length,

//                                                 itemBuilder: (context, index) {
//                                                   final resource =
//                                                       answer.resources[index];
//                                                   String fileName =
//                                                       resource.split('/').last;
//                                                   // _scoreController?.text =
//                                                   //     answer.score.toString();
//                                                   return GestureDetector(
//                                                       onTap: () =>
//                                                           showPdfDialog(context,
//                                                               resource),
//                                                       child: Container(
//                                                         width: 150.r,
//                                                         height: 50.h,
//                                                         margin: EdgeInsets
//                                                             .symmetric(
//                                                                 horizontal:
//                                                                     8.r),
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           color:
//                                                               Colors.grey[200],

//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       10.r),
//                                                           border: Border.all(
//                                                               color:
//                                                                   Colors.grey,
//                                                               width:
//                                                                   1), // Optional border
//                                                           // image: DecorationImage(
//                                                           //   image: AssetImage(resource),
//                                                           //   fit: BoxFit.cover, // Adjust to fit the box properly
//                                                           // ),
//                                                         ),
//                                                         child: Center(
//                                                           child: Text(
//                                                             '$fileName',
//                                                             maxLines: 1,
//                                                             softWrap: true,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: setTextTheme(
//                                                               fontSize: 14.sp,
//                                                               color:
//                                                                   darkShades[0],
//                                                             ),
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                           ),
//                                                         ),
//                                                       ));
//                                                 },
//                                               ),
//                                             )
//                                           : SizedBox.shrink(),
//                                       Align(
//                                         alignment: Alignment.centerRight,
//                                         child: Container(
//                                           width: 130.r,
//                                           height: 40.h,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10.r),
//                                             color: Colors.grey[200],
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               SizedBox(
//                                                 width: 80.r,
//                                                 height: 30.h,
//                                                 child: TextFormField(
//                                                     focusNode: _answerFocusNode,
//                                                     controller:
//                                                         _scoreController,
//                                                     // onChanged: (v){
//                                                     //   _scoreController?.text = v;
//                                                     // },
//                                                     decoration: InputDecoration(
//                                                     //hintText: '0.0',
//                                                       // border: InputBorder.none,
//                                                       hintStyle: setTextTheme(
//                                                         fontSize: 14.sp,
//                                                         color: darkShades[0],
//                                                       ),
//                                                       suffix: Text(
//                                                         " / ${session?.exam.questions[index].mark}",
//                                                         style: setTextTheme(
//                                                           fontSize: 18.sp,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: darkShades[0],
//                                                         ),
//                                                       ),
//                                                       contentPadding:
//                                                           EdgeInsets.symmetric(
//                                                               vertical: 2.r),
//                                                       filled:
//                                                           true, // Enables background color
//                                                       fillColor: Colors.grey[
//                                                           200], // Background color
//                                                       border:
//                                                           OutlineInputBorder(
//                                                         borderRadius: BorderRadius
//                                                             .circular(10
//                                                                 .r), // Rounded corners
//                                                         borderSide: BorderSide
//                                                             .none, // Removes border line
//                                                       ),
//                                                     ),
//                                                     keyboardType:
//                                                         TextInputType.number,
//                                                     textAlign: TextAlign.center,
//                                                     textInputAction:
//                                                         TextInputAction.done,
//                                                         // In your TextFormField widget, add this:
// onEditingComplete: () {
//   if (_scoreController?.text.isNotEmpty ?? false) {
//     _submitScore(
//       index: index,
//       value: _scoreController!.text,
//       questionId: question?.id ?? ''
//     );
//   }
// },
//                                                     onFieldSubmitted: (value) {
//                                                       if (value.isNotEmpty) {
//                                                         _submitScore(
//                                                                 index: index,
//                                                                 value: value,
//                                                                 questionId:
//                                                                     question?.id ??
//                                                                         '')
//                                                             .then((_) {
//                                                           _scoreController
//                                                               ?.clear();
//                                                           _answerFocusNode
//                                                               .unfocus();
//                                                         });
//                                                       }
//                                                     }),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : ConstrainedBox(
//                                     constraints: BoxConstraints(
//                                       maxHeight:
//                                           MediaQuery.of(context).size.height *
//                                               0.440,
//                                     ),
//                                     child: ListView.separated(
//                                       // itemCount: session?.answers.length ?? 0,
//                                       itemCount: question?.options.length ?? 0,
//                                       itemBuilder: (context, optionIndex) {
//                                         return OptionBoxes(
//                                           backgroundLetter: String.fromCharCode(
//                                               65 + optionIndex), // A, B, C, D
//                                           optionText: question
//                                               ?.options[optionIndex].label
//                                               .replaceAll('<p>', '')
//                                               .replaceAll('</p>', ''),
//                                           optionImage: question
//                                               ?.options[optionIndex].image,
//                                           isSelected: selectedAnswerIndex ==
//                                               optionIndex,
//                                           isCorrect: isAnswerCorrect,
//                                           // isCorrect:
//                                           //     correctAnswerIndex == optionIndex,
//                                           highlightColor:
//                                               selectedAnswerIndex == optionIndex
//                                                   ? (selectedAnswerIndex ==
//                                                           correctAnswerIndex
//                                                       ? greenShades[0]
//                                                       : redShades[0])
//                                                   : (correctAnswerIndex ==
//                                                           optionIndex
//                                                       ? greenShades[0]
//                                                       : whiteShades[0]),
//                                           // highlightColor: selectedAnswerIndex ==
//                                           //         optionIndex
//                                           //     ? (selectedAnswerIndex ==
//                                           //             correctAnswerIndex
//                                           //         ? greenShades[0]
//                                           //         : redShades[0])
//                                           //     : (correctAnswerIndex == optionIndex
//                                           //         ? greenShades[0]
//                                           //         : whiteShades[0]),
//                                         );
//                                       },
//                                       separatorBuilder: (_, __) =>
//                                           SizedBox(height: 5.h),
//                                     ),
//                                   ),
//                               //  if(session?.exam.questions[index].type != 'theory')   
//                                if (selectedAnswerIndex == -1&&(correction?.chosenAnswer.isEmpty??false))  // Or any other condition that means not answered
//   Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Text(
//       "Not Answered",
//       style: TextStyle(
//         fontSize: 16,
//         color: Colors.red, // You can use a different color for the message
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ),
//                             // Replace the current SizedBox with this improved UI
//                             // Padding(
//                             //   padding: EdgeInsets.only(top: 10.h),
//                             //   child: ExpansionTile(
//                             //     title: Text(
//                             //       'Feedback',
//                             //       style: setTextTheme(
//                             //         fontSize: 16.sp,
//                             //         fontWeight: FontWeight.w600,
//                             //       ),
//                             //     ),
//                             //     children: [
//                             //       Padding(
//                             //         padding: EdgeInsets.all(8.w),
//                             //         child: Text(
//                             //           'widget.homeworkModel.questions[index] .explanation',
//                             //           style: setTextTheme(
//                             //             fontSize: 14.sp,
//                             //           ),
//                             //         ),
//                             //       ),
//                             //     ],
//                             //   ),
//                             // )
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   !_answerFocused
//                       ? Positioned(
//                           bottom: MediaQuery.of(context).size.width * 0.02,
//                           left: 0,
//                           right: 0,
//                           child: ExpansionPanelList(
//                             elevation: 0,
//                             expandedHeaderPadding: EdgeInsets.zero,
//                             expansionCallback: (int index, bool isExpanded) {
//                               setState(() {
//                                 _isExpanded = !_isExpanded;
//                               });
//                             },
//                             children: [
//                               ExpansionPanel(
//                                 isExpanded: _isExpanded,
//                                 headerBuilder: (_, __) =>
//                                     const SizedBox.shrink(),
//                                 body: Wrap(
//                                   spacing: 8.r,
//                                   runSpacing: 8.r,
//                                   children: List.generate(
//                                     value.correct?.corrections.length ?? 0,
//                                     (index) => AnswerNotifierBoxes(
//                                       questionNumber: index + 1,
//                                       isCurrentQuestion: index == currentIndex,
//                                       onSelectAnswerNotifier: () {
//                                         _pageController.animateToPage(index,
//                                             duration:
//                                                 Duration(microseconds: 10),
//                                             curve: Curves.easeInOut);
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : SizedBox.shrink(),
//                   SizedBox(
//                     height: 20.h,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
class _TeacherSubmissionViewState extends State<TeacherSubmissionView> {
  late FocusNode _textFieldFocusNode;
  late FocusNode _answerFocusNode;
  bool _isTextFieldFocused = false;
  bool _answerFocused = false;
  int _currentIndex = 0;
  TextEditingController? _scoreController;
  late PageController _pageController;
  bool _isExpanded = true;
  bool _isSubmittingScore = false;
  int? _lastKnownPageIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadStudentData();
    _textFieldFocusNode = FocusNode();
    _answerFocusNode = FocusNode();
    _scoreController = TextEditingController();

    _answerFocusNode.addListener(() {
      setState(() {
        _answerFocused = _answerFocusNode.hasFocus;
      });

      if (!_answerFocusNode.hasFocus && _scoreController?.text.isNotEmpty == true) {
        final provider = Provider.of<ExamHomeProvider>(context, listen: false);
        final questionId = provider.correct?.examSession.exam.questions[_currentIndex].id ?? '';
        _submitScore(
          index: _currentIndex,
          value: _scoreController!.text,
          questionId: questionId,
        );
        print('Submitting score: ${_scoreController!.text} for index: $_currentIndex');
      }
    });

    _textFieldFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = _textFieldFocusNode.hasFocus;
      });
    });
  }

  Future<void> _loadStudentData() async {
    try {
      await Provider.of<ExamHomeProvider>(context, listen: false).correctStudent(
        context: context,
        spaceId: widget.spaceId,
        examGroupId: widget.examGroupId,
        examid: widget.examId,
        id: widget.id,
        index: _lastKnownPageIndex ?? _currentIndex,
        studentId: widget.studentId,
      );

      // Restore the saved page index after data load
      if (_lastKnownPageIndex != null && mounted && _pageController.hasClients) {
        setState(() {
          _currentIndex = _lastKnownPageIndex!;
        });
        _pageController.jumpToPage(_lastKnownPageIndex!);
        print('Restored to saved index: $_lastKnownPageIndex after data reload');
      }
    } catch (e) {
      print('Error loading student data: $e');
    }
  }

  Future<void> _submitScore({
    required String value,
    required String questionId,
    required int index,
  }) async {
    if (_isSubmittingScore) return;

    int? score = int.tryParse(value);
    if (score == null) {
      print("Invalid Score");
      return;
    }

    setState(() {
      _isSubmittingScore = true;
      _lastKnownPageIndex = index; // Save the index before submission
    });
    print('Saving current index before submission: $_lastKnownPageIndex');

    try {
      await Provider.of<ExamHomeProvider>(context, listen: false).markStudent(
        context: context,
        spaceId: widget.spaceId,
        examGroupId: widget.examGroupId,
        examId: widget.examId,
        id: widget.id,
        studentId: widget.studentId,
        questionId: questionId,
        index: index,
        score: score,
      );

      // Reload data after marking
      await _loadStudentData();

      // Restore the page index immediately after submission
      if (mounted && _pageController.hasClients) {
        setState(() {
          _currentIndex = _lastKnownPageIndex!;
        });
        _pageController.jumpToPage(_lastKnownPageIndex!);
        print('Restored page to index: $_lastKnownPageIndex after score submission');
      }
    } catch (e) {
      print('Error submitting score: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingScore = false;
        });
      }
    }
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
  @override
  Widget build(BuildContext context) {
    return Consumer<ExamHomeProvider>(builder: (context, value, _) {
      if (value.correct == null) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back),
            ),
            backgroundColor: blueShades[11],
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0222),
                  width: MediaQuery.of(context).size.width * 0.1083,
                  height: MediaQuery.of(context).size.height * 0.04625,
                  decoration: BoxDecoration(
                    color: redShades[0],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset('assets/icons/cil_graph_icon.svg'),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.0278),
            ],
            title: Text(
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
              onPressed: () => context.pop(),
              icon: Icon(CupertinoIcons.back),
            ),
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
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0222),
                  width: MediaQuery.of(context).size.width * 0.1083,
                  height: MediaQuery.of(context).size.height * 0.04625,
                  decoration: BoxDecoration(
                    color: redShades[0],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset('assets/icons/cil_graph_icon.svg'),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.0278),
            ],
            title: Text(
              (value.correct?.examSession.exam.subject.name != null &&
                      (value.correct?.examSession.exam.subject.name.length ?? 0) > 12)
                  ? '${value.correct?.examSession.exam.subject.name!.substring(0, 12)}...'
                  : value.correct?.examSession.exam.subject.name ?? '',
              style: setTextTheme(fontSize: MediaQuery.of(context).size.width * 0.0556),
            ),
          ),
          body: GestureDetector(
            onTap: () => _answerFocusNode.unfocus(),
            child: SafeArea(
              child: Stack(
                children: [
                  PageView.builder(
                    physics: _isSubmittingScore
                        ? NeverScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    controller: _pageController,
                    itemCount: value.correct?.examSession.exam.questions.length ?? 0,
                    onPageChanged: (index) {
                      if (!_isSubmittingScore) {
                        setState(() {
                          _currentIndex = index;
                          _lastKnownPageIndex = index; // Update last known index
                        });
                        print('Page changed to: $index');
                      }
                    },
                    itemBuilder: (context, index) {
                      final question = value.correct?.examSession.exam.questions[index];
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

                      final selectedAnswerIndex = int.tryParse(correction?.chosenAnswer ?? '-1') ?? -1;
                      final correctAnswerIndex = int.tryParse(correction?.correctAnswer ?? '-1') ?? -1;
                      final isAnswerCorrect = selectedAnswerIndex == correctAnswerIndex;

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

                      final double currentScore = value.getScore(question?.id ?? '') ?? 0.0;

                      // Update score controller text
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scoreController?.text != currentScore.toString() && mounted) {
                          _scoreController?.text = currentScore.toString();
                        }
                      });

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
                                maxHeight: MediaQuery.of(context).size.height * 0.2,
                              ),
                              child: Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                thickness: MediaQuery.of(context).size.width * 0.01,
                                radius: Radius.circular(MediaQuery.of(context).size.width * 0.01),
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
                                            fontSize: MediaQuery.of(context).size.width * 0.205,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context).size.height * 0.02375,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                question?.question
                                                        .replaceAll('<p>', '')
                                                        .replaceAll('</p>', '')
                                                        .replaceAll(' ', '')
                                                        .replaceAll('<br>', '')
                                                        .replaceAll(';', '') ??
                                                    '',
                                                style: setTextTheme(
                                                  fontSize: MediaQuery.of(context).size.width * 0.0444,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: true,
                                              ),
                                            ),
                                            if (session?.exam.questions[index].questionImage != null &&
                                                session!.exam.questions[index].questionImage!.isNotEmpty) ...[
                                              GestureDetector(
                                                onTap: () => _showImageDialog(
                                                  context,
                                                  session!.exam.questions[index].questionImage!,
                                                ),
                                                child: CircleAvatar(
                                                  backgroundImage:
                                                      AssetImage(session!.exam.questions[index].questionImage!),
                                                  radius: MediaQuery.of(context).size.width * 0.0556,
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
                            session?.exam.questions[index].type == 'theory'
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UploadTeacherTextBox(
                                        node: _textFieldFocusNode,
                                        fileName: correction?.chosenAnswer
                                            .replaceAll('<p>', '')
                                            .replaceAll('</p>', '')
                                            .replaceAll(' ', '')
                                            .replaceAll('<br>', ''),
                                        readOnly: true,
                                        examId: widget.examId,
                                        spaceId: widget.spaceId,
                                        examGroupId: widget.examGroupId,
                                        questionId: correction?.questionId ?? '',
                                        examSessionId: session?.id ?? '',
                                        myAnswer: correction?.chosenAnswer ?? '',
                                      ),
                                      SizedBox(height: 10.h),
                                      answer.resources != null && answer.resources.isNotEmpty
                                          ? SizedBox(
                                              height: 80.h * answer.resources.length,
                                              child: ListView.builder(
                                                itemCount: answer.resources.length,
                                                itemBuilder: (context, index) {
                                                  final resource = answer.resources[index];
                                                  String fileName = resource.split('/').last;
                                                  return GestureDetector(
                                                    onTap: () => showPdfDialog(context, resource),
                                                    child: Container(
                                                      width: 150.r,
                                                      height: 50.h,
                                                      margin: EdgeInsets.symmetric(horizontal: 8.r),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius: BorderRadius.circular(10.r),
                                                        border: Border.all(color: Colors.grey, width: 1),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '$fileName',
                                                          maxLines: 1,
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: setTextTheme(
                                                            fontSize: 14.sp,
                                                            color: darkShades[0],
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: 130.r,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r),
                                            color: Colors.grey[200],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 80.r,
                                                height: 30.h,
                                                child: TextFormField(
                                                  focusNode: _answerFocusNode,
                                                  controller: _scoreController,
                                                  decoration: InputDecoration(
                                                    hintStyle: setTextTheme(
                                                      fontSize: 14.sp,
                                                      color: darkShades[0],
                                                    ),
                                                    suffix: Text(
                                                      " / ${session?.exam.questions[index].mark}",
                                                      style: setTextTheme(
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: darkShades[0],
                                                      ),
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(vertical: 2.r),
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  textInputAction: TextInputAction.done,
                                                  onEditingComplete: () {
                                                    if (_scoreController?.text.isNotEmpty ?? false) {
                                                      _submitScore(
                                                        index: _currentIndex,
                                                        value: _scoreController!.text,
                                                        questionId: question?.id ?? '',
                                                      );
                                                    }
                                                    _answerFocusNode.unfocus();
                                                  },
                                                  onFieldSubmitted: (value) {
                                                    if (value.isNotEmpty) {
                                                      _submitScore(
                                                        index: _currentIndex,
                                                        value: value,
                                                        questionId: question?.id ?? '',
                                                      );
                                                      _answerFocusNode.unfocus();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                :ConstrainedBox(
  constraints: BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * 0.440,
  ),
  child: ListView.separated(
    itemCount: question?.options.length ?? 0,
    itemBuilder: (context, optionIndex) {
      final option = question!.options[optionIndex];
      
      final isSelected = selectedAnswerIndex == optionIndex;
      final isCorrect = correctAnswerIndex == optionIndex;
      
      final optionBox = OptionBoxes(
        backgroundLetter: String.fromCharCode(65 + optionIndex), // ensure int
        optionText: option.label.replaceAll('<p>', '').replaceAll('</p>', ''),
        optionImage: option.image,
        isSelected: isSelected,
        isCorrect: isCorrect,
        highlightColor: isSelected
            ? (isCorrect ? greenShades[3] : redShades[4])
            : (isCorrect ? greenShades[2] : whiteShades[0]),
      );

      // Determine which label to show
      String? labelText;
      Color? labelColor;
      
      if (isSelected && isCorrect) {
        labelText = '✓ Your Answer (Correct)';
        labelColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        labelText = '✗ Your Answer (Wrong)';
        labelColor = Colors.red;
      } else if (!isSelected && isCorrect) {
        labelText = '✓ Correct Answer';
        labelColor = Colors.green;
      }

      // Show label if there's one to display
      if (labelText != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            optionBox,
          ],
        );
      }

      return optionBox;
    },
    separatorBuilder: (_, __) => SizedBox(height: 5.h),
  ),
),

                                // : ConstrainedBox(
                                //     constraints: BoxConstraints(
                                //       maxHeight: MediaQuery.of(context).size.height * 0.440,
                                //     ),
                                //     child: ListView.separated(
                                //       itemCount: question?.options.length ?? 0,
                                //       itemBuilder: (context, optionIndex) {
                                //         return OptionBoxes(
                                //           backgroundLetter: String.fromCharCode(65 + optionIndex),
                                //           optionText: question?.options[optionIndex].label
                                //               .replaceAll('<p>', '')
                                //               .replaceAll('</p>', ''),
                                //           optionImage: question?.options[optionIndex].image,
                                //           isSelected: selectedAnswerIndex == optionIndex,
                                //           isCorrect: isAnswerCorrect,
                                //           highlightColor: selectedAnswerIndex == optionIndex
                                //               ? (selectedAnswerIndex == correctAnswerIndex
                                //                   ? greenShades[0]
                                //                   : redShades[0])
                                //               : (correctAnswerIndex == optionIndex
                                //                   ? greenShades[0]
                                //                   : whiteShades[0]),
                                //         );
                                //       },
                                //       separatorBuilder: (_, __) => SizedBox(height: 5.h),
                                //     ),
                                //   ),
                            if (selectedAnswerIndex == -1 && (correction?.chosenAnswer.isEmpty ?? false))
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Not Answered",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
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
                                headerBuilder: (_, __) => const SizedBox.shrink(),
                                body: Wrap(
                                  spacing: 8.r,
                                  runSpacing: 8.r,
                                  children: List.generate(
                                    value.correct?.corrections.length ?? 0,
                                    (index) => AnswerNotifierBoxes(
                                      questionNumber: index + 1,
                                      isCurrentQuestion: index == _currentIndex,
                                      onSelectAnswerNotifier: () {
                                        if (!_isSubmittingScore) {
                                          setState(() {
                                            _currentIndex = index;
                                            _lastKnownPageIndex = index;
                                          });
                                          _pageController.animateToPage(
                                            index,
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textFieldFocusNode.dispose();
    _answerFocusNode.dispose();
    _scoreController?.dispose();
    super.dispose();
  }


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

class PdfViewerDialog extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerDialog({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          // child: SfPdfViewer.network(pdfUrl),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Close",
            style: setTextTheme(
                fontSize: MediaQuery.of(context).size.width * 0.0556),
          ),
        ),
      ],
    );
  }
}
