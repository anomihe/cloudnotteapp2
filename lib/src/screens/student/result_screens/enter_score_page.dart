import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    hide ClassGroup;
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/student_score_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/class_group.dart';
import '../../../data/models/exam_session_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/lesson_note_provider.dart';

import '../../../data/providers/result_provider.dart';
import '../../../data/providers/user_provider.dart';

class EnterScorePage extends StatefulWidget {
  final String spaceId;
  const EnterScorePage({super.key, required this.spaceId});

  @override
  State<EnterScorePage> createState() => _EnterScorePageState();
}

class _EnterScorePageState extends State<EnterScorePage> {
 
  // String? selectedClass;
  ClassModel? selectedClass;

  // String? selectedAssessment;
  String termId = '';
  String type = '';
  BasicAssessment? selectedAssessment;
  List<SubjectDetail>? selectedSubjects;
  List<String> subjectIDs = [];
   String userRole = '';
  @override
  void initState() {
    super.initState();

    final role =
        localStore.get('role', defaultValue: context.read<UserProvider>().role);
         userRole = role;
    termId = localStore.get('termId',
            defaultValue: context.read<UserProvider>().termId ?? '') ??
        '';
    //  type = termId.isEmpty ? context.read<UserProvider>().u ?? '' : termId;
    Provider.of<LessonNotesProvider>(context, listen: false).fetchClassGroup(
      spaceId: widget.spaceId,
      context: context,
    );
    // Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
    //   spaceId: widget.spaceId,
    //   context: context,
    //   termId: termId,
    //   classId: selectedClass?.id ?? '',
    //   type: selectedAssessment?.type ?? '',
    // );
  }

