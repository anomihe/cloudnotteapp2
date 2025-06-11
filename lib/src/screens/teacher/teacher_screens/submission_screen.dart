import 'dart:developer';
import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart' show ClassInfo;
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/homework/homework_widget/custom_button.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_stats_screen.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_widget/student_submissions.dart';
import 'package:flutter/material.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart' as grp;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubmissionScreen extends StatefulWidget {
  const SubmissionScreen(
      {super.key,
      // required this.studentModel,
      required this.spaceId,
      required this.examGroupId,
      required this.examId,
      required this.classId});
  final String spaceId;
  final String examGroupId;
  final List<String> examId;
  final String classId;
  // final StudentModel studentModel;

  static const String routeName = '/submission_screen';

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}
class _SubmissionScreenState extends State<SubmissionScreen> {
  String userRole = '';
  String? _selectedClassId; // Store selected class ID at the class level
  
  // Search-related variables
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    userRole = localStore.get('role', defaultValue: context.read<UserProvider>().role);
    
    log('my values ${widget.spaceId} ${widget.classId} ${widget.examGroupId} ${widget.examId}');
    
    // Initial data load
    _loadExamSessions();
    
    // Add listener to search controller
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Separated method to load exam sessions with current filter
  void _loadExamSessions() {
    log('Loading exam sessions with classId: $_selectedClassId');
    Provider.of<ExamHomeProvider>(context, listen: false).getMyExamSession(
      context: context,
      spaceId: widget.spaceId,
      examGroupId: widget.examGroupId,
      examId: widget.examId,
      claseId: _selectedClassId , // Use class-level variable
    );
  }
  
  // Toggle search mode
  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
      } else {
        // Focus on the search field when activated
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  // Custom app bar based on search state
  PreferredSizeWidget _buildAppBar() {
    if (_isSearchActive) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search by student name...',
            border: InputBorder.none,
            hintStyle: setTextTheme(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
          style: setTextTheme(
            fontSize: 16.sp,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _toggleSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      );
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        leading: customAppBarLeadingIcon(context),
        title: Text(
          'Submissions',
          style: setTextTheme(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleSearch,
                  child: SvgPicture.asset('assets/icons/search_icon.svg'),
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () {
                    showClassSelectionDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    width: 30.w,
                    height: 27.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: blueShades[2], width: 1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/lets-icons_filter.svg',
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () {
                    context.push(TeacherStatsScreen.routeName, extra: {
                      "examId": widget.examId.first, 
                      "examGroupId": widget.examGroupId,
                      "spaceId":widget.spaceId
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: 30.w,
                    height: 27.h,
                    decoration: BoxDecoration(
                      color: blueShades[2],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/cil_graph_icon.svg',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  // Filter the exams based on search query
  List<dynamic> _getFilteredExams(List<dynamic> exams) {
    if (_searchQuery.isEmpty) {
      return exams;
    }
    
    return exams.where((exam) {
      // Assuming the student name is in the model
      // Adjust this based on your actual model structure
      final studentName = exam.studentName?.toLowerCase() ?? '';
      final studentLastName = exam.studentLastName?.toLowerCase() ?? '';
      final studentFullName = '$studentName $studentLastName'.toLowerCase();
      
      return studentFullName.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<ExamHomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return SkeletonItem(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 16.h,
                            width: 120.w,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 14.h,
                            width: 80.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 12.h,
                          width: 70.w,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          shape: BoxShape.circle,
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (provider.gotWrittenExam.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/app/paparazi_image_a.png'),
                  SizedBox(height: 60.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "No student has submitted Assessment yet",
                      style: setTextTheme(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    onTap: () {
                      context.pop();
                    },
                    text: 'Okay',
                    textStyle: setTextTheme(
                      fontSize: 15.48.sp,
                      fontWeight: FontWeight.w700,
                      color: whiteShades[0],
                    ),
                    buttonColor: redShades[0],
                  ),
                ],
              ),
            );
          }

          // Apply the search filter to the exams
          final filteredExams = _getFilteredExams(provider.gotWrittenExam);
          
          if (filteredExams.isEmpty && _searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/app/paparazi_image_a.png'),
                  SizedBox(height: 60.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "No matching students found for '${_searchQuery}'",
                      style: setTextTheme(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        if (_isSearchActive) {
                          _toggleSearch();
                        }
                      });
                    },
                    text: 'Clear Search',
                    textStyle: setTextTheme(
                      fontSize: 15.48.sp,
                      fontWeight: FontWeight.w700,
                      color: whiteShades[0],
                    ),
                    buttonColor: redShades[0],
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredExams.length,
            itemBuilder: (context, index) {
              final exam = filteredExams[index];
              return StudentSubmissions(
                model: exam,
                examGroupId: widget.examGroupId,
              );
            },
          );
        },
      ),
    );
  }
  
  void showClassSelectionDialog(BuildContext context) {
    String? selectedClass;
    grp.ClassModel? selectedClassMod;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
        final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
        final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ??''; 
        final spaceSubject = spaceSubjectRaw.toSet().toList();
      
        List<grp.ClassGroup> filteredClassGroups;
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
  }).where((classGroup) => classGroup != null).cast<grp.ClassGroup>().toList();
}
        // if (userRole == 'admin') {
        //   filteredClassGroups = spaceSubject;
        // } else {
        //   filteredClassGroups = spaceSubject.where((classGroup) {
        //     log('Checking ClassGroup: ${classGroup.name} ${classGroup.classes}');

        //     bool classGroupHasCurrentUser = classGroup.classes.any((classModel) {
        //       log('Checking Class: ${classModel.name} ${classModel.subjectDetails.map((e) => e?.teacher?.firstName ?? '').toList()}');

        //       bool classHasSubjectWithTeacher = classModel.subjectDetails.any((subject) {
        //         final teacher = subject.teacher;
        //         final teacherUserId = teacher?.user?.id;

        //         log('    Subject ${subject.name} teacher: ${teacher?.user?.firstName ?? "No teacher"}');

        //         if (teacherUserId == null) {
        //           return false;
        //         } else {
        //           return teacherUserId == currentUserId;
        //         }
        //       });

        //       return classHasSubjectWithTeacher;
        //     });

        //     return classGroupHasCurrentUser;
        //   }).toList();

        //   log('the teacher $filteredClassGroups $currentUserId ');
        // }
        
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Filter By",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Class",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff172B47),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: Consumer<ResultProvider>(
                        builder: (context, value, _) {
                          return CustomDropdownFormField(
                            hintText: 'Select Class',
                            value: _selectedClassId, // Use class-level variable
                            onChanged: (value) {
                              setState(() {
                                selectedClass = value;
                                log('Selected Class ID: $value');
                                
                                // Find the selected class model if needed
                                for (var group in filteredClassGroups) {
                                  for (var cls in group.classes) {
                                    if (cls.id == value) {
                                      selectedClassMod = cls;
                                      break;
                                    }
                                  }
                                }
                              });
                            },
                            items: filteredClassGroups.expand((classGroup) {
                              return classGroup.classes.map((classModel) {
                                return DropdownMenuItem<String>(
                                  value: classModel.id,
                                  child: SizedBox(
                                    width: 100.w,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                      "${classGroup.name} - ${classModel.name}"),
                                  ),
                                );
                              });
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (selectedClass != null) {
                  // Update the class-level filter variable
                  _selectedClassId = selectedClass;
                  
                  log('Applying filter with class ID: $_selectedClassId');
                  
                  // Close the dialog first
                  Navigator.pop(context);
                  
                  // Then make the provider call
                  _loadExamSessions();
                }
              },
              child: const Text("Apply Filter"),
            ),
          ],
        );
      },
    );
  }
}
// class _SubmissionScreenState extends State<SubmissionScreen> {
//   String userRole = '';
//   String? _selectedClassId; // Store selected class ID at the class level
  
