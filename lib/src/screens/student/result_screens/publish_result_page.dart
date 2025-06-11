import 'dart:developer';

import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart' show ClassModel;
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    show BasicAssessment, SpaceSession, Student;
import 'package:cloudnottapp2/src/data/models/user_model.dart' show SpaceTerm;

import '../../../data/models/exam_session_model.dart';
import '../../../data/providers/lesson_note_provider.dart';
import '../../../data/providers/result_provider.dart';
import '../../../data/providers/user_provider.dart';

class PublishResultPage extends StatefulWidget {
  final String spaceId;
  const PublishResultPage({super.key, required this.spaceId});

  @override
  State<PublishResultPage> createState() => _PublishResultPageState();
}

class _PublishResultPageState extends State<PublishResultPage> {
  // final List<String> classes = ['JSS 1 - A', 'JSS 1 - B', 'JSS 2'];
  // final List<String> assessment = ['General Assessment'];
  final List<String> audience = ['Parents, Students'];

  // String? selectedAssessment;
  String? selectedAudience;
  bool isPublished = false;
  String? selectedClass;
  // String? selectedAssessment;
  String termId = '';
  BasicAssessment? selectedAssessment;
  List<SubjectDetail>? selectedSubjects;
  List<String> subjectIDs = [];
  String? sessionId;
  @override
  void initState() {
    super.initState();
    sessionId = localStore.get(
      'sessionId',
      defaultValue: context.read<UserProvider>().classSessionId,
    );
    termId = localStore.get(
      'termId',
      defaultValue: context.read<UserProvider>().termId,
    );
    if (mounted) {
      Provider.of<LessonNotesProvider>(context, listen: false).fetchClassGroup(
        spaceId: widget.spaceId,
        context: context,
      );
    //   Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
    //       spaceId: widget.spaceId,
    //       context: context,
    //       termId: termId,
    //       classId: selectedClass ?? '',
    //       type: selectedAssessment?.type ?? '');
   }
  }

  @override
  Widget build(BuildContext context) {
    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
    final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
    final spaceSubject = spaceSubjectRaw.toSet().toList();
    final termm = spaceTerms.firstWhere((e) => e.id == termId);
    return Column(
      children: [
        Expanded(
          child: IgnorePointer(
             ignoring: true,
            child: Consumer<ResultProvider>(
              builder: (context, value, _) {
                final id = value.space?.spaceSessions
                    ?.firstWhere((e) => e.id == sessionId);
                return CustomDropdownFormField<SpaceSession>(
                    value: id,
                    hintText: 'Select Session',
                    onChanged: (v) {},
                    // onChanged: (value) {
                    //   setState(() {
                    //     sessionId = value?.id;
                    //   });
                    // },
                    items: [
                      DropdownMenuItem<SpaceSession>(
                        value: id,
                        child: Text(
                          id?.session ?? '',
                          style: setTextTheme(),
                        ),
                      ),
                    ]
                    // items: value.space?.spaceSessions
                    //         ?.map(
                    //           (session) => DropdownMenuItem<SpaceSession>(
                    //             value: session,
                    //             child: Text(session.session),
                    //           ),
                    //         )
                    //         .toList() ??
                    //     [],
                    );
              },
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: IgnorePointer(
            ignoring: true,
            child: CustomDropdownFormField<SpaceTerm>(
              value: termm,
              hintText: 'Select Term',
              onChanged: (v) {},
              // onChanged: (value) {
              //   setState(() {
              //     termId = value.id;
              //   });
              // },
              items: [
                DropdownMenuItem<SpaceTerm>(
                  value: termm,
                  child: Text(
                    termm.name,
                    style: setTextTheme(),
                  ),
                ),
              ],
              // items: spaceTerms
              //     .map(
              //       (term) => DropdownMenuItem(
              //         value: term,
              //         child: Text(
              //           term.name,
              //           style: setTextTheme(),
              //         ),
              //       ),
              //     )
              //     .toList(),
            ),
          ),
        ),
        CustomDropdownFormField(
          hintText: 'Select Class',
          iconSize: 20,
          // value: selectedClass,
          onChanged: (value) {
            setState(() {
              selectedClass = value;
selectedAssessment = null;
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

                List<String> subjectIds = selectedClassModel.subjectDetails
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
          type: selectedAssessment?.type ?? '');
    
          },
          items: spaceSubject.expand((classGroup) {
            return classGroup.classes.map((classModel) {
              String classDisplayName =
                  "${classGroup.name} - ${classModel.name}";
              return DropdownMenuItem<String>(
                value: classModel.id,
                // value: classGroup.id,
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
              );
            });
          }).toList(),
        ),
        SizedBox(height: 20.h),
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
                      });
                      Provider.of<ResultProvider>(context, listen: false)
                          .getStudentsReport(
                        spaceId: widget.spaceId,
                        context: context,
                        classId: selectedClass!,
                        subjectId: subjectIDs,
                        assessmentId: v?.assessmentId,
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
                          color: selectedClass == null ? whiteShades[3] : null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }),
        // SizedBox(height: 20.h),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Flexible(
        //       child: Text(
        //         'Do you want to notify users when a  result is published',
        //         style: setTextTheme(
        //           fontSize: 14.sp,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 24,
        //       child: Transform.scale(
        //         scale: 0.9,
        //         child: Switch(
        //           value: isPublished,
        //           trackOutlineColor:
        //               WidgetStateProperty.all(Colors.transparent),
        //           onChanged: (value) {
        //             setState(() {
        //               isPublished = value;
        //             });
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(height: 20.h),
        // if (isPublished == true)
        //   CustomDropdownFormField(
        //     title: 'Select audience',
        //     hintText: 'Select audience',
        //     value: selectedAudience,
        //     onChanged: (value) {
        //       if (selectedClass != null) {
        //         setState(() {
        //           selectedAudience = value as String;
        //         });
        //       }
        //     },
        //     items: audience
        //         .map(
        //           (audience) => DropdownMenuItem(
        //             value: audience,
        //             child: Text(
        //               audience,
        //               style: setTextTheme(
        //                 color: selectedClass == null ? whiteShades[3] : null,
        //               ),
        //             ),
        //           ),
        //         )
        //         .toList(),
        //   ),
        Spacer(),
        Consumer<ResultProvider>(
          builder: (context, resultProvider, _) {
            return Buttons(
              text: resultProvider.isLoadingStateTwo
                  ? 'Publishing...'
                  : 'Publish Result',
              onTap: resultProvider.isLoadingStateTwo
                  ? () {}
                  : () {
                      print(' ass${selectedAssessment?.assessmentId}');
                      if (selectedAssessment != null && mounted) {
                        resultProvider.publish(
                          context: context,
                          spaceId: widget.spaceId,
                          assessmentId: [
                            selectedAssessment?.assessmentId ?? ''
                          ],
                          classId: selectedClass ?? '',
                          termId: termId,
                          sessionId: sessionId ?? '',
                        );
                      }
                    },
              isLoading: resultProvider.isLoadingStateTwo,
            );
          },
        )
      ],
    );
  }
}