  @override
  Widget build(BuildContext context) {
        final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ??''; 
    final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
    final spaceSubject = spaceSubjectRaw.toSet().toList();
  List<ClassGroup> filteredClassGroups;
  if (userRole == 'admin') {
  filteredClassGroups = spaceSubject;
} else {
  filteredClassGroups = spaceSubject.map((classGroup) {
    // Filter classes within this class group
    final filteredClasses = classGroup.classes.where((classModel) {
      // Check if this class has any subjects taught by current teacher
      return classModel.subjectDetails.any((subject) {
        return subject.teacher?.user?.id == currentUserId;
      });
    }).map((classModel) {
      // For each qualifying class, filter its subjects
      final filteredSubjects = classModel.subjectDetails.where((subject) {
        return subject.teacher?.user?.id == currentUserId;
      }).toList();
      
      // Return a copy of the class with only the teacher's subjects
      return classModel.copyWith(subjectDetails: filteredSubjects);
    }).toList();

    // Only include class group if it has any filtered classes
    return filteredClasses.isNotEmpty 
        ? classGroup.copyWith(classes: filteredClasses)
        : null;
  }).whereType<ClassGroup>().toList();
}
// if (userRole == 'admin') {
//   filteredClassGroups = spaceSubject;
// } else {
// filteredClassGroups = spaceSubject.where((classGroup) {
//   log('Checking ClassGroup: ${classGroup.name} ${classGroup.classes}');

//   bool classGroupHasCurrentUser = classGroup.classes.any((classModel) {

// log('Checking Class: ${classModel.name} ${classModel.subjectDetails.map((e) => e?.teacher?.firstName ?? '').toList()}');

//     bool classHasSubjectWithTeacher = classModel.subjectDetails.any((subject) {
//       final teacher = subject.teacher;
//       final teacherUserId = teacher?.user?.id;

//       log('    Subject ${subject.name} teacher: ${teacher?.user?.firstName ?? "No teacher"}');

//       if (teacherUserId == null) {
//         return false;
//       } else {
//         return teacherUserId == currentUserId;
//       }
//     });

//     return classHasSubjectWithTeacher;
//   });

//   return classGroupHasCurrentUser;
// }).toList();


//    log('the teacher $filteredClassGroups $currentUserId ');
// }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        // spacing: 10.h,
        children: [
          Row(
            spacing: 10.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: CustomDropdownFormField<ClassModel?>(
  hintText: 'Select Class',
  iconSize: 20,
  value: filteredClassGroups
          .expand((group) => group.classes)
          .any((c) => c.id == selectedClass?.id)
      ? selectedClass
      : null,
  onChanged: (value) {
    context.read<ResultProvider>().report.clear();
    // context.read<ResultProvider>().assess.clear();
    setState(() {
      selectedClass = value;
      selectedAssessment = null;
      selectedSubjects = value?.subjectDetails;
      subjectIDs = selectedClass?.subjectDetails
              ?.map((subject) => subject.id)
              .toList()
              .cast<String>() ??
          [];
      Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
        spaceId: widget.spaceId,
        context: context,
        termId: termId,
        classId: selectedClass?.id ?? '',
        type: selectedAssessment?.type ?? '',
      );
    });
  },
  items: filteredClassGroups.expand((classGroup) {
    return classGroup.classes.map((classModel) {
      String classDisplayName = "${classGroup.name} - ${classModel.name}";
      return DropdownMenuItem<ClassModel?>(
        value: classModel,
        child: SizedBox(
          width: 100.w,
          child: Text(
            classDisplayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: setTextTheme(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    });
  }).toList(),
),

//                 child: CustomDropdownFormField<ClassModel?>(
//                   hintText: 'Select Class',
//                   iconSize: 20,
//                    value: filteredClassGroups.contains(selectedClass) ? selectedClass : null,
//                   // value: selectedClass,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedClass = value;
// selectedAssessment = null;
//                       selectedSubjects = value?.subjectDetails;
//                       subjectIDs = selectedClass?.subjectDetails
//                               ?.map((subject) => subject.id)
//                               .toList()
//                               .cast<String>() ??
//                           [];
//                       print('ids ${selectedClass?.id}');
//                       Provider.of<ResultProvider>(context, listen: false)
//                           .getBasicAssessments(
//                         spaceId: widget.spaceId,
//                         context: context,
//                         termId: termId,
//                         classId: selectedClass?.id ?? '',
//                         type: selectedAssessment?.type ?? '',
//                       );
//                       // subjectIDs =
//                       //     value?.subjectDetails?.map((s) => s.id).toList() ??
//                       //         [];
//                     });
//                   },
//                   items: spaceSubject.expand((classGroup) {
//                     return classGroup.classes.map((classModel) {
//                       String classDisplayName =
//                           "${classGroup.name} - ${classModel.name}";
//                       return DropdownMenuItem<ClassModel?>(
//                         value: classModel.id == selectedClass?.id
//                             ? selectedClass
//                             : classModel,
//                         child: SizedBox(
//                           width: 100.w,
//                           child: Text(
//                             classDisplayName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: setTextTheme(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       );
//                     });
//                   }).toList(),
//                 ),
              ),
              // Flexible(
              //   child: CustomDropdownFormField<String?>(
              //     hintText: 'Select Class',
              //     iconSize: 20,
              //     value: selectedClass,
              //     onChanged: (value) {
              //       setState(() {
              //         selectedClass = value;

              //         ClassModel? selectedClassModel;

              //         for (var classGroup in spaceSubject) {
              //           for (var classModel in classGroup.classes ?? []) {
              //             if (classModel.id == value) {
              //               selectedClassModel = classModel;
              //               break;
              //             }
              //           }
              //           if (selectedClassModel != null) break;
              //         }

              //         if (selectedClassModel != null) {
              //           selectedSubjects = selectedClassModel.subjectDetails;

              //           List<String> subjectIds = selectedClassModel
              //                   .subjectDetails
              //                   ?.map((subject) => subject.id)
              //                   .toList() ??
              //               [];

              //           subjectIDs.addAll(subjectIds);
              //         }
              //       });
              //     },
              //     items: spaceSubject.expand((classGroup) {
              //       return classGroup.classes.map((classModel) {
              //         String classDisplayName =
              //             "${classGroup.name} - ${classModel.name}";
              //         String compositeId = "${classGroup.id}-${classModel.id}";
              //         return DropdownMenuItem<String>(
              //           value: classModel.id,
              //           //  value: compositeId,
              //           child: SizedBox(
              //             width: 100.w,
              //             child: Text(
              //               classDisplayName,
              //               maxLines: 1,
              //               softWrap: true,
              //               overflow: TextOverflow.ellipsis,
              //               style: setTextTheme(
              //                 fontSize: 12.sp,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //           ),
              //         );
              //       });
              //     }).toList(),
              //   ),
              // ),
              // SizedBox(
              //   width: 0.05.w,
              // ),
              Consumer<ResultProvider>(builder: (context, value, _) {
                if (selectedAssessment != null &&
                    !value.assess.contains(selectedAssessment)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      selectedAssessment = null;
                    });
                  });
                }
                return Flexible(
                  child: CustomDropdownFormField<BasicAssessment>(
                    hintText: 'Select assessment',
                    value: selectedAssessment,
                    onChanged: selectedClass == null
                        ? (_) {}
                        : (v) {
                           context.read<ResultProvider>().report.clear();
                            log('Selected Assessment: ${v?.assessmentId}');
                            setState(() {
                              selectedAssessment = v;
                            });
                            // String? classId = selectedClass?.split('-').last;
                            Provider.of<ResultProvider>(context, listen: false)
                                .getStudentsReport(
                              spaceId: widget.spaceId,
                              context: context,
                              classId: selectedClass?.id ?? '',
                              // classId: classId!,
                              subjectId: subjectIDs,
                              assessmentId: v?.assessmentId,
                            );
                            Provider.of<ResultProvider>(context, listen: false)
                                .getBasicGrading(
                              context: context,
                              spaceId: widget.spaceId,
                              assessmentId:
                                  selectedAssessment?.assessmentId ?? '',
                            );
                          },
                    items: value.assess
                        .map(
                          (assessment) => DropdownMenuItem(
                            value: assessment,
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                '${assessment.name}(${assessment.type})' ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: setTextTheme(
                                  color: selectedClass == null
                                      ? whiteShades[3]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }),
            ],
          ),
          Consumer<ResultProvider>(builder: (context, value, _) {
            if (value.isLoading) {
              return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: SkeletonListView(
                    itemCount: 10,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    item: SkeletonItem(
                      child: Row(
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              shape: BoxShape.circle,
                              width: 40.r,
                              height: 40.r,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 14.sp,
                                  width: 120.w,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(height: 5),
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 12.sp,
                                  width: 100.w,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(height: 5),
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  height: 10.sp,
                                  width: 80.w,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 20.r,
                              height: 20.r,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            }
            if (value.report.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/app/paparazi_image_a.png'),
                    SizedBox(height: 60.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        "No Student",
                        style: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              );
            }
            // final uniqueReports = value.report.toSet().toList();
            final groupedReports =
                groupBy(value.report, (SubjectReportModel report) {
              return report.userId;
            });
            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final reportsForStudent =
                      groupedReports.values.elementAt(index);
                  return studentScoreEntryWidget(
                      context,
                      reportsForStudent,
                      // uniqueReports[index],
                      // value.report[index],
                      widget.spaceId,
                      selectedClass?.id ?? '',
                      selectedAssessment?.assessmentId ?? '');
                },
                // itemCount: value.report.length,
                itemCount: groupedReports.length,
                // itemCount: mockDataScore.length,
              ),
            );
          }),

          // Spacer(),
          // Buttons(
          //   text: 'Save Scores',
          //   fontSize: 15.sp,
          //   onTap: () {},
          //   isLoading: false,
          // ),
        ],
      ),
    );
  }
}

