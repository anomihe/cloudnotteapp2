import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/homework_mockdata.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_widget/assessment_box.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    as space show BasicAssessment, SpaceSession, Student;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/exam_home_provider.dart' show ExamHomeProvider;
import '../../../data/providers/user_provider.dart';

class TeacherEntryScreen extends StatefulWidget {
  final String spaceId;
  const TeacherEntryScreen({super.key, required this.spaceId});

  static const String routeName = '/teacher_entry_screen';

  @override
  State<TeacherEntryScreen> createState() => _TeacherEntryScreenState();
}

class _TeacherEntryScreenState extends State<TeacherEntryScreen> {
 bool _isInit = true;
  String termId = '';
  // String classGroupId = '';
   List<String> classGroupId = [];
  String classSessionId = '';
  List<String> grpId = [];

  @override
  void initState() {
     Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
      context: context,
      alias: context.read<UserProvider>().alias,
    );
    super.initState();
  }

//  _initializeData();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initializeData();
      _isInit = false;
    }
  }

  Future<void> _initializeData() async {
    final lessonNotesProvider =
        Provider.of<LessonNotesProvider>(context, listen: false);
    final userProvider = context.read<UserProvider>();

    // Fetch class group data
    await lessonNotesProvider.fetchClassGroup(
      context: context,
      spaceId: widget.spaceId,
    );

    // Safely access group data
    
    if (lessonNotesProvider.group != null &&
        lessonNotesProvider.group!.isNotEmpty) {
      // grpId = lessonNotesProvider.group!.first.id;
        grpId = lessonNotesProvider.group.map((e) => e.id).toList();
    } else {
      log('No class groups available');
    }

    final role = localStore.get('role', defaultValue: '');

    // Ensure values are never null
    classSessionId = localStore.get('sessionId',
            defaultValue: userProvider.classSessionId ?? '') ??
        '';

    termId =
        localStore.get('termId', defaultValue: userProvider.termId ?? '') ?? '';

    // classGroupId = userProvider.singleSpace?.assignedClass?.isNotEmpty == true
    //     ? userProvider.singleSpace!.assignedClass!.first.classGroup?.id ?? ''
    //     : '';
classGroupId =grpId
        ;
    log('our day grpid: $classGroupId, term: $termId, space: ${widget.spaceId}, sessid: $classSessionId');

    await Provider.of<ExamHomeProvider>(context, listen: false)
        .getMyTeachersGroup(
      context: context,
      spaceId: widget.spaceId,
      termId: termId,
      classGroupId: role == 'admin' ? [] : [...classGroupId],
      sessionId: classSessionId,
    );
  }

  String id = '';
   String? sessionId;
   String? selectedClass;
  SpaceTerm? selectedTerm;
  @override
  Widget build(BuildContext context) {
        final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ??''; 
    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
  final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
  final spaceSubject = spaceSubjectRaw.toSet().toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Computer Based Test',
            style: setTextTheme(fontSize: 24.sp, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//   child: Consumer<ResultProvider>(
//     builder: (context, value, _) {
//       return CustomDropdownFormField<String>(
//         hintText: 'Select Class',
//         onChanged: (value) {
//           setState(() {
//             selectedClass = value; // Set to classGroup.id
//           });
//           // Optional: Call provider methods if needed
     
//         },
//         items: spaceSubject
//  .where((classGroup) => 
//       classGroup.classes.any((classItem) => 
//         classItem.subjectDetails.any((subject) => 
//           subject.teacher?.user?.id == currentUserId
//         )
//       )
//     ).map((classGroup) {
//           return DropdownMenuItem<String>(
//             value: classGroup.id,
//             child: SizedBox(
//               width: 100.w,
//               child: Text(
//                 classGroup.name,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 softWrap: true,
//               ),
//             ),
//           );
//         }).toList(),
//       );
//     },
//   ),
// ),
         
    //        SizedBox(width: 10.w),
    //             Expanded(
    //               // fit: FlexFit.loose,
    //               child: Consumer<ResultProvider>(
    //                 builder: (context, value, _) {
    //                   return CustomDropdownFormField<space.SpaceSession>(
    //                     hintText: 'Select Session',
    //                     onChanged: (value) {
    //                       setState(() {
    //                         sessionId = value?.id;
    //                       });
    //                       Provider.of<ExamHomeProvider>(context, listen: false)
    //     .getMyTeachersGroup(
    //   context: context,
    //   spaceId: widget.spaceId,
    //   termId: termId,
    //   classGroupId: selectedClass != null ? [selectedClass!] : [],
    //   sessionId: sessionId??'',
    // );
  
    //                     },
    //                     items: value.space?.spaceSessions
    //                             ?.map(
    //                               (session) => DropdownMenuItem<space.SpaceSession>(
    //                                 value: session,
    //                                 child: SizedBox(
    //                                   width: 100.w,
    //                                   child: Text(
    //                                     session.session,
    //                                     overflow: TextOverflow.ellipsis,
    //                                     maxLines: 1,
    //                                     softWrap: true,
    //                                   ),
    //                                 ),
    //                               ),
    //                             )
    //                             .toList() ??
    //                         [],
    //                   );
    //                 },
    //               ),
    //             ),
               
             
    //           ],
    //         ),
    //       SizedBox(height: 10.h),
    //   Row(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.center, 
    //     children: [
    //          Expanded(
    //               child: CustomDropdownFormField<SpaceTerm>(
    //                 hintText: 'Select Term',
    //                 onChanged: (value) {
    //                   setState(() {
    //                     termId = value.id;
    //                   });
    //                            Provider.of<ExamHomeProvider>(context, listen: false)
    //     .getMyTeachersGroup(
    //   context: context,
    //   spaceId: widget.spaceId,
    //   termId: value.id,
    //   classGroupId: selectedClass != null ? [selectedClass!] : [],
    //   sessionId: sessionId??'',
    // );
    //                 },
    //                 items: spaceTerms
    //                     .map(
    //                       (term) => DropdownMenuItem(
    //                         value: term,
    //                         child: SizedBox(
    //                           width: 100.w,
    //                           child: Text(
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 1,
    //                             softWrap: true,
    //                             term.name,
    //                             style: setTextTheme(),
    //                           ),
    //                         ),
    //                       ),
    //                     )
    //                     .toList(),
    //               ),
    //             ),
        
    //     ],
    //   ),
          
          Expanded(
            child: Consumer<ExamHomeProvider>(builder: (context, value, _) {
              if (value.isLoading) {
                return SkeletonListView(
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: SkeletonItem(
                      child: Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (value.examTeacherGroup.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/app/paparazi_image_a.png'),
                      SizedBox(height: 10.h),
                      Text(
                        'No Assessment Available',
                        style: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
            
              return Padding(
                padding: EdgeInsets.all(15.r),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.examTeacherGroup.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              AssessmentBox(
                                homeWorkGroup: value.examTeacherGroup[index],
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AdminEntryScreen extends StatefulWidget {
  final String spaceId;
  const AdminEntryScreen({super.key, required this.spaceId});

  static const String routeName = '/teacher_entry_screen';

  @override
  State<AdminEntryScreen> createState() => _AdminEntryScreenState();
}

class _AdminEntryScreenState extends State<AdminEntryScreen> {
  bool _isInit = true;
  String termId = '';
  // String classGroupId = '';
   List<String> classGroupId = [];
  String classSessionId = '';
  List<String> grpId = [];

  @override
  void initState() {
     Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
      context: context,
      alias: context.read<UserProvider>().alias,
    );
    super.initState();
  }

//  _initializeData();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _initializeData();
      _isInit = false;
    }
  }

  Future<void> _initializeData() async {
    final lessonNotesProvider =
        Provider.of<LessonNotesProvider>(context, listen: false);
    final userProvider = context.read<UserProvider>();

    // Fetch class group data
    await lessonNotesProvider.fetchClassGroup(
      context: context,
      spaceId: widget.spaceId,
    );

    // Safely access group data
    
    if (lessonNotesProvider.group != null &&
        lessonNotesProvider.group!.isNotEmpty) {
      // grpId = lessonNotesProvider.group!.first.id;
        grpId = lessonNotesProvider.group.map((e) => e.id).toList();
    } else {
      log('No class groups available');
    }

    final role = localStore.get('role', defaultValue: '');

    // Ensure values are never null
    classSessionId = localStore.get('sessionId',
            defaultValue: userProvider.classSessionId ?? '') ??
        '';

    termId =
        localStore.get('termId', defaultValue: userProvider.termId ?? '') ?? '';

    // classGroupId = userProvider.singleSpace?.assignedClass?.isNotEmpty == true
    //     ? userProvider.singleSpace!.assignedClass!.first.classGroup?.id ?? ''
    //     : '';
classGroupId =grpId
        ;
    log('our day grpid: $classGroupId, term: $termId, space: ${widget.spaceId}, sessid: $classSessionId');

    await Provider.of<ExamHomeProvider>(context, listen: false)
        .getMyTeachersGroup(
      context: context,
      spaceId: widget.spaceId,
      termId: termId,
      classGroupId: role == 'admin' ? [] : [...classGroupId],
      sessionId: classSessionId,
    );
  }

  String id = '';
   String? sessionId;
   String? selectedClass;
  SpaceTerm? selectedTerm;
  @override
  Widget build(BuildContext context) {
    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
  final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
  final spaceSubject = spaceSubjectRaw.toSet().toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Computer Based Test',
            style: setTextTheme(fontSize: 24.sp, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//   child: Consumer<ResultProvider>(
//     builder: (context, value, _) {
//       return CustomDropdownFormField<String>(
//         hintText: 'Select Class',
//         onChanged: (value) {
//           setState(() {
//             selectedClass = value; // Set to classGroup.id
//           });
//           // Optional: Call provider methods if needed
     
//         },
//         items: spaceSubject.map((classGroup) {
//           return DropdownMenuItem<String>(
//             value: classGroup.id,
//             child: SizedBox(
//               width: 100.w,
//               child: Text(
//                 classGroup.name,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//                 softWrap: true,
//               ),
//             ),
//           );
//         }).toList(),
//       );
//     },
//   ),
// ),
         
//            SizedBox(width: 10.w),
//                 Expanded(
//                   // fit: FlexFit.loose,
//                   child: Consumer<ResultProvider>(
//                     builder: (context, value, _) {
//                       return CustomDropdownFormField<space.SpaceSession>(
//                         hintText: 'Select Session',
//                         onChanged: (value) {
//                           setState(() {
//                             sessionId = value?.id;
//                           });
//                           Provider.of<ExamHomeProvider>(context, listen: false)
//         .getMyTeachersGroup(
//       context: context,
//       spaceId: widget.spaceId,
//       termId: termId,
//       classGroupId: selectedClass != null ? [selectedClass!] : [],
//       sessionId: sessionId??'',
//     );
  
//                         },
//                         items: value.space?.spaceSessions
//                                 ?.map(
//                                   (session) => DropdownMenuItem<space.SpaceSession>(
//                                     value: session,
//                                     child: SizedBox(
//                                       width: 100.w,
//                                       child: Text(
//                                         session.session,
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         softWrap: true,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList() ??
//                             [],
//                       );
//                     },
//                   ),
//                 ),
               
             
//               ],
//             ),
//           SizedBox(height: 10.h),
//       Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center, 
//         children: [
//              Expanded(
//                   child: CustomDropdownFormField<SpaceTerm>(
//                     hintText: 'Select Term',
//                     onChanged: (value) {
//                       setState(() {
//                         termId = value.id;
//                       });
//                                Provider.of<ExamHomeProvider>(context, listen: false)
//         .getMyTeachersGroup(
//       context: context,
//       spaceId: widget.spaceId,
//       termId: value.id,
//       classGroupId: selectedClass != null ? [selectedClass!] : [],
//       sessionId: sessionId??'',
//     );
//                     },
//                     items: spaceTerms
//                         .map(
//                           (term) => DropdownMenuItem(
//                             value: term,
//                             child: SizedBox(
//                               width: 100.w,
//                               child: Text(
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 softWrap: true,
//                                 term.name,
//                                 style: setTextTheme(),
//                               ),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ),
        
//         ],
//       ),
          Expanded(
            child: Consumer<ExamHomeProvider>(builder: (context, value, _) {
              if (value.isLoading) {
                return SkeletonListView(
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: SkeletonItem(
                      child: Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (value.examTeacherGroup.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/app/paparazi_image_a.png'),
                      SizedBox(height: 10.h),
                      Text(
                        'No Assessment Available',
                        style: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              // final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
            
              return Padding(
                padding: EdgeInsets.all(15.r),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.examTeacherGroup.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              AssessmentBox(
                                homeWorkGroup: value.examTeacherGroup[index],
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