//   @override
//   void initState() {
//     super.initState();
//     userRole = localStore.get('role', defaultValue: context.read<UserProvider>().role);
    
//     log('my values ${widget.spaceId} ${widget.classId} ${widget.examGroupId} ${widget.examId}');
    
//     // Initial data load
//     _loadExamSessions();
//   }

//   // Separated method to load exam sessions with current filter
//   void _loadExamSessions() {
//     log('Loading exam sessions with classId: $_selectedClassId');
//     Provider.of<ExamHomeProvider>(context, listen: false).getMyExamSession(
//       context: context,
//       spaceId: widget.spaceId,
//       examGroupId: widget.examGroupId,
//       examId: widget.examId,
//       claseId: _selectedClassId ?? "", // Use class-level variable
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: customAppBarLeadingIcon(context),
//         title: Text(
//           'Submissions',
//           style: setTextTheme(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.w),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {},
//                   child: SvgPicture.asset('assets/icons/search_icon.svg'),
//                 ),
//                 SizedBox(width: 6.w),
//                 GestureDetector(
//                   onTap: () {
//                     showClassSelectionDialog(context);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     width: 30.w,
//                     height: 27.h,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: blueShades[2], width: 1),
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     child: SvgPicture.asset(
//                       'assets/icons/lets-icons_filter.svg',
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 6.w),
//                 GestureDetector(
//                   onTap: () {
//                     context.push('/teacher_stats_screen');
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     width: 30.w,
//                     height: 27.h,
//                     decoration: BoxDecoration(
//                       color: blueShades[2],
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     child: SvgPicture.asset(
//                       'assets/icons/cil_graph_icon.svg',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Consumer<ExamHomeProvider>(
//         builder: (context, provider, _) {
//           if (provider.isLoading) {
//             return SkeletonItem(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SkeletonAvatar(
//                     style: SkeletonAvatarStyle(
//                       shape: BoxShape.circle,
//                       width: 40.w,
//                       height: 40.h,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SkeletonLine(
//                           style: SkeletonLineStyle(
//                             height: 16.h,
//                             width: 120.w,
//                           ),
//                         ),
//                         SizedBox(height: 5.h),
//                         SkeletonLine(
//                           style: SkeletonLineStyle(
//                             height: 14.h,
//                             width: 80.w,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       SkeletonLine(
//                         style: SkeletonLineStyle(
//                           height: 12.h,
//                           width: 70.w,
//                         ),
//                       ),
//                       SizedBox(height: 5.h),
//                       SkeletonAvatar(
//                         style: SkeletonAvatarStyle(
//                           shape: BoxShape.circle,
//                           width: 22.w,
//                           height: 22.h,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (provider.gotWrittenExam.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset('assets/app/paparazi_image_a.png'),
//                   SizedBox(height: 60.h),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 40.w),
//                     child: Text(
//                       "No student has submitted Assessment yet",
//                       style: setTextTheme(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: 40.h),
//                   CustomButton(
//                     onTap: () {
//                       context.pop();
//                     },
//                     text: 'Okay',
//                     textStyle: setTextTheme(
//                       fontSize: 15.48.sp,
//                       fontWeight: FontWeight.w700,
//                       color: whiteShades[0],
//                     ),
//                     buttonColor: redShades[0],
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: provider.gotWrittenExam.length,
//             itemBuilder: (context, index) {
//               final exam = provider.gotWrittenExam[index];
//               return StudentSubmissions(
//                 model: exam,
//                 examGroupId: widget.examGroupId,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
  
//   void showClassSelectionDialog(BuildContext context) {
//     String? selectedClass;
//     grp.ClassModel? selectedClassMod;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
//         final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
//         final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ??''; 
//         final spaceSubject = spaceSubjectRaw.toSet().toList();
      
//         List<grp.ClassGroup> filteredClassGroups;
//         if (userRole == 'admin') {
//           filteredClassGroups = spaceSubject;
//         } else {
//           filteredClassGroups = spaceSubject.where((classGroup) {
//             log('Checking ClassGroup: ${classGroup.name} ${classGroup.classes}');

//             bool classGroupHasCurrentUser = classGroup.classes.any((classModel) {
//               log('Checking Class: ${classModel.name} ${classModel.subjectDetails.map((e) => e?.teacher?.firstName ?? '').toList()}');

//               bool classHasSubjectWithTeacher = classModel.subjectDetails.any((subject) {
//                 final teacher = subject.teacher;
//                 final teacherUserId = teacher?.user?.id;

//                 log('    Subject ${subject.name} teacher: ${teacher?.user?.firstName ?? "No teacher"}');

//                 if (teacherUserId == null) {
//                   return false;
//                 } else {
//                   return teacherUserId == currentUserId;
//                 }
//               });

//               return classHasSubjectWithTeacher;
//             });

//             return classGroupHasCurrentUser;
//           }).toList();

//           log('the teacher $filteredClassGroups $currentUserId ');
//         }
        
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           title: const Text(
//             "Filter By",
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
//           ),
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 width: MediaQuery.sizeOf(context).width,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Class",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xff172B47),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     SizedBox(
//                       height: 100,
//                       child: Consumer<ResultProvider>(
//                         builder: (context, value, _) {
//                           return CustomDropdownFormField(
//                             hintText: 'Select Class',
//                             value: _selectedClassId, // Use class-level variable
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedClass = value;
//                                 log('Selected Class ID: $value');
                                
//                                 // Find the selected class model if needed
//                                 for (var group in filteredClassGroups) {
//                                   for (var cls in group.classes) {
//                                     if (cls.id == value) {
//                                       selectedClassMod = cls;
//                                       break;
//                                     }
//                                   }
//                                 }
//                               });
//                             },
//                             items: filteredClassGroups.expand((classGroup) {
//                               return classGroup.classes.map((classModel) {
//                                 return DropdownMenuItem<String>(
//                                   value: classModel.id,
//                                   child: SizedBox(
//                                     width: 100.w,
//                                     child: Text(
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       softWrap: true,
//                                       "${classGroup.name} - ${classModel.name}"),
//                                   ),
//                                 );
//                               });
//                             }).toList(),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: () {
//                 if (selectedClass != null) {
//                   // Update the class-level filter variable
//                   _selectedClassId = selectedClass;
                  
//                   log('Applying filter with class ID: $_selectedClassId');
                  
//                   // Close the dialog first
//                   Navigator.pop(context);
                  
//                   // Then make the provider call
//                   _loadExamSessions();
//                 }
//               },
//               child: const Text("Apply Filter"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }