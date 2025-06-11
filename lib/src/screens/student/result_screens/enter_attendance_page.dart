import 'dart:developer';

import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/exam_session_model.dart'
    show SubjectDetail;
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart' as user_model
    show SpaceTerm;
import 'package:cloudnottapp2/src/screens/student/result_screens/enter_score_page.dart' ;
import 'package:cloudnottapp2/src/screens/student/result_screens/widgets/attendance_tile_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart'
    show SkeletonListView;
import 'package:provider/provider.dart';

import '../../../data/models/class_group.dart';
import '../../../data/models/enter_score_widget_model.dart' hide ClassGroup;
import '../../../data/providers/lesson_note_provider.dart';
import '../../../data/providers/result_provider.dart';
import '../../../data/providers/user_provider.dart';

class EnterAttendancePage extends StatefulWidget {
  final String spaceId;
  const EnterAttendancePage({super.key, required this.spaceId});

  @override
  State<EnterAttendancePage> createState() => _EnterAttendancePageState();
}

class _EnterAttendancePageState extends State<EnterAttendancePage> {
 
  String? selectedClass;
  // String? selectedAssessment;
  String termId = '';
  BasicAssessment? selectedAssessment;
  List<SubjectDetail>? selectedSubjects;
  bool isShowing = false;
  List<String> subjectIDs = [];
  String? sessionId;
  List<Map<String, dynamic>> attendanceList = [];
  bool isOpen = false;

  void updateAttendance(Map<String, dynamic> updatedAttendance) {
    int index = attendanceList.indexWhere(
        (element) => element['resultId'] == updatedAttendance['resultId']);
    if (index != -1) {
      attendanceList[index] = updatedAttendance;
    } else {
      attendanceList.add(updatedAttendance);
    }
  }
 String userRole = '';
  @override
  void initState() {
    super.initState();
      final role =
        localStore.get('role', defaultValue: context.read<UserProvider>().role);
         userRole = role;
    Provider.of<ResultProvider>(context, listen: false).setBroadToNull();
    termId = localStore.get('termId',
            defaultValue: context.read<UserProvider>().termId ?? '') ??
        '';
    Provider.of<LessonNotesProvider>(context, listen: false).fetchClassGroup(
      spaceId: widget.spaceId,
      context: context,
    );
    // Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
    //     spaceId: widget.spaceId,
    //     context: context,
    //     termId: termId,
    //     classId: '',
    //     type: '');
  }

