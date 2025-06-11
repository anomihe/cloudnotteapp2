import 'dart:developer';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart' as grp;
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/teacher_homework_model.dart';
import '../teacher_screens/homework_group_screen.dart';

class AssessmentBox extends StatefulWidget {
  const AssessmentBox({super.key, required this.homeWorkGroup});
  // final HomeworkModel homeworkModel;
  final ExamTeacherGroup homeWorkGroup;

  @override
  State<AssessmentBox> createState() => _AssessmentBoxState();
}

class _AssessmentBoxState extends State<AssessmentBox> {
  bool isHovered = false;

  void _navigate() {
    // context.push(HomeworkGroupScreen.routeName, extra: {
    //   'classId': widget.homeWorkGroup.classes.first.classGroupId,
    //   'examId': widget.homeWorkGroup.examIds,
    //   "homeworkModel": widget.homeWorkGroup.category,
    //   "classGroupId": widget.homeWorkGroup.classes.first.classGroupId,
    //   "examGroupId": widget.homeWorkGroup.id,
    //   "spaceId": widget.homeWorkGroup.session.spaceId,
    // });
    log('rrr ${widget.homeWorkGroup.classes}');
    showClassSelectionDialog(context, widget.homeWorkGroup.classes);
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the background color is grey or red  greyShades[0]
    Color backgroundColor = isHovered ? redShades[1] : Color(0xffF8F8F8);
    Color textColor = backgroundColor == redShades[1]
        ? whiteShades[0]
        : Colors.black; // Dynamic text color

    return GestureDetector(
      onTapDown: (_) => setState(() => isHovered = true),
      onTapUp: (_) {
        setState(() => isHovered = false);
        _navigate(); // Navigate when the user lifts their finger
      },
      onTapCancel: () => setState(() => isHovered = false),
      onLongPress: () {
        setState(() => isHovered = true);
        _navigate(); // Navigate on long press
      },
      onLongPressEnd: (_) => setState(() => isHovered = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          height: 140.h,
          width: 361.w,
          decoration: BoxDecoration(
            color: ThemeProvider().isDarkMode ? blueShades[15] : const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(
              color: blueShades[7]
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10.h,
                right: 18.w,
                child: SvgPicture.asset(
                  'assets/icons/time_sand_icon.svg',
                  colorFilter: ColorFilter.mode(
                    ThemeProvider().isDarkMode ? blueShades[17] : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.none,
                ),
              ),
              Positioned(
                left: 65.w,
                bottom: 15.h,
                child: Text(
                  'Exams: ${widget.homeWorkGroup.examCount} ',
                  style: setTextTheme(
                    fontSize: 12.sp,
                    // color: textColor, // Use dynamic text color
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                right: 15.w,
                bottom: 15.h,
                child: Container(
                  width: 105.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    // color: whiteShades[0],
                    border: Border.all(color: blueShades[7]),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(5.0.r),
                      child: Text(
                        "View",
                        overflow: TextOverflow.ellipsis,
                        style: setTextTheme(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Container(
                        width: 45.r,
                        height: 45.r,
                        decoration: BoxDecoration(
                          color: redShades[4],
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/assignment_icon_small.svg',
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            // widget.homeworkModel.groupName,
                            widget.homeWorkGroup.name.replaceAll(')', ''),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: setTextTheme(
                              fontSize: 28.sp,
                              // color: textColor, // Use dynamic text color
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.h,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            // 'Created: 30th Sept 2024 - 10:00am',

                            widget.homeWorkGroup.category,
                            maxLines: 2,
                            style: setTextTheme(
                              fontSize: 12.sp,
                              // color: textColor, // Use dynamic text color
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showClassSelectionDialog(
      BuildContext context, List<ClassInfo> classInfo) {
    String? selectedClass;
    String? classId;
    final Set<String> validClassGroupIds =
        classInfo.map((e) => e.classGroup.id).toSet();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final spaceTerms = context.watch<LessonNotesProvider>().group ?? [];
        // grp.ClassGroup? selectedTerm =
        //     (spaceTerms.isNotEmpty) ? spaceTerms.first : null;

        // if (!spaceTerms.contains(selectedTerm)) {
        //   selectedTerm = null;
        // }
        // if (selectedTerm == null && spaceTerms.isNotEmpty) {
        //   selectedTerm = spaceTerms.first;
        // } else if (!spaceTerms.contains(selectedTerm)) {
        //   selectedTerm = null;
        // }
        final List<grp.ClassGroup> filteredClassGroups = spaceTerms
            .where((spaceTerm) => validClassGroupIds.contains(spaceTerm.id)).toSet() 
            .toList();

        grp.ClassGroup? selectedTerm =
            filteredClassGroups.isNotEmpty ? filteredClassGroups.first : null;
        log('grpt $spaceTerms');
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "Select Class",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width:MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Class",
                          style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff172B47))),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<grp.ClassGroup>(
                      decoration: InputDecoration(
                        
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff172B47)),
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                      // value: selectedTerm,
                      hint: const Text("Select Class"),
                      
                      items: filteredClassGroups.map((spaceTerm) {
                            return DropdownMenuItem<grp.ClassGroup>(
                              value: spaceTerm,
                              child: Text(
                                spaceTerm.name,
                                style: setTextTheme(
                                  color: Color(0xff172B47),
                                    fontSize: 16.sp, fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList() ??
                          [],
                      onChanged: (value) {
                        setState(() {
                            selectedTerm = value; 
                          selectedClass = value?.name;
                          classId = value?.id;
                        });
                      },
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
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (selectedClass != null) {
                  // Navigator.pop(context, selectedClass);
                  context.push(HomeworkGroupScreen.routeName, extra: {
                    'classId': widget.homeWorkGroup.classes.first.classGroupId,
                    'examId': widget.homeWorkGroup.examIds,
                    "homeworkModel": widget.homeWorkGroup.category,
                    "classGroupId": classId,
                    // "classGroupId":
                    //     widget.homeWorkGroup.classes.first.classGroupId,
                    "examGroupId": widget.homeWorkGroup.id,
                    "spaceId": widget.homeWorkGroup.session.spaceId,
                  });
                }
              },
              child: const Text("Proceed"),
            ),
          ],
        );
      },
    );
  }
}
