import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/homework_stats_box.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/topic_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TeacherStatsScreen extends StatefulWidget {
  final String examId; 
  final String examGroupId; 
  final String spaceId; 
  const TeacherStatsScreen({
    super.key, required this.examId, required this.examGroupId, required this.spaceId,
  });

  static const String routeName = '/teacher_stats_screen';

  @override
  State<TeacherStatsScreen> createState() => _TeacherStatsScreenState();
}

class _TeacherStatsScreenState extends State<TeacherStatsScreen> {
  @override 
  void initState(){
    super.initState(); 
    Provider.of<ExamHomeProvider>(context, listen: false).examMainSummary(
      context: context,
      examId: widget.examId,
      examGroupId: widget.examGroupId,
      spaceId: widget.spaceId,
    );
  }
  @override
  Widget build(BuildContext context) {

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
      body: Consumer<ExamHomeProvider>(
  builder: (context, provider, _) {
    final breakdown = provider.mainSummary?.examSessionBreakdown;
    final topics = provider.topicBreakdown;

    final totalSessions = breakdown?.totalSessions ?? 0;
    final averageScore = breakdown?.averageScore ?? 0;
    final averageDuration = breakdown?.averageDuration ?? 0;

    // final highest = breakdown?.highestSession;
    // final lowest = breakdown?.lowestSession;

     final highest = (breakdown?.highestSession ?? [])
      ..sort((a, b) => (b.totalScore ?? 0).compareTo(a.totalScore ?? 0));
    final lowest = (breakdown?.lowestSession ?? [])
      ..sort((a, b) => (a.totalScore ?? 0).compareTo(b.totalScore ?? 0));

    final highestStudent = highest.isNotEmpty ? highest.first : null;
    final lowestStudent = lowest.isNotEmpty ? lowest.first : null;
final allSessions = provider.mainSummary?.examSessionBreakdown.lowestSession ?? [];
final failedScores = allSessions.where((s) => s.totalScore != null && s.totalScore! < 50).toList();

final failedAverage = failedScores.isNotEmpty
    ? failedScores.map((s) => s.totalScore!).reduce((a, b) => a + b) / failedScores.length
    : null;

final failedPercentage = failedAverage != null
    ? '${(100 - failedAverage).toStringAsFixed(1)}%'
    : '--%';

final allSessionsHigh = provider.mainSummary?.examSessionBreakdown.highestSession ?? [];
final passedScores = allSessionsHigh.where((s) => s.totalScore != null && s.totalScore! >= 5).toList();

final passedAverage = passedScores.isNotEmpty
    ? passedScores.map((s) => s.totalScore!).reduce((a, b) => a + b) / passedScores.length
    : null;

final passedPercentage = passedAverage != null
    ? '${passedAverage.toStringAsFixed(1)}%'
    : '--%';
final lessonBreakdowns = provider.mainSummary?.examLessonNoteBreakdown ?? [];
    final totalQuestions = lessonBreakdowns.fold<int>(
  0,
  (sum, item) => sum + item.totalQuestionForTopic,
);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              // Top stats
              Row(
                children: [
                  HomeworkStatsBox(
                    boxColor: blueShades[0],
                    title: 'Total Questions',
                    figure: '$totalQuestions',
                    textColor: whiteShades[0],
                  ),
                  SizedBox(width: 10.w),
                  HomeworkStatsBox(
  boxColor: greenShades[1],
  title: 'Passed',
  figure: passedPercentage,
  textColor: darkShades[0],
),

                  // HomeworkStatsBox(
                  //   boxColor: greenShades[1],
                     
                  //   title: 'Passed',
                  //   figure: '${averageScore.toStringAsFixed(1)}%',
                  //   textColor: darkShades[0],
                  // ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  // HomeworkStatsBox(
                  //   boxColor: goldenShades[0],
                  //   title: 'Failed',
                  //   figure: '${(100 - averageScore).toStringAsFixed(1)}%',
                  //   textColor: darkShades[0],
                  // ),
                  HomeworkStatsBox(
  boxColor: goldenShades[0],
  title: 'Failed',
  figure: failedPercentage,
  textColor: darkShades[0],
),
                  SizedBox(width: 10.w),
                  HomeworkStatsBox(
                    boxColor: redShades[0],
                    title: 'Duration',
                    figure: '${averageDuration.toStringAsFixed(0)} Mins',
                    textColor: whiteShades[0],
                  ),
                ],
              ),

           
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: blueShades[2],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Students that submitted',
                      style: setTextTheme(fontSize: 16.sp, color: whiteShades[0])),
                    Text(
                      '${provider.mainSummary?.examSessionBreakdown.totalSessions ?? 0} of ${context.read<ExamHomeProvider>().gotWrittenExam.length} Students',
                      style: setTextTheme(fontSize: 24.sp, color: whiteShades[0]),
                    ),
                  ],
                ),
              ),

          
              SizedBox(height: 10.h),
           

  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Column(
              children: [
                Text('Highest score',
                    style: setTextTheme(fontSize: 16.sp, color: blueShades[2])),
                Text(
                  '${highestStudent?.totalScore ?? '--'}%',
                  style: setTextTheme(
                      fontSize: 14.sp,
                      color: greenShades[0],
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 30.h,
                      width: 37.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: (highestStudent?.student.user.profileImageUrl?.isNotEmpty ?? false)
                            ? Image.network(
                                highestStudent!.student.user.profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Image.asset('assets/app/profile_image.png'),
                              )
                            : Image.asset('assets/app/profile_image.png'),
                      ),
                    ),
                    SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${highestStudent?.student.user.firstName ?? ''} ${highestStudent?.student.user.lastName ?? ''}',
                          style: setTextTheme(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),

            Spacer(),

            Column(
              children: [
                Text('Lowest score',
                    style: setTextTheme(fontSize: 16.sp, color: blueShades[2])),
                Text(
                  '${lowestStudent?.totalScore ?? '--'}%',
                  style: setTextTheme(
                      fontSize: 14.sp,
                      color: redShades[0],
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 30.h,
                      width: 37.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: (lowestStudent?.student.user.profileImageUrl?.isNotEmpty ?? false)
                            ? Image.network(
                                lowestStudent!.student.user.profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Image.asset('assets/app/profile_image.png'),
                              )
                            : Image.asset('assets/app/profile_image.png'),
                      ),
                    ),
                    SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${lowestStudent?.student.user.firstName ?? ''} ${lowestStudent?.student.user.lastName ?? ''}',
                          style: setTextTheme(
                              fontSize: 14.sp,
                              color: blueShades[2],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),

//end

            ],
          ),
        ),

        // Topic Analysis
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student Topic Analysis',
                  style: setTextTheme(
                      fontWeight: FontWeight.w600, fontSize: 24.sp)),
              SizedBox(height: 10.h),
              ...topics.map((topic) => TopicAnalysis(
                    part: topic.topic,
                    percentage: '${topic.percentageBreakdown.toStringAsFixed(1)}%',
                  )),
            ],
          ),
        ),
      ],
    );
  },
),

      // body: Consumer<ExamHomeProvider>(
      //   builder: (context, value, _) {
      //     return Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 14),
      //           child: Column(
      //             children: [
      //               Row(
      //                 children: [
      //                   HomeworkStatsBox(
      //                     boxColor: blueShades[0],
      //                     title: 'Total Questions',
      //                     figure: '$numberOfTotalQuestions',
      //                     textColor: whiteShades[0],
      //                   ),
      //                   SizedBox(width: 10.w),
      //                   HomeworkStatsBox(
      //                     boxColor: greenShades[1],
      //                     title: 'Passed',
      //                     figure: '$percentagePassed%',
      //                     textColor: darkShades[0],
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(height: 5.h),
      //               Row(
      //                 children: [
      //                   HomeworkStatsBox(
      //                     boxColor: goldenShades[0],
      //                     title: 'Failed',
      //                     figure: '$numberOfWrongAnswers%',
      //                     textColor: darkShades[0],
      //                   ),
      //                   SizedBox(width: 10.w),
      //                   HomeworkStatsBox(
      //                     boxColor: redShades[0],
      //                     title: 'Duaration',
      //                     figure: '10 Mins',
      //                     textColor: whiteShades[0],
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(height: 5.h),
      //               Container(
      //                 padding: EdgeInsets.all(20),
      //                 width: double.infinity,
      //                 decoration: BoxDecoration(
      //                   color: blueShades[2],
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       'Students that submitted',
      //                       style: setTextTheme(
      //                           fontSize: 16.sp, color: whiteShades[0]),
      //                     ),
      //                     Text(
      //                       '10 of 20 Students',
      //                       style: setTextTheme(
      //                           fontSize: 24.sp, color: whiteShades[0]),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(height: 10.h),
      //               Row(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment:
      //                     MainAxisAlignment.start, 
      //                 children: [
      //                   Column(
      //                     children: [
      //                       Text(
      //                         'Highest score',
      //                         style: setTextTheme(
      //                             fontSize: 16.sp, color: blueShades[2]),
      //                       ),
      //                       //the 100% moved to the center instead of starting from the left like the highest score text score
      //                       Text(
      //                         '100%',
      //                         style: setTextTheme(
      //                             fontSize: 14.sp,
      //                             color: greenShades[0],
      //                             fontWeight: FontWeight.w700),
      //                       ),
      //                       Row(
      //                         children: [
      //                           SizedBox(
      //                             height: 30.h,
      //                             width: 37.w,
      //                             child:
      //                                 Image.asset('assets/app/profile_image.png'),
      //                           ),
      //                           Column(
      //                             children: [
      //                               Text(
      //                                 'Arnold E.',
      //                                 style: setTextTheme(
      //                                     fontSize: 14.sp,
      //                                     color: blueShades[2],
      //                                     fontWeight: FontWeight.w500),
      //                               ),
      //                               Text(
      //                                 '@Brainyjosh2',
      //                                 style: setTextTheme(
      //                                     fontSize: 11.sp,
      //                                     color: blueShades[13],
      //                                     fontWeight: FontWeight.w400),
      //                               )
      //                             ],
      //                           )
      //                         ],
      //                       )
      //                     ],
      //                   ),
      //                   Spacer(),
      //                   Column(
      //                     children: [
      //                       Text(
      //                         'Lowest score',
      //                         style:
      //                             setTextTheme(fontSize: 16, color: blueShades[2]),
      //                       ),
      //                       Text(
      //                         '10%',
      //                         style: setTextTheme(
      //                             fontSize: 14,
      //                             color: redShades[0],
      //                             fontWeight: FontWeight.w700),
      //                       ),
      //                       Row(
      //                         children: [
      //                           SizedBox(
      //                             height: 30.h,
      //                             width: 37.w,
      //                             child:
      //                                 Image.asset('assets/app/profile_image.png'),
      //                           ),
      //                           Column(
      //                             children: [
      //                               Text(
      //                                 'Arnold E.',
      //                                 style: setTextTheme(
      //                                     fontSize: 14,
      //                                     color: blueShades[2],
      //                                     fontWeight: FontWeight.w500),
      //                               ),
      //                               Text(
      //                                 '@Brainyjosh2',
      //                                 style: setTextTheme(
      //                                     fontSize: 11,
      //                                     color: blueShades[13],
      //                                     fontWeight: FontWeight.w400),
      //                               )
      //                             ],
      //                           )
      //                         ],
      //                       )
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //         SizedBox(height: 10.h),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 20),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 'Student Topic Analysis',
      //                 style: setTextTheme(
      //                     fontWeight: FontWeight.w600, fontSize: 24.sp),
      //               ),
      //               SizedBox(height: 10.h),
      //               const TopicAnalysis(
      //                 part: 'Anatomy Part',
      //                 percentage: '85%',
      //               ),
      //               const TopicAnalysis(
      //                 part: 'Physiology Part',
      //                 percentage: '45%',
      //               ),
      //               const TopicAnalysis(
      //                 part: 'psychology Part',
      //                 percentage: '70%',
      //               ),
      //               const TopicAnalysis(
      //                 part: 'Astronomy Part',
      //                 percentage: '13%',
      //               ),
      //             ],
      //           ),
      //         )
      //       ],
      //     );
      //   }
      // ),
    );
  }
}