  @override
  Widget build(BuildContext context) {
        final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ??''; 
    final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
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

    return Column(
      spacing: 10.h,
      children: [
        Row(
          children: [
            Expanded(
              child: Consumer<ResultProvider>(
                builder: (context, value, _) {
                  return CustomDropdownFormField<SpaceSession>(
                    hintText: 'Select Session',
                    onChanged: (value) {
                      setState(() {
                        sessionId = value?.id;
                      });
                    },
                    items: value.space?.spaceSessions
                            ?.map(
                              (session) => DropdownMenuItem<SpaceSession>(
                                value: session,
                                child: Text(session.session),
                              ),
                            )
                            .toList() ??
                        [],
                  );
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomDropdownFormField<user_model.SpaceTerm>(
                hintText: 'Select Term',
                onChanged: (value) {
                  setState(() {
                    termId = value.id;
                  });
                },
                items: spaceTerms
                    .map(
                      (term) => DropdownMenuItem(
                        value: term,
                        child: Text(
                          term.name,
                          style: setTextTheme(),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        Row(
          spacing: 10.w,
          children: [
            Expanded(
              child: CustomDropdownFormField(
                hintText: 'Select Class',
                iconSize: 20,
                // value: selectedClass,
                onChanged: (value) {
                  setState(() {
                      // isShowing = true;
                    selectedClass = value;
selectedAssessment = null;
                    context
                        .read<ResultProvider>()
                        .setBroadToNull();
                    attendanceList.clear();
                    ClassModel? selectedClassModel;

                    for (var classGroup in spaceSubject) {
                      for (var classModel in classGroup.classes ?? []) {
                        if (classModel.id == value) {
                          selectedClassModel = classModel;
                          break;
                        }
                      }
                      if (selectedClassModel != null) break;
                    }

                    if (selectedClassModel != null) {
                      selectedSubjects = selectedClassModel.subjectDetails;

                      List<String> subjectIds = selectedClassModel
                              .subjectDetails
                              ?.map((subject) => subject.id)
                              .toList() ??
                          [];

                      subjectIDs.addAll(subjectIds);
                      print('Selected subject IDs: $subjectIds');
                    }
                  });
                    Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
        spaceId: widget.spaceId,
        context: context,
        termId: termId,
        classId: selectedClass ?? '',
        type: '');
                },
                // items: spaceSubject
               items: filteredClassGroups.expand((classGroup) {
                  return classGroup.classes.map((classModel) {
                    String classDisplayName =
                        "${classGroup.name} - ${classModel.name}";
                    return DropdownMenuItem<String>(
                      value: classModel.id,
                      // value: classGroup.id,
                      child: SizedBox(
                        width: 100.w,
                        child: Text(
                          classDisplayName,
                          maxLines: 1,
                          softWrap: true,
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
            ),
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
              return Expanded(
                child: CustomDropdownFormField<BasicAssessment>(
                  hintText: 'Select assessment',
                  value: selectedAssessment,
                  onChanged: selectedClass == null
                      ? (v) {}
                      : (v) {
                          log('Selected Assessment: ${v?.assessmentId}');
                          setState(() {
                            selectedAssessment = v;
                            isOpen = !isOpen;
                            isShowing = true;
                            // isShowing = !isShowing;
                          });
                           context
                        .read<ResultProvider>()
                        .setBroadToNull();
                    attendanceList.clear();
                          Provider.of<ResultProvider>(context, listen: false)
                              .getBroadSheet(
                            spaceId: widget.spaceId,
                            context: context,
                            classId: selectedClass!,
                            assessmentId: v?.assessmentId,
                            sessionId: sessionId!,
                            termId: termId,
                          );
                          Provider.of<ResultProvider>(context, listen: false)
                              .getTermDate(
                            spaceId: widget.spaceId,
                            context: context,
                            sessionId: sessionId!,
                            termId: termId,
                          );
                        },
                  items: value.assess
                      .map(
                        (assessment) => DropdownMenuItem(
                          value: assessment,
                          child: Text(
                            assessment.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: setTextTheme(
                              color:
                                  selectedClass == null ? whiteShades[3] : null,
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
        if(isShowing)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Consumer<ResultProvider>(builder: (context, value, _) {
            return Row(
              children: [
                Text(
                  'Days School Opened:',
                  style: setTextTheme(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  isOpen ? value.termData?.daysOpen?.toString() ?? '0' : '0',
                  style: setTextTheme(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Buttons(
                  onTap: (value.broadsheet?.results?.isEmpty ?? true)? () {
                    Provider.of<ResultProvider>(context, listen: false)
                        .markAttendance(
                      context: context,
                      spaceId: widget.spaceId,
                      input: attendanceList,
                      sessionId: sessionId!,
                      termId: termId,
                      classId: selectedClass!,
                      assessmentId: selectedAssessment?.assessmentId ?? '',
                    )
                        .then((_) {
                      Provider.of<ResultProvider>(context, listen: false)
                          .getBroadSheet(
                              context: context,
                              sessionId: sessionId ?? '',
                              termId: termId,
                              classId: selectedClass ?? '',
                              assessmentId:
                                  selectedAssessment?.assessmentId ?? '',
                              spaceId: widget.spaceId);
                    });
                  }:(){},
                  text: 'Save',
                  enabled: (value.broadsheet?.results?.isEmpty ?? true)?false:true,
                  width: 80,
                  height: 30,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  isLoading: false,
                )
              ],
            );
          }),
        ),
        Expanded(
          child: Consumer<ResultProvider>(
            builder: (context, value, _) {
              final results = value.broadsheet?.results;

              if (results == null || results.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/app/paparazi_image_a.png'),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "No Attendance data available",
                          style: setTextTheme(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                );
              }

              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final data = results[index];
                  if (value.isLoading) {
                    return SizedBox(height: 100, child: SkeletonListView());
                  }
                  return AttendanceTileWidget(
                    context,
                    "${data.student?.user?.firstName ?? ''} ${data.student?.user?.lastName ?? ''}",
                    totalSchoolDays: value.termData?.daysOpen ?? 0,
                    result: data,
                    onAttendanceUpdated: updateAttendance,
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
