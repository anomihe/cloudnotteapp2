import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/exam_session_model.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/homework_stats_box.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/topic_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeworkStatsScreen extends StatelessWidget {
  const HomeworkStatsScreen({
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

  static const String routeName = '/homework_stats_screen';

  @override
  Widget build(BuildContext context) {
    final summaryItem =
        generateSummaryInfo(selectedAnswers, chosenAnswer, homeworkModel);
    final numberOfTotalQuestions = homeworkModel.questions.length;
    final numberOfCorrectAnswers = summaryItem.where(
      (data) {
        return data['chosen_answer'] == data['correct_answer'];
      },
    ).length;
    final numberOfWrongAnswers = summaryItem.where(
      (data) {
        return data['chosen_answer'] != data['correct_answer'];
      },
    ).length;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.fromLTRB(14.w, 6.h, 6.w, 4.h),
          child: SizedBox(
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back_arrow_icon.svg',
                fit: BoxFit.none,
                height: 50.h,
                width: 50.w,
              ),
            ),
          ),
        ),
        leadingWidth: 45.w,
        title: Text(
          'Summary',
          style: setTextTheme(fontSize: 24.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    HomeworkStatsBox(
                      boxColor: blueShades[0],
                      title: 'Total Questions',
                      figure: '$numberOfTotalQuestions',
                      textColor: whiteShades[0],
                    ),
                    SizedBox(width: 10.w),
                    HomeworkStatsBox(
                      boxColor: greenShades[1],
                      title: 'Correct',
                      figure: '$numberOfCorrectAnswers',
                      textColor: darkShades[0],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    HomeworkStatsBox(
                      boxColor: goldenShades[0],
                      title: 'Failed',
                      figure: '$numberOfWrongAnswers',
                      textColor: darkShades[0],
                    ),
                    SizedBox(width: 10.w),
                    HomeworkStatsBox(
                      boxColor: redShades[0],
                      title: 'Duaration',
                      figure: '10 Mins',
                      textColor: whiteShades[0],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Topic Analysis',
                  style: setTextTheme(
                      fontWeight: FontWeight.w600, fontSize: 24.sp),
                ),
                SizedBox(height: 10.h),
                const TopicAnalysis(
                  part: 'Anatomy Part',
                  percentage: '85%',
                ),
                const TopicAnalysis(
                  part: 'Physiology Part',
                  percentage: '45%',
                ),
                const TopicAnalysis(
                  part: 'psychology Part',
                  percentage: '70%',
                ),
                const TopicAnalysis(
                  part: 'Astronomy Part',
                  percentage: '13%',
                ),
                const TopicAnalysis(
                  part: 'Physics Part',
                  percentage: '100%',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}




class ExamSummaryScreen extends StatefulWidget {
  final String studentId; 
  final  String spaceId; 
  final String examId; 
  final String id; 
  final String examGroupId; 
  const ExamSummaryScreen({super.key, required this.studentId, required this.spaceId, required this.examId, required this.id, required this.examGroupId});
  static const String routeName = '/single_homework_stats_screen';
  @override
  State<ExamSummaryScreen> createState() => _ExamSummaryScreenState();
}

class _ExamSummaryScreenState extends State<ExamSummaryScreen> {
  @override
  void initState(){
    super.initState(); 
    Provider.of<ExamHomeProvider>(context, listen:false).getExamSummary(context: context,id: widget.id, examGroupId: widget.examGroupId, examId: widget.examId, spaceId: widget.spaceId,studentId: widget.studentId);
  }


  


 String formatTime(String? dateTimeStr) {
  if (dateTimeStr == null || dateTimeStr.isEmpty) return '-';
  try {
    final dateTime = DateTime.parse(dateTimeStr).toLocal();
    return DateFormat('MMMM d, y \'at\' h:mm:ss a').format(dateTime);
  } catch (e) {
    return '-'; // or log error
  }
}


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('Exam Performance Summary')),
      body: Consumer<ExamHomeProvider>(
        builder: (context,value,_) {
          if(value.isLoading){
            return SkeletonListView(itemCount: 5,);
          }
          final data = value.examSummary;
              final percentScore = data?.examSession?.totalScore != null &&  data?.examSession?.exam?.totalMark != null
        ? (( (data?.examSession?.totalScore ??0) /  (data?.examSession?.exam?.totalMark ??0)) * 100).toStringAsFixed(1)
        : '-';
          final timeStarted = DateTime.parse("2025-04-26T16:05:33.097Z");
  final lastSavedAt = DateTime.parse("2025-04-26T16:06:32.680Z");

  final duration = lastSavedAt.difference(timeStarted);

  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  log('deasedseds ${data?.examSession?.exam?.endDate}');
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                /// User Info
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      child: Icon(Icons.person),
                    ),
                    title: Text('${data?.examSession?.student?.user.lastName ?? ''}, ${data?.examSession?.student?.user.firstName ?? ''}'),
                    subtitle: Text(data?.examSession?.student?.user.username ?? ''),
                  ),
                ),
                SizedBox(height: 16),
          
                /// Exam Time Info
                Row(
                  spacing: 10,
                  children: [
                      Expanded(
                      child: _infoCard(
                        title: 'Total Score',
                        value: '${data?.examSession?.totalScore?.toStringAsFixed(2)}/${data?.examSession?.exam?.totalMark}',
                        color: Colors.orange.shade100,
                      ),
                    ),
                    Expanded(
                      child: _infoCard(
                        title: 'Time Started',
                        value: data?.examSession?.timeStarted != null ? formatTime(data?.examSession?.timeStarted??'') : '-',
                        color: Colors.orange.shade100,
                      ),
                    ),
                    // SizedBox(width: 10),
                    Expanded(
                      child: _infoCard(
                        title: 'Time Spent',
                        value: '${minutes}m ${seconds}s' ,
                        color: Colors.red.shade100,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  spacing: 10,
                  children: [
                      Expanded(
                      child: _infoCard(
                        title: 'Expected End Time',
                        value: data?.examSession?.expectedEndTime != null ? formatTime(data?.examSession?.expectedEndTime??'') : '-',
                        color: Colors.orange.shade100,
                      ),
                    ),
                    Expanded(
                      child: _infoCard(
                        title: 'Last Saved At',
                        value: data?.examSession?.timeStarted != null ? formatTime(data?.examSession?.lastSavedAt??'') : '-',
                        color: Colors.orange.shade100,
                      ),
                    ),
                    // SizedBox(width: 10),
                    Expanded(
                      child: _infoCard(
                        title: 'Status',
                        value: '${data?.examSession?.status}' ,
                        color: Colors.red.shade100,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                /// Topic Breakdown & Detailed View
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _topicBarChart(data?.examLessonNoteBreakdown),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data?.examLessonNoteBreakdown?.map((topic) {
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(topic.topic??'', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Score: $percentScore%'),
                                  Text('Questions: ${topic.totalAnsweredForTopic}/${topic.totalQuestionForTopic}'),
                                  SizedBox(height: 6),
                                 LinearProgressIndicator(
  value: _getProgress(topic.totalAnsweredForTopic, topic.totalQuestionForTopic),
  backgroundColor: Colors.grey[200],
  color: Colors.blue,
)

                                ],
                              ),
                            ),
                          );
                        }).toList()??[],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _infoCard({required String title, required String value, required Color color}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
Widget _topicBarChart(List<LessonNoteBreakdown>? topics) {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Topic Performance Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Column(
            children: topics?.map((topic) {
              final percentage = (topic.percentageBreakdown ?? 0) / 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      percent: percentage.clamp(0.0, 1.0),
                      center: Text("${(percentage * 100).toStringAsFixed(0)}%"),
                      progressColor: Colors.blue,
                      backgroundColor: Colors.grey[300]!,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        topic.topic ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList() ?? [],
          )
        ],
      ),
    ),
  );
}
  // Widget _topicBarChart(List<LessonNoteBreakdown>? topics) {
  //   return Card(
  //     elevation: 1,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     child: Container(
  //       padding: EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Topic Performance Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
  //           SizedBox(height: 12),
  //           Column(
  //             children: topics?.map((topic) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 6),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       width: 16,
  //                       height: 16,
  //                       color: Colors.blue,
  //                     ),
  //                     SizedBox(width: 10),
  //                     Text(topic?.topic??''),
  //                   ],
  //                 ),
  //               );
  //             }).toList()??[],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  double _getProgress(int? answered, int? total) {
  if (total == null || total == 0) return 0.0;
  return (answered ?? 0) / total;
}

}
