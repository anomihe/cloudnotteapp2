import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/teacher_homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_lesson_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart' as grp;
import '../../../../components/shared_widget/general_button.dart';
import '../../../../data/models/exam_session_model.dart' as exam;
import '../../../../data/models/user_model.dart';
import '../../../../data/providers/user_provider.dart';

class TeacherLessonScreen extends StatefulWidget {
  final String spaceId;
  const TeacherLessonScreen({super.key, required this.spaceId});

  @override
  State<TeacherLessonScreen> createState() => _TeacherLessonScreenState();
}

class _TeacherLessonScreenState extends State<TeacherLessonScreen> {
  String? role;
  @override
  void initState() {
    Provider.of<LessonNotesProvider>(context, listen: false).fetchClassGroup(
      spaceId: widget.spaceId,
      context: context,
    );
    role = localStore.get('role', defaultValue: context.read<UserProvider>().role);
    super.initState();
  }

  bool isSubjectDropdownEnabled = false;
  String termId = '';
  SpaceTerm? selectedTerm;
  grp.ClassGroup? selectedClass;
  String? classId;
  String subjectId = '';
  exam.SubjectDetail? selectedSubject;
  List<exam.SubjectDetail> filteredSubjects = [];

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserProvider>().singleSpace?.user?.id ??''; 
    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
 

    final spaceSubjectRaw = context.watch<LessonNotesProvider>().group ?? [];
    final spaceSubject = spaceSubjectRaw.toSet().toList();

List<grp.ClassGroup> filteredClassGroups;
if (role == 'admin') {
  filteredClassGroups = spaceSubject;
} else {
  filteredClassGroups = spaceSubject.map((classGroup) {
    // Create new filtered classes with deep copies
    final filteredClasses = classGroup.classes.map((classModel) {
      // Filter subjects for this teacher only
      final filteredSubjects = classModel.subjectDetails.where((subject) {
        return subject.teacher?.user?.id == currentUserId;
      }).toList();

      // Only include class if it has subjects taught by this teacher
      return filteredSubjects.isNotEmpty 
          ? classModel.copyWith(subjectDetails: filteredSubjects)
          : null;
    }).where((c) => c != null).toList();

    // Only include class group if it has valid classes
    return filteredClasses.isNotEmpty
        ? classGroup.copyWith(classes: filteredClasses.cast<grp.ClassModel>())
        : null;
  }).where((cg) => cg != null).cast<grp.ClassGroup>().toList();
}
// if (role == 'admin') {
//   filteredClassGroups = spaceSubject;
// } else {
//   // First, filter class groups that have at least one class with the current user as a teacher
//   filteredClassGroups = spaceSubject.where((classGroup) {
//     log('Checking ClassGroup: ${classGroup.name}');
    
//     // Create filtered classes for this class group
//     final filteredClasses = classGroup.classes.where((classModel) {
//       log('Checking Class: ${classModel.name}');
      
//       bool classHasSubjectWithTeacher = classModel.subjectDetails.any((subject) {
//         final teacher = subject?.teacher;
//         final teacherUserId = teacher?.user?.id;
        
//         log('    Subject ${subject?.name} teacher: ${teacher?.user?.firstName ?? "No teacher"}');
        
//         return teacherUserId != null && teacherUserId == currentUserId;
//       });
      
//       return classHasSubjectWithTeacher;
//     }).toList();
    
//     // If we have any filtered classes, update the class group with only those classes
//     if (filteredClasses.isNotEmpty) {
//       // Create a copy of the class group with only the filtered classes
//       classGroup = classGroup.copyWith(classes: filteredClasses);
      
//       // Further filter each class to only include subjects taught by the current user
//       for (var i = 0; i < classGroup.classes.length; i++) {
//         final filteredSubjects = classGroup.classes[i].subjectDetails.where((subject) {
//           final teacherUserId = subject?.teacher?.user?.id;
//           return teacherUserId != null && teacherUserId == currentUserId;
//         }).toList();
        
//         // Update the class with only the filtered subjects
//         classGroup.classes[i] = classGroup.classes[i].copyWith(subjectDetails: filteredSubjects);
//       }
      
//       return true;
//     }
    
//     return false;
//   }).toList();
  
//   log('Filtered class groups for teacher $currentUserId: ${filteredClassGroups.length}');
// }
// if (role == 'admin') {
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

