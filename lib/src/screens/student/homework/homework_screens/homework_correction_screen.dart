import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/answer_notifier_boxes.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/option_boxes.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/upload_text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomeworkCorrectionScreen extends StatefulWidget {
  const HomeworkCorrectionScreen({
    super.key,
    required this.homeworkModel,
    required this.selectedAnswers,
    required this.chosenAnswer,
    required this.uploadFiles,
  });

  final HomeworkModel homeworkModel;
  final Map<int, int?> selectedAnswers;
  final List<String> chosenAnswer;
  final Map<int, String?> uploadFiles;

  static const String routeName = '/homework_correction_screen';

  @override
  State<HomeworkCorrectionScreen> createState() =>
      _HomeworkCorrectionScreenState();
}

class _HomeworkCorrectionScreenState extends State<HomeworkCorrectionScreen> {
  late FocusNode _textFieldFocusNode;
  bool _isTextFieldFocused = false;
  @override
  void initState() {
    super.initState();
    _textFieldFocusNode = FocusNode();
    _textFieldFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = _textFieldFocusNode.hasFocus;
      });
    });
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

  final PageController _pageController = PageController();
  bool _isExpanded = true;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: blueShades[11],
        actions: [
          GestureDetector(
            onTap: () {
              context.push(
                '/homework_stats_screen',
                extra: {
                  // 'homeworkModel': widget.homeworkModel,
                  'selectedAnswers': widget.selectedAnswers,
                  'chosenAnswer': widget.chosenAnswer,
                  'uploadFiles': widget.uploadFiles,
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 39.w,
              height: 37.h,
              decoration: BoxDecoration(
                color: redShades[0],
                borderRadius: BorderRadius.circular(100),
              ),
              child: SvgPicture.asset(
                'assets/icons/cil_graph_icon.svg',
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
        title: Text(''),
        // title: Text(
        //   widget.homeworkModel.subject.length > 12
        //       ? '${widget.homeworkModel.subject.substring(0, 12)}...'
        //       : widget.homeworkModel.subject,
        //   style: setTextTheme(fontSize: 20.sp),
        // ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.homeworkModel.questions.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final question = widget.homeworkModel.questions[index];
                final selectedAnswerIndex = widget.selectedAnswers[index];
                final correctAnswerIndex =
                    question.shuffledAnswers.indexOf(question.answer[0]);

                return Padding(
                  padding: EdgeInsets.only(
                      top: 51.h, left: 18.w, right: 18.w, bottom: 18.h),
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
                            padding: const EdgeInsets.symmetric(vertical: 19),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    question.question,
                                    style: setTextTheme(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                if (question.questionImage != null &&
                                    question.questionImage!.isNotEmpty) ...[
                                  GestureDetector(
                                    onTap: () => _showImageDialog(
                                        context, question.questionImage!),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(question.questionImage!),
                                      radius: 20.r,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Handle theory or objective questions
                      question.type == 'theory'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // UploadTextBox(
                                //   node: _textFieldFocusNode,
                                //   fileName: widget.uploadFiles[index],
                                //   readOnly: true,
                                // ),
                                SizedBox(height: 20.h),
                                Text(
                                  widget.uploadFiles[index] ??
                                      "No file uploaded or text added",
                                  style: setTextTheme(
                                    fontSize: 14.sp,
                                    color: darkShades[0],
                                  ),
                                ),
                              ],
                            )
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 300.h,
                              ),
                              child: ListView.separated(
                                itemCount: question.answer.length,
                                itemBuilder: (context, optionIndex) {
                                  return OptionBoxes(
                                    backgroundLetter: String.fromCharCode(
                                        65 + optionIndex), // A, B, C, D
                                    optionText: question.answer[optionIndex],
                                    optionImage:
                                        question.optionImages?[optionIndex],
                                    isSelected:
                                        selectedAnswerIndex == optionIndex,
                                    isCorrect:
                                        correctAnswerIndex == optionIndex,
                                    highlightColor:
                                        selectedAnswerIndex == optionIndex
                                            ? (selectedAnswerIndex ==
                                                    correctAnswerIndex
                                                ? greenShades[0]
                                                : redShades[0])
                                            : (correctAnswerIndex == optionIndex
                                                ? greenShades[0]
                                                : whiteShades[0]),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 3.h),
                              ),
                            ),
                      // Replace the current SizedBox with this improved UI
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: ExpansionTile(
                          title: Text(
                            'Feedback',
                            style: setTextTheme(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Text(
                                '',
                                // widget
                                //     .homeworkModel.questions[index].explanation,
                                style: setTextTheme(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
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
                      spacing: 1.r,
                      runSpacing: 2.r,
                      children: List.generate(
                        // widget.homeworkModel.questions.length,
                        10,
                        (index) => AnswerNotifierBoxes(
                          questionNumber: index + 1,
                          isCurrentQuestion: index == currentIndex,
                          onSelectAnswerNotifier: () {
                            _pageController.animateToPage(index,
                                duration: Duration(microseconds: 10),
                                curve: Curves.easeInOut);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
