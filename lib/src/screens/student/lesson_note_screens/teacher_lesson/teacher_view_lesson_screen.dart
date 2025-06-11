import 'dart:developer';

import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/ai_generating_screen.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_lesson_view.dart'
    hide showCreateLessonNotesDialog;
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/widgets/teacher_tab_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/config.dart';
import '../../../../data/providers/ai_provider.dart';

class LessonTeacherClassScreen extends StatefulWidget {
  const LessonTeacherClassScreen({
    super.key,
    required this.lessonNotedId,
    required this.spaceId,
    required this.topic,
    // required this.lessonClassModel,
  });
  static const routeName = '/lesson_class_teacher_screen';
  final String lessonNotedId;
  final String spaceId;
  final String topic;
  // final LessonNoteModel lessonClassModel;

  @override
  State<LessonTeacherClassScreen> createState() =>
      _LessonTeacherClassScreenState();
}

class _LessonTeacherClassScreenState extends State<LessonTeacherClassScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
log('our value ${widget.lessonNotedId}'); 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lessonNotesProvider =
          Provider.of<LessonNotesProvider>(context, listen: false);

      lessonNotesProvider.fetchMyLesson(
        context: context,
        lessonNoteId: widget.lessonNotedId,
        spaceId: widget.spaceId,
      );

      lessonNotesProvider.fetchMyLessonPlan(
        context: context,
        lessonNoteId: widget.lessonNotedId,
        spaceId: widget.spaceId,
      );
    });

    _tabController = TabController(length: 2, vsync: this);
  }

  // late VideoPlayerController _videoPlayerController;
  // ChewieController? _chewieController;
  // bool isInitialized = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _videoPlayerController = VideoPlayerController.networkUrl(
  //     Uri.parse(widget.lessonNoteModel.lessonClassModel.videoUrl),
  //   );

  //   _videoPlayerController.addListener(() {
  //     setState(() {});
  //   });

  //   _videoPlayerController.initialize().then(
  //     (_) {
  //       setState(
  //         () {
  //           isInitialized = true;
  //           _chewieController = ChewieController(
  //             videoPlayerController: _videoPlayerController,
  //             aspectRatio: _videoPlayerController.value.aspectRatio,
  //             // autoPlay: false,
  //             // looping: false,
  //             // allowFullScreen: true,
  //             // allowMuting: true,
  //             // showControlsOnInitialize: false,
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   _chewieController?.dispose();
  //   _videoPlayerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<LessonNotesProvider>(builder: (context, value, _) {
        return Skeletonizer(
          enabled: value.isLoading,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                // leading: customAppBarLeadingIcon(context),
                leading: GestureDetector(
                  onTap: () {
                    // print('pressed');
                    context.push(LessonNoteTeacherScreen.routeName, extra: {
                      'termId': value.termId,
                      'classGroupId': value.classId,
                      "spaceId": widget.spaceId,
                      "subjectId": value.subjectId,
                    });
                    value.clearLessonNote();
                  },
                  child:  Icon(
      Icons.arrow_back_ios_new_rounded,
      color:  Colors.black,   
    ),
                  // child: SvgPicture.asset(
                  //   'assets/icons/appbar_leading_icon.svg',
                  //   // colorFilter: ColorFilter.mode(
                  //   //     themeProvider.isDarkMode ? Colors.white : Colors.black,
                  //   //     BlendMode.srcIn),
                  //   fit: BoxFit.none,
                  // ),
                ),
                title: Text(
                  'Lesson Note',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: setTextTheme(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: [
                  Consumer<AiContentProvider>(builder: (context, aiValue, _) {
                    // final  genClass = context.read<>()
                    return Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: AiButton(
                        onPressed: () {
                          if (_tabController.index == 0) {
                            context
                                .push(GeneratedContentScreen.routeName, extra: {
                              'topic': widget.topic,
                              'noteId': widget.lessonNotedId,
                              'spaceId': widget.spaceId,
                              'subject':
                                  value.myLessonNote?.subject?.name ?? '',
                              'index': 0, // Replace with appropriate value
                              'classGroup':
                                  value.myLessonNote?.classGroup?.name ?? '',
                              'id': value.lessonNotePlan?.id ?? '',
                              'content':
                                  value.lessonNotePlan?.lessonNotePlan ?? '',
                              'contentId':
                                  value.lessonNotePlan?.lessonNoteId ?? '',
                              'mode': 'plan', // Replace with appropriate value
                            });
                          } else {
                            context
                                .push(GeneratedContentScreen.routeName, extra: {
                              'topic': widget.topic,
                              'noteId': widget.lessonNotedId,
                              'spaceId': widget.spaceId,
                              'subject': value.myLessonNote?.subject?.name ??
                                  'Unknown Subject',
                              'index': 1,
                              'classGroup':
                                  value.myLessonNote?.classGroup?.name ?? '',
                              'content':
                                  value.myLessonNote?.classNote?.content ?? '',
                              'id': value.lessonNotePlan?.id ?? '',
                              'contentId':
                                  value.myLessonNote?.classNote?.id ?? '',
                              'mode': 'note',
                            });
                            // context
                            //     .push(GeneratedContentScreen.routeName, extra: {
                            //   'topic': widget.topic,
                            //   'noteId': widget.lessonNotedId,
                            //   'spaceId': widget.spaceId,
                            //   'subject':
                            //       value.myLessonNote?.subject?.name ?? '',
                            //   'index': 1,
                            //   'classGroup':
                            //       value.myLessonNote?.classGroup?.name ?? '',
                            //   'content': value.myLessonNote?.classNote?.content,
                            //   'id': value.lessonNotePlan?.id ?? '',
                            //   'contentId':
                            //       value.myLessonNote?.classNote?.id ?? '',
                            //   'mode': 'note',
                            // });
                          }
                        },
                      ),
                    );
                  })
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Color(0xffF1F1F1),
                          borderRadius: BorderRadius.circular(30.r),
                          border:
                              Border.all(color: Color(0xffFCFCFC), width: 2.0),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorWeight: 1.0,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelStyle: setTextTheme(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          labelStyle: setTextTheme(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          dividerColor: Colors.transparent,
                          unselectedLabelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: blueShades[1],
                          ),
                          tabs: [
                            Tab(
                              text: 'Lesson Plan',
                            ),
                            //Tab(text: 'Submitted'),
                            Tab(text: 'Class Note'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: TabBarView(controller: _tabController, children: [
                TabViewOne(
                  lessonClassModel: value.myLessonNote,
                  lessonId: widget.lessonNotedId,
                  spaceId: widget.spaceId,
                  topic: widget.topic,
                  plan: value.lessonNotePlan,
                ),
                TabViewTwo(
                  lessonClassModel: value.myLessonNote,
                  lessonId: widget.lessonNotedId,
                  spaceId: widget.spaceId,
                  topic: widget.topic,
                )
              ])),
        );
      }),
    );
  }
}