    if (selectedTerm == null && spaceTerms.isNotEmpty) {
      selectedTerm = spaceTerms.first;
    } else if (!spaceTerms.contains(selectedTerm)) {
      selectedTerm = null;
    }

    if (selectedClass != null && !spaceSubject.contains(selectedClass)) {
      selectedClass = null;
      filteredSubjects.clear();
      selectedSubject = null;
      isSubjectDropdownEnabled = false;
    }

    log('spaceSubject: ${spaceSubject.length}, filteredSubjects: ${filteredSubjects.length}');

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Lesson Note',
            style: setTextTheme(fontSize: 24.sp),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80.h),
                // Term Dropdown
                CustomDropdownFormField<SpaceTerm>(
                    hintText: 'Select Term',
                    title: 'Select Term',
                    items: spaceTerms.map((spaceTerm) {
                      return DropdownMenuItem<SpaceTerm>(
                        value: spaceTerm,
                        child: Text(
                          spaceTerm.name,
                          style: setTextTheme(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        final term = value as SpaceTerm?;
                        termId = term?.id ?? '';
                        selectedTerm = term;
                        log('Selected term: ${term?.name}, ID: $termId');
                      });
                    }),

                // Class Dropdown
                CustomDropdownFormField<grp.ClassGroup>(
                  hintText: 'Select Class',
                  title: 'Select Class',
                   value: filteredClassGroups.contains(selectedClass) ? selectedClass : null,
                  // value: spaceSubject.contains(selectedClass)
                  //     ? selectedClass
                  //     : null,
                  // items: spaceSubject
                 items: filteredClassGroups.map((myClassGroup) {
                    return DropdownMenuItem<grp.ClassGroup>(
                      value: myClassGroup,
                      child: Text(
                        myClassGroup.name,
                        style: setTextTheme(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
              

                  onChanged: (value) {
                    setState(() {
                      final grp.ClassGroup? classGroup =
                          value as grp.ClassGroup?;
                      selectedClass = classGroup;
                      classId = classGroup?.id;
                      filteredSubjects.clear();
                      selectedSubject =
                          null; // Reset subject when class changes
                      if (classGroup != null) {
                       filteredSubjects.addAll(
  classGroup.classes
      .expand((classModel) => classModel.subjectDetails)
      .where((subject) => subject.teacher != null) // 👈 only subjects with teachers
      .toSet()
      .toList(),

                        );
                        isSubjectDropdownEnabled = true;
                        log('Selected class: ${classGroup.name}, Subjects: ${filteredSubjects.length}');
                        if (filteredSubjects.isNotEmpty) {
                          log('First subject: ${filteredSubjects.first.name}');
                        } else {
                          log('No subjects available for selected class');
                        }
                      } else {
                        isSubjectDropdownEnabled = false;
                      }
                    });
                  },
                ),
                CustomDropdownFormField(
                  title: "Select Subject",
                  hintText: "Select Subject",
                  items: filteredSubjects.toSet().map((subject) {
                    log(
                        "Creating dropdown item for: ${subject.name} with ID: ${subject.id}");
                    return DropdownMenuItem<exam.SubjectDetail>(
                      value: subject,
                      child: Text(subject.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      //selected = value?.name;
                      subjectId = value?.id ?? '';
                    });
                  },
                  // onChanged: isSubjectDropdownEnabled
                  //     ? (value) {
                  //         setState(() {
                  //           //selected = value?.name;
                  //           classId = value?.id;
                  //         });
                  //       }
                  //     : null,
                ),

                SizedBox(
                  height: 40.h,
                ),
                Buttons(
                  text: 'View Topic',
                  isLoading: false,
                  onTap: () {
                    if (termId.isNotEmpty &&
                        classId != null &&
                        subjectId.isNotEmpty) {
                      context.push(LessonNoteTeacherScreen.routeName, extra: {
                        'termId': termId,
                        'classGroupId': classId,
                        "spaceId": widget.spaceId,
                        "subjectId": subjectId,
                      });
                      Provider.of<LessonNotesProvider>(context, listen: false)
                          .setDataGroup(
                              termId: termId,
                              classId: classId ?? '',
                              subjectId: subjectId);
                      print(
                          'sent $termId $classId ${widget.spaceId} $subjectId');
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
