import 'dart:developer';

import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart' show ClassGroup, ClassModel;
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    show BasicAssessment, SpaceSession, Student;
import 'package:cloudnottapp2/src/data/models/exam_session_model.dart'
    show SubjectDetail;
import 'package:cloudnottapp2/src/data/models/user_model.dart' show SpaceTerm;
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart'
    show LessonNotesProvider;
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/result_view_screen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart'
    show SkeletonListView;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPageView extends StatefulWidget {
  final TabController resultTabController;

  const ResultPageView({
    Key? key,
    required this.resultTabController,
  }) : super(key: key);

  @override
  State<ResultPageView> createState() => _ResultPageViewState();
}

class _ResultPageViewState extends State<ResultPageView> {
  // For student search functionality
  final TextEditingController _searchController = TextEditingController();
  List<Student> _filteredStudents = [];

  // Selected values
  List<String> _subjectIDs = [];
  List<SubjectDetail>? _selectedSubjects;
  BasicAssessment? _selectedAssessment;
  String? sessionId;
  String? termId;
  String userRole = '';
  @override
  void initState() {
    super.initState();
    final role =
        localStore.get('role', defaultValue: context.read<UserProvider>().role);
         userRole = role;
    // Initialize filtered students with all students
    Provider.of<ResultProvider>(context, listen: false).clearFilteredStudents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _filteredStudents = context.read<ResultProvider>().students;
      });

      // Add listener to search controller
      _searchController.addListener(_filterStudents);
    });
    widget.resultTabController.addListener(() {
      if (widget.resultTabController.index != 0) {
        setState(() {
          _filteredStudents = [];
        });
        Provider.of<ResultProvider>(context, listen: false)
            .clearFilteredStudents();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStudents);
    _searchController.dispose();
    _filteredStudents = [];
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Provider.of<ResultProvider>(context).clearFilteredStudents();
    // setState(() {
    //   _filteredStudents = [];
    // });

    final resultProvider = Provider.of<ResultProvider>(context);
    _filteredStudents = resultProvider.students;
  }

  // Filter students based on search query
  void _filterStudents() {
    final resultProvider = context.read<ResultProvider>();
    final query = _searchController.text;

    setState(() {
      if (query.isEmpty) {
        _filteredStudents = resultProvider.students;
      } else {
        _filteredStudents = resultProvider.students
            .where((student) =>
                student.firstName
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  String? selectedClass;
    ClassModel? selectedClassMod;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
  builder: (context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.010), // 4% padding left & right
      width: double.infinity,
      child: TabBar(
        controller: widget.resultTabController,
        isScrollable: false, // keep tabs fixed
        labelPadding: EdgeInsets.zero, // spacing inside each tab
        labelColor: blueShades[0],
        unselectedLabelColor:
            ThemeProvider().isDarkMode ? whiteShades[0] : darkShades[0],
        indicatorColor: blueShades[0],
        tabs: const [
          Tab(text: 'Student Result'),
          Tab(text: 'class broadsheet'),
          Tab(text: 'Student Broadsheet'),
        ],
      ),
    );
  },
)
,
        // TabBar(
        //   controller: widget.resultTabController,
        //   labelPadding: EdgeInsets.symmetric(horizontal: 1.w),
        //   labelColor: blueShades[0],
        //   unselectedLabelColor:
        //       ThemeProvider().isDarkMode ? whiteShades[0] : darkShades[0],
        //   indicatorColor: blueShades[0],
        //   tabs: const [
        //     Tab(text: 'Check Result'),
        //     Tab(text: 'Broadsheet'),
        //     Tab(text: 'Class Broadsheet'),
        //   ],
        // ),
        SizedBox(height: 20.h),
        Expanded(
          child: TabBarView(
            controller: widget.resultTabController,
            children: [
              _buildCheckResult(),
              _broadSheetBuild(),
              _broadSheetBuild(),
              // _classBroadsheetBuild(),
            ],
          ),
        ),
      ],
    );
  }