Widget studentScoreEntryWidget(
  BuildContext context,
  // SubjectReportModel scoreWidgetModel,
  List<SubjectReportModel> scoreWidgetModel,
  String spaceId,
  String classId,
  String assessmentId,
  // EnterScoreWidgetModel scoreWidgetModel,
) {
  scoreWidgetModel.first.scores?.forEach((score) {
    log('Score: ${score.score}');
  });

  final int totalScore = scoreWidgetModel
      .expand((report) => report.scores ?? [])
      .fold<int>(0, (int sum, dynamic score) {
    final int scoreValue = (score.score ?? 0).toInt();
    return sum + scoreValue;
  });

  return GestureDetector(
    onTap: () {
      context.push(StudentScoreEntryScreen.routeName, extra: {
        "scoreWidgetModel": scoreWidgetModel,
        "spaceId": spaceId,
        "classId": classId,
        "assessmentId": assessmentId,
      });
    },
    child: Container(
      width: double.infinity,
      // height: 65.sp,
      margin: EdgeInsets.only(bottom: 5.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: ThemeProvider().isDarkMode ? blueShades[15] : whiteShades[7],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.5,
          color: ThemeProvider().isDarkMode ? blueShades[10] : whiteShades[3],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: scoreWidgetModel.first.profileImageUrl != null
                      ? NetworkImage(
                          scoreWidgetModel.first.profileImageUrl!,
                        )
                      : AssetImage('assets/app/profile_picture1.png'),
                  fit: BoxFit.cover,
                  // colorFilter: ColorFilter.mode(
                  //   ThemeProvider().isDarkMode ? Colors.white : Colors.white,
                  //   BlendMode.srcIn,
                  // )
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0,
              children: [
                Text(
                  '${scoreWidgetModel.first.firstName} ${scoreWidgetModel.first.lastName}',
                  style: setTextTheme(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    lineHeight: 0.8,
                  ),
                ),
                Text(
                  scoreWidgetModel.first.username ?? '',
                  style: setTextTheme(
                    fontSize: 12.sp,
                    color: whiteShades[3],
                    fontWeight: FontWeight.w400,
                    lineHeight: 1.2,
                  ),
                ),
                Text(
                  // 'Total score: ${scoreWidgetModel.first.total}',
                  'Total score: $totalScore',
                  style: setTextTheme(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    lineHeight: 1,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    ),
  );
}