class CustomContainerButton extends StatelessWidget {
  final IconData icon; // Icon to display
  final VoidCallback onTap; // Action when tapped
  final Color backgroundColor; // Background color
  final Color iconColor; // Icon color
  final double size;
  final double height; // Size of the button

  final double iconSize; // Size of the icon
  final BorderRadius borderRadius; // Corner radius

  const CustomContainerButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.white,
    this.size = 40.0,
    this.height = 15.0,
    this.iconSize = 24.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap event
      child: Container(
        width: size,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor, // Background color
          borderRadius: borderRadius, // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              offset: const Offset(0, 2), // Subtle shadow for depth
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class AiButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AiButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.edit, color: Colors.white, size: 16),
      label: Text(
        'Use AI',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF9800), // Orange color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded edges
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

// class AiButton extends StatefulWidget {
//   final Function(String) onPressed; // Updated to pass selected tone

//   const AiButton({super.key, required this.onPressed});

//   @override
//   _AiButtonState createState() => _AiButtonState();
// }

// class _AiButtonState extends State<AiButton> {
//   String _selectedTone = "BALANCED"; // Default tone

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min, // Keeps the row compact
//       children: [
//         // Dropdown for tone selection
//         DropdownButton<String>(
//           value: _selectedTone,
//           items: <String>["FORMAL", "BALANCED", "CREATIVE"].map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(
//                 value,
//                 style: TextStyle(color: Colors.black, fontSize: 14),
//               ),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             setState(() {
//               _selectedTone = newValue!;
//             });
//           },
//           underline: SizedBox(), // Removes default underline
//           dropdownColor: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         SizedBox(width: 8), // Spacing between dropdown and button
//         // Original button
//         ElevatedButton.icon(
//           onPressed: () =>
//               widget.onPressed(_selectedTone), // Pass tone to callback
//           icon: Icon(Icons.edit, color: Colors.white, size: 16),
//           label: Text(
//             'Use AI',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFFFF9800), // Orange color
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20), // Rounded edges
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           ),
//         ),
//       ],
//     );
//   }
// }