Widget _buildCheckResult() {
  final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
  final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
  final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ?? '';
  final spaceSubject = spaceSubjectRaw.toSet().toList();

  List<ClassGroup> filteredClassGroups;
  if (userRole == 'admin') {
    filteredClassGroups = spaceSubject;
  } else {
    filteredClassGroups = spaceSubject.map((classGroup) {
      final filteredClasses = classGroup.classes.where((classModel) {
        return classModel.subjectDetails.any((subject) {
          return subject.teacher?.user?.id == currentUserId;
        });
      }).map((classModel) {
        final filteredSubjects = classModel.subjectDetails.where((subject) {
          return subject.teacher?.user?.id == currentUserId;
        }).toList();
        return classModel.copyWith(subjectDetails: filteredSubjects);
      }).toList();

      return filteredClasses.isNotEmpty
          ? classGroup.copyWith(classes: filteredClasses)
          : null;
    }).whereType<ClassGroup>().toList();
  }

  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Session & Term Dropdowns
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
                              ?.map((session) => DropdownMenuItem<SpaceSession>(
                                    value: session,
                                    child: SizedBox(
                                      width: 100.w,
                                      child: Text(
                                        session.session,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ))
                              .toList() ??
                          [],
                    );
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomDropdownFormField<SpaceTerm>(
                  hintText: 'Select Term',
                  onChanged: (value) {
                    setState(() {
                      termId = value.id;
                    });
                  },
                  items: spaceTerms
                      .map((term) => DropdownMenuItem(
                            value: term,
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                term.name,
                                style: setTextTheme(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          /// Class Selector
          Consumer<ResultProvider>(
            builder: (context, value, _) {
              return CustomDropdownFormField<String>(
                hintText: 'Select Class',
                value: filteredClassGroups
                        .expand((group) => group.classes)
                        .any((c) => c.id == selectedClassMod?.id)
                    ? selectedClass
                    : null,
                onChanged: (value) {
                  _onClassSelected(value);
                },
                items: filteredClassGroups.expand((classGroup) {
                  return classGroup.classes.map((classModel) {
                    return DropdownMenuItem<String>(
                      value: classModel.id,
                      child: SizedBox(
                        width: 200.w,
                        child: Text(
                          "${classGroup.name} - ${classModel.name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    );
                  });
                }).toList(),
              );
            },
          ),
          SizedBox(height: 10.h),

          /// Search Field (only show when class is selected)
          if (selectedClass != null) ...[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Students',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
            SizedBox(height: 10.h),
          ],

          /// Student List (only show when class is selected)
          if (selectedClass != null)
            Consumer<ResultProvider>(
              builder: (context, value, _) {
                if (value.isLoading) {
                  return SizedBox(height: 100, child: SkeletonListView());
                }

                final studentsToShow = _filteredStudents.isEmpty &&
                        _searchController.text.isEmpty
                    ? value.students
                    : _filteredStudents;

                if (studentsToShow.isEmpty) {
                  return Center(
                    child: Text(
                      'No students found',
                      style: setTextTheme(fontSize: 16.sp),
                    ),
                  );
                }

                return Column(
                  children: List.generate(
                    studentsToShow.length,
                    (index) => Column(
                      children: [
                        _studentWidget(
                          context: context,
                          studentResultmodel: studentsToShow[index],
                        ),
                        if (index < studentsToShow.length - 1) Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    ),
  );
}

/// Handle class selection
void _onClassSelected(String? classId) {
  if (classId == null) return;

  context.read<ResultProvider>().clearFilteredStudents();
  setState(() {
    selectedClass = classId;
  });

  // Fetch form teacher
  Provider.of<ResultProvider>(context, listen: false).getFormTeacher(
    context: context,
    spaceId: context.read<UserProvider>().spaceId,
    classId: classId,
  );

  // Fetch students for the selected class
  _fetchStudentsForClass(classId);
}

/// Fetch students for selected class
void _fetchStudentsForClass(String classId) {
  Provider.of<ResultProvider>(context, listen: false).getStudentAssessments(
    context: context,
    spaceId: context.read<UserProvider>().spaceId,
    classId: classId,
  );
}

/// Refactored student widget - now shows assessment selection on tap
Widget _studentWidget({
  required BuildContext context,
  required Student studentResultmodel,
}) {
  return GestureDetector(
    onTap: () {
      _onStudentSelected(studentResultmodel);
    },
    child: Container(
      width: double.infinity,
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
                  image: FadeInImage(
                    placeholder: AssetImage('assets/app/profile_picture1.png'),
                    image: NetworkImage(
                      studentResultmodel.user?.profileImageUrl ??
                          'assets/app/profile_picture1.png',
                    ),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/app/profile_picture1.png');
                    },
                    fit: BoxFit.cover,
                  ).image,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "${studentResultmodel.user?.firstName} ${studentResultmodel.user?.lastName}",
                style: setTextTheme(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  lineHeight: 0.8,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    ),
  );
}

/// Handle student selection - show assessment bottom sheet
void _onStudentSelected(Student student) {
  // First, fetch assessments for the selected class and term
  if (termId == null) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: 'Please select a term first',
      ),
    );
    return;
  }

  Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
    context: context,
    spaceId: context.read<UserProvider>().spaceId,
    termId: termId ?? '',
    classId: selectedClass ?? '',
    type: '',
  );

  _showAssessmentBottomSheet(context, student);
}

/// Show assessment selection bottom sheet
void _showAssessmentBottomSheet(BuildContext context, Student student) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Consumer<ResultProvider>(
        builder: (context, resultProvider, _) {
          final assessments = resultProvider.assess;

          if (assessments.isEmpty) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assessment_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No assessments available',
                      style: setTextTheme(fontSize: 16.sp),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please create an assessment for this class and term',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select Assessment for ${student.user?.firstName} ${student.user?.lastName}',
                        style: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemCount: assessments.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final assessment = assessments[index];
                    return ListTile(
                      title: Text(
                        assessment.name ?? 'Unnamed Assessment',
                        style: setTextTheme(fontSize: 14.sp),
                      ),
                     
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        Navigator.pop(context); // Close bottom sheet
                        _navigateToResultScreen(student, assessment);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

/// Navigate to result screen with selected student and assessment
void _navigateToResultScreen(Student student, dynamic assessment) {
  if (termId == null || sessionId == null || selectedClass == null) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: 'Please ensure all required fields are selected',
      ),
    );
    return;
  }

  context.push(ResultViewScreen.routeName, extra: {
    "studentResultModel": student,
    "termId": termId!,
    "sessionId": sessionId!,
    "classId": selectedClass!,
    "assessmentId": assessment.assessmentId ?? '',
    "userId": student.user?.id ?? '',
    "spaceId": context.read<UserProvider>().spaceId,
  });
}

//   Widget _buildCheckResult() {
//     final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
//     final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
//       final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ??''; 
//     final spaceSubject = spaceSubjectRaw.toSet().toList();
//     // List<SubjectDetail>? selectedSubjects;
//     // List<String> subjectIDs = [];
//     // String? selectedClass;
//   List<ClassGroup> filteredClassGroups;
//   if (userRole == 'admin') {
//   filteredClassGroups = spaceSubject;
// } else {
//   filteredClassGroups = spaceSubject.map((classGroup) {
//       // Filter classes within this class group
//       final filteredClasses = classGroup.classes.where((classModel) {
//         // Check if this class has any subjects taught by current teacher
//         return classModel.subjectDetails.any((subject) {
//           return subject.teacher?.user?.id == currentUserId;
//         });
//       }).map((classModel) {
//         // For each qualifying class, filter its subjects
//         final filteredSubjects = classModel.subjectDetails.where((subject) {
//           return subject.teacher?.user?.id == currentUserId;
//         }).toList();
        
//         // Return a copy of the class with only the teacher's subjects
//         return classModel.copyWith(subjectDetails: filteredSubjects);
//       }).toList();
  
//       // Only include class group if it has any filtered classes
//       return filteredClasses.isNotEmpty 
//           ? classGroup.copyWith(classes: filteredClasses)
//           : null;
//     }).whereType<ClassGroup>().toList();
// }

//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.r),
//         ),
//         padding: EdgeInsets.all(10.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // First Row: Session and Term Dropdowns
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   // fit: FlexFit.loose,
//                   child: Consumer<ResultProvider>(
//                     builder: (context, value, _) {
//                       return CustomDropdownFormField<SpaceSession>(
//                         hintText: 'Select Session',
//                         onChanged: (value) {
//                           setState(() {
//                             sessionId = value?.id;
//                           });
//                         },
//                         items: value.space?.spaceSessions
//                                 ?.map(
//                                   (session) => DropdownMenuItem<SpaceSession>(
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
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: CustomDropdownFormField<SpaceTerm>(
//                     hintText: 'Select Term',
//                     onChanged: (value) {
//                       setState(() {
//                         termId = value.id;
//                       });
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
//               ],
//             ),
//             SizedBox(height: 10.h),

//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Expanded(
//                   child: Consumer<ResultProvider>(
//                     builder: (context, value, _) {
//                       return CustomDropdownFormField(
//                         hintText: 'Select Class',
//                          value: filteredClassGroups
//           .expand((group) => group.classes)
//           .any((c) => c.id == selectedClassMod?.id)
//       ? selectedClass
//       : null,
//                         onChanged: (value) {
//                           context.read<ResultProvider>().clearFilteredStudents();
//                           setState(() {
//                             selectedClass = value;
//                           });
                          
//                           Provider.of<ResultProvider>(context, listen: false)
//                               .getFormTeacher(
//                                   context: context,
//                                   spaceId: context.read<UserProvider>().spaceId,
//                                   classId: selectedClass ?? '');
//                                      Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
//       spaceId: context.read<UserProvider>().spaceId,
//       context: context,
//       termId: termId ?? '',
//       classId: selectedClass ?? '',
//       type:  '',
//     );
//                         },
//                         // items: spaceSubject
//                      items: filteredClassGroups.expand((classGroup) {
//                           return classGroup.classes.map((classModel) {
//                             return DropdownMenuItem<String>(
//                                 value: classModel.id,
//                                 child: SizedBox(
//                                   width: 100.w,
//                                   child: Text(
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       softWrap: true,
//                                       "${classGroup.name} - ${classModel.name}"),
//                                 ));
//                           });
//                         }).toList(),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: Consumer<ResultProvider>(
//                     builder: (context, value, _) {
//                       if (_selectedAssessment != null &&
//                           !value.assess.contains(_selectedAssessment)) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           setState(() {
//                             _selectedAssessment = null;
//                           });
//                         });
//                       }
//                       return CustomDropdownFormField(
//                         hintText: 'Select Assessment',
//                         onChanged: (value) {
//                           log('message $selectedClass');
//                           Provider.of<ResultProvider>(context, listen: false)
//                               .getStudentAssessments(
//                                   context: context,
//                                   spaceId: context.read<UserProvider>().spaceId,
//                                   classId: selectedClass ?? '');
//                           setState(() {
//                             _selectedAssessment = value;
//                           });
//                         },
//                         items: value.assess
//                             .map(
//                               (assessment) => DropdownMenuItem(
//                                   value: assessment,
//                                   child: SizedBox(
//                                     width: 100.w,
//                                     child: Text(
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       softWrap: true,
//                                       assessment.name ?? '',
//                                       style: setTextTheme(),
//                                     ),
//                                   )),
//                             )
//                             .toList(),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.h),

//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search Students',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: 10.h),
//               ),
//             ),
//             SizedBox(height: 10.h),

//             Consumer<ResultProvider>(
//               builder: (context, value, _) {
//                 log('fff ${value.students}');
//                 if (value.isLoading) {
//                   return SizedBox(height: 100, child: SkeletonListView());
//                 }
//                 final studentsToShow =
//                     _filteredStudents.isEmpty && _searchController.text.isEmpty
//                         ? value.students
//                         : _filteredStudents;

//                 return Column(
//                   children: List.generate(
//                     studentsToShow.length,
//                     (index) => Column(
//                       children: [
//                         _studentWidget(
//                           context: context,
//                           studentResultmodel: studentsToShow[index],
//                           termId: termId ?? '',
//                           sessionId: sessionId ?? '',
//                           classId: selectedClass ?? '',
//                           assessmentId: _selectedAssessment?.assessmentId,
//                         ),
//                         if (index < studentsToShow.length - 1) Divider(),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}

_broadSheetBuild() {
  return Container(
    padding: EdgeInsets.all(15.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.r),
      color: Colors.grey[200],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.web, size: 50.w, color: Colors.blueAccent),
        SizedBox(height: 15.h),
        Text(
          "This feature is available on the web.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Please visit our web platform to access the broadsheet.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: 20.h),
        Buttons(
          text: 'Go to Web Version',
          fontSize: 15.sp,
          boxColor: Colors.blue,
          isLoading: false,
          onTap: () {
            // Open web link
            launchUrl(Uri.parse("https://cloudnottapp2-v3-webapp.vercel.app"));
          },
        ),
      ],
    ),
  );
}

// _broadSheetBuild() {
//   return Expanded(
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(
//           5.r,
//         ),
//         // color: ThemeProvider().isDarkMode ? blueShades[15] : redShades[5],
//       ),
//       child: Column(
//         spacing: 10.h,
//         children: [
//           CustomDropdownFormField(
//             hintText: 'Select Session',
//             onChanged: (value) {},
//             items: ['2025/2026']
//                 .map(
//                   (session) => DropdownMenuItem(
//                     value: session,
//                     child: Text(session),
//                   ),
//                 )
//                 .toList(),
//           ),
//           CustomDropdownFormField(
//             hintText: 'Select Term',
//             onChanged: (value) {},
//             items: ['First Term', 'Second Term', 'Third Term']
//                 .map(
//                   (term) => DropdownMenuItem(
//                     value: term,
//                     child: Text(
//                       term,
//                       style: setTextTheme(),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//           // Students cannot select classes, the dropdown is disabled for students
//           CustomDropdownFormField(
//             hintText: 'Select Class',
//             onChanged: (value) {},
//             items: ['JSS 1 - A', 'JSS 1 - B', 'JSS 2']
//                 .map(
//                   (classes) => DropdownMenuItem(
//                     value: classes,
//                     child: Text(
//                       classes,
//                       style: setTextTheme(),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//           CustomDropdownFormField(
//             hintText: 'Select assessment',
//             onChanged: (value) {},
//             items: ['General Assessment']
//                 .map(
//                   (assessment) => DropdownMenuItem(
//                     value: assessment,
//                     child: Text(
//                       assessment,
//                       style: setTextTheme(),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//           Spacer(),
//           Buttons(
//             text: 'View broadsheet',
//             fontSize: 15.sp,
//             boxColor: blueShades[0],
//             isLoading: false,
//             onTap: () {},
//           ),
//         ],
//       ),
//     ),
//   );
// }

_classBroadsheetBuild() {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.r,
        ),
        // color: ThemeProvider().isDarkMode ? blueShades[15] : redShades[5],
      ),
      child: Column(
        spacing: 10.h,
        children: [
          CustomDropdownFormField(
            hintText: 'Select Session',
            onChanged: (value) {},
            items: ['2025/2026']
                .map(
                  (session) => DropdownMenuItem(
                    value: session,
                    child: Text(session),
                  ),
                )
                .toList(),
          ),
          CustomDropdownFormField(
            hintText: 'Select Term',
            onChanged: (value) {},
            items: ['First Term', 'Second Term', 'Third Term']
                .map(
                  (term) => DropdownMenuItem(
                    value: term,
                    child: Text(
                      term,
                      style: setTextTheme(),
                    ),
                  ),
                )
                .toList(),
          ),
          // Students cannot select classes, the dropdown is disabled for students
          CustomDropdownFormField(
            hintText: 'Select Class',
            onChanged: (value) {},
            items: ['JSS 1 - A', 'JSS 1 - B', 'JSS 2']
                .map(
                  (classes) => DropdownMenuItem(
                    value: classes,
                    child: Text(
                      classes,
                      style: setTextTheme(),
                    ),
                  ),
                )
                .toList(),
          ),
          CustomDropdownFormField(
            hintText: 'Select assessment',
            onChanged: (value) {},
            items: ['General Assessment']
                .map(
                  (assessment) => DropdownMenuItem(
                    value: assessment,
                    child: Text(
                      assessment,
                      style: setTextTheme(),
                    ),
                  ),
                )
                .toList(),
          ),
          Spacer(),
          Buttons(
            text: 'View Class Broadsheet',
            fontSize: 15.sp,
            onTap: () {},
            isLoading: false,
          ),
        ],
      ),
    ),
  );
}

Widget _studentWidget({
  required BuildContext context,
  required Student studentResultmodel,
  required String termId,
  required String sessionId,
  required String classId,
  required String? assessmentId,
}) {
  return GestureDetector(
    onTap: () {
  
      if (assessmentId == null) {
       
         showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: 'No assessment found for this student',
          ),
        );
        return;
      }
      context.push(ResultViewScreen.routeName, extra: {
        "studentResultModel": studentResultmodel,
        "termId": termId,
        "sessionId": sessionId,
        "classId": classId,
        "assessmentId": assessmentId ?? '',
        "userId": studentResultmodel.user?.id ?? '',
        // "userId": context.read<UserProvider>().user?.id ?? '',
        "spaceId": context.read<UserProvider>().spaceId
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
                  image: FadeInImage(
                    placeholder: AssetImage('assets/app/profile_picture1.png'),
                    image: NetworkImage(
                      studentResultmodel.user?.profileImageUrl ??
                          'assets/app/profile_picture1.png',
                    ),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/app/profile_picture1.png');
                    },
                    fit: BoxFit.cover,
                  ).image,
                ),
             
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "${studentResultmodel.user?.firstName} ${studentResultmodel.user?.lastName}",
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                lineHeight: 0.8,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    ),
  );
}

class StudentResultPage extends StatefulWidget {
  final String spaceId;
  const StudentResultPage({super.key, required this.spaceId});

  @override
  State<StudentResultPage> createState() => _StudentResultPageState();
}
class _StudentResultPageState extends State<StudentResultPage> {
  BasicAssessment? _selectedAssessment;
  String? sessionId;
  String? termId;
  String? selectedClass;

  @override
  void initState() {
    super.initState();

    // Ensure Provider data is loaded after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = context.read<UserProvider>();
      final classInfo = userData.singleSpace?.classInfo;

      // Store the selected class group ID initially
      if (classInfo != null) {
        setState(() {
          selectedClass = classInfo.classGroup?.id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
    final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
    final spaceSubject = spaceSubjectRaw.toSet().toList();
    final userProvider = context.watch<UserProvider>();

    final studentClassGroup = userProvider.singleSpace?.classInfo?.classGroup;
    final studentClassId = userProvider.singleSpace?.classInfo?.id;
    log('spaceSubjectRaw: ${spaceSubjectRaw.map((e) => e.id).toList()}');
log('spaceSubjectRaw IDs: ${spaceSubjectRaw.map((e) => e.id).toList()}');
log('Matching group: ${spaceSubjectRaw.firstWhereOrNull((e) => e.id == studentClassGroup?.id)}');

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // SESSION & TERM DROPDOWNS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Session Dropdown
                Flexible(
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
                                    child: SizedBox(
                                      width: 80.w,
                                      child: Text(
                                        session.session,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                )
                                .toList() ??
                            [],
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                // Term Dropdown
                Expanded(
                  child: CustomDropdownFormField<SpaceTerm>(
                    hintText: 'Select Term',
                    onChanged: (value) {
                      setState(() {
                        termId = value.id;
                      });
                      // Fetch assessments when term is selected
                      Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
                        spaceId: context.read<UserProvider>().spaceId,
                        context: context,
                        termId: termId ?? '',
                        classId: studentClassId ?? '',
                        type: '',
                      );
                    },
                    items: spaceTerms.map(
                      (term) => DropdownMenuItem(
                        value: term,
                        child: SizedBox(
                          width: 100.w,
                          child: Text(
                            term.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                            style: setTextTheme(),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // STUDENT CLASS DROPDOWN (READ-ONLY)
            Row(
              children: [
                // Expanded(
                //   child: Consumer<ResultProvider>(
                //     builder: (context, value, _) {
                //       // Debug logging to trace the logic
                //       log('Student class group ID: ${studentClassGroup?.id}');
                //       log('Student class ID: $studentClassId');

                //       final matchingGroups = spaceSubjectRaw.where((group) {
                //         final match = group.id == studentClassGroup?.id;
                //         log('Checking group ${group.id} == ${studentClassGroup?.id} -> $match');
                //         return match;
                //       }).toList();

                //       final dropdownItems = matchingGroups.expand((group) {
                //         final seen = <String>{};
                //         return group.classes.where((classModel) {
                //           return seen.add(classModel.id);
                //         }).map((classModel) {
                //           return DropdownMenuItem<String>(
                //             value: classModel.id,
                //             child: SizedBox(
                //               width: 100.w,
                //               child: Text(
                //                 "${group.name} - ${classModel.name}",
                //                 overflow: TextOverflow.ellipsis,
                //                 maxLines: 1,
                //                 softWrap: true,
                //               ),
                //             ),
                //           );
                //         });
                //       }).toList();

                //       final isValidSelection = dropdownItems.any((item) => item.value == studentClassId);
                //       final dropdownValue = isValidSelection ? studentClassId : null;

                //       return IgnorePointer(
                //         ignoring: true,
                //         child: CustomDropdownFormField(
                //           hintText: 'Select Class',
                //           value: dropdownValue,
                //           onChanged: (_) {},
                //           items: dropdownItems,
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // SizedBox(width: 10.w),
                // ASSESSMENT DROPDOWN
                Expanded(
                  child: Consumer<ResultProvider>(
                    builder: (context, value, _) {
                      if (_selectedAssessment != null && !value.assess.contains(_selectedAssessment)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _selectedAssessment = null;
                          });
                        });
                      }
                      return CustomDropdownFormField(
                        hintText: 'Select Assessment',
                        onChanged: (value) {
                          Provider.of<ResultProvider>(context, listen: false).getStudentAssessments(
                            context: context,
                            spaceId: context.read<UserProvider>().spaceId,
                            classId: studentClassId ?? '',
                          );
                          setState(() {
                            _selectedAssessment = value;
                          });
                        },
                        items: value.assess.map((assessment) {
                          return DropdownMenuItem(
                            value: assessment,
                            child: SizedBox(
                              width: 100.w,
                              child: Text(
                                assessment.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                                style: setTextTheme(),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // RESULT VIEW
            Consumer<ResultProvider>(
              builder: (context, value, _) {
                if (value.isLoading) {
                  return SizedBox(height: 100, child: SkeletonListView());
                }

                final studentsToShow = value.students
                    .where((e) => e.user?.id == context.read<UserProvider>().user?.id)
                    .toList();

                return Column(
                  children: List.generate(
                    studentsToShow.length,
                    (index) => Column(
                      children: [
                        _studentWidget(
                          context: context,
                          studentResultmodel: studentsToShow[index],
                          termId: termId ?? '',
                          sessionId: sessionId ?? '',
                          classId: selectedClass ?? '',
                          assessmentId: _selectedAssessment?.assessmentId,
                        ),
                        if (index < studentsToShow.length - 1) Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class _StudentResultPageState extends State<StudentResultPage> {
//   BasicAssessment? _selectedAssessment;
//   String? sessionId;
//   String? termId;
//   String? selectedClass;


// @override
// void initState() {
//   super.initState();
  
//   // Initialize with a post-frame callback to ensure Provider data is loaded
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final userData = context.read<UserProvider>();
//     final classInfo = userData.singleSpace?.classInfo;
    
//     if (classInfo != null) {
//       setState(() {
//         selectedClass = classInfo.classGroup?.id;
//       });
//     }
//   });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
//     final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
//     final spaceSubject = spaceSubjectRaw.toSet().toList();
//    final userProvider = context.watch<UserProvider>();
// final studentClassGroup = userProvider.singleSpace?.classInfo?.classGroup;
// final studentClassId = userProvider.singleSpace?.classInfo?.id;

// // Step 1: Build dropdown items from the student’s class group
// final dropdownItems = spaceSubject
//     .where((group) => group.id == studentClassGroup?.id)
//     .expand((group) {
//       final seen = <String>{};
//        log('vvfvfvfvfvf $group');
//       return group.classes
//           .where((classModel) => seen.add(classModel.id)) // Deduplicate
//           .map((classModel) {
           
//         return DropdownMenuItem<String>(
//           value: classModel.id,
//           child: Text(
//             "${group.name} - ${classModel.name}",
//             overflow: TextOverflow.ellipsis,
//           ),
//         );
//       });
//     }).toList();

// // Step 2: Check if student’s class ID is in the list
// final isValidSelection = dropdownItems.any((item) => item.value == studentClassId);
// final dropdownValue = isValidSelection ? studentClassId : null;
// log('hfhrhhf $studentClassId $dropdownValue $spaceSubject ggf ${studentClassGroup?.id}');
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.r),
//         ),
//         padding: EdgeInsets.all(10.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // First Row: Session and Term Dropdowns
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Consumer<ResultProvider>(
//                     builder: (context, value, _) {
//                       return CustomDropdownFormField<SpaceSession>(
//                         hintText: 'Select Session',
//                         onChanged: (value) {
//                           setState(() {
//                             sessionId = value?.id;
//                           });
//                         },
//                         items: value.space?.spaceSessions
//                                 ?.map(
//                                   (session) => DropdownMenuItem<SpaceSession>(
//                                     value: session,
//                                     child: SizedBox(
//                                       width: 80.w,
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
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: CustomDropdownFormField<SpaceTerm>(
//                     hintText: 'Select Term',
//                     onChanged: (value) {
//                       setState(() {
//                         termId = value.id;
//                       });
//                                    Provider.of<ResultProvider>(context, listen: false).getBasicAssessments(
//       spaceId: context.read<UserProvider>().spaceId,
//       context: context,
//       termId: termId ?? '',
//       classId: studentClassId ?? '',
//       type:  '',
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
//               ],
//             ),
//             SizedBox(height: 10.h),

//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Expanded(
//                   child: Consumer<ResultProvider>(
//                     builder: (context, value, _) {
//                       return IgnorePointer(
//                          ignoring: true,
//                         child: CustomDropdownFormField(
//                           hintText: 'Select Class',
//                          value: dropdownValue,
//                           onChanged: (value) {},
                         
//                           items: spaceSubject
//                               .where((classGroup) => classGroup.id == studentClassGroup?.id)
//                           .expand((classGroup) {
//                             return classGroup.classes.map((classModel) {
//                               return DropdownMenuItem<String>(
//                                   value: classModel.id,
//                                   child: SizedBox(
//                                     width: 100.w,
//                                     child: Text(
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         softWrap: true,
//                                         "${classGroup.name} - ${classModel.name}"),
//                                   ));
//                             });
//                           }).toList(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: Consumer<ResultProvider>(
//                     builder: (context, value, _) {
//                       if (_selectedAssessment != null &&
//                           !value.assess.contains(_selectedAssessment)) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           setState(() {
//                             _selectedAssessment = null;
//                           });
//                         });
//                       }
//                       return CustomDropdownFormField(
//                         hintText: 'Select Assessment',
//                         onChanged: (value) {
//                           log('message $selectedClass');
//                           Provider.of<ResultProvider>(context, listen: false)
//                               .getStudentAssessments(
//                                   context: context,
//                                   spaceId: context.read<UserProvider>().spaceId,
//                                   classId: studentClassId ?? ''
//                                   //classId: selectedClass ?? ''
//                                   );
//                           setState(() {
//                             _selectedAssessment = value;
//                           });
//                         },
//                         items: value.assess
//                             .map(
//                               (assessment) => DropdownMenuItem(
//                                   value: assessment,
//                                   child: SizedBox(
//                                     width: 100.w,
//                                     child: Text(
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       softWrap: true,
//                                       assessment.name ?? '',
//                                       style: setTextTheme(),
//                                     ),
//                                   )),
//                             )
//                             .toList(),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.h),
//                   Consumer<ResultProvider>(
//               builder: (context, value, _) {
//                 log('fff ${value.students}');
//                 if (value.isLoading) {
//                   return SizedBox(height: 100, child: SkeletonListView());
//                 }
//                 // final studentsToShow =
//                 //     _filteredStudents.isEmpty && _searchController.text.isEmpty
//                 //         ? value.students
//                 //         : _filteredStudents;
//                 final studentsToShow = value.students
//     .where((e) => e.user?.id == context.read<UserProvider>().user?.id)
//     .toList();

//                 return Column(
//                   children: List.generate(
//                   studentsToShow.length,
//                     (index) => Column(
//                       children: [
//                         _studentWidget(
//                           context: context,
//                           studentResultmodel:  studentsToShow[index],
//                           termId: termId ?? '',
//                           sessionId: sessionId ?? '',
//                           classId: selectedClass ?? '',
//                           assessmentId: _selectedAssessment?.assessmentId,
//                         ),
//                         if (index < value.students.length - 1) Divider(),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
