import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_view_lesson_screen.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/widgets/my_alart_dialog.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/config.dart';
import '../../../../data/models/lesson_note_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/providers/user_provider.dart';

class LessonNoteTeacherScreen extends StatefulWidget {
  final String spaceId;
  final String classGroupId;
  final String termId;
  final String subjectId;
  const LessonNoteTeacherScreen(
      {super.key,
      required this.spaceId,
      required this.classGroupId,
      required this.termId,
      required this.subjectId});

  static const String routeName = "/lesson_note_teacher_screen";

  @override
  State<LessonNoteTeacherScreen> createState() =>
      _LessonNoteTeacherScreenState();
}

class _LessonNoteTeacherScreenState extends State<LessonNoteTeacherScreen> {
  final List<String> term = ['1st Term', '2nd Term'];
  final List<String> subjects = ['English ', 'Maths'];
  // String? selectedTerm;
  String? selectedSubject;

  // color list the container color will cycle through
  final List<Color> _cardColors = [
    purpleShades[0],
    greenShades[1],
    goldenShades[0],
    redShades[0],
    greenShades[1],
    blueShades[0],
    greenShades[0],
  ];

  // color list the text color will cycle through
  final List<Color> _cardTextColors = [
    whiteShades[0],
    Colors.black,
    Colors.black,
    whiteShades[0],
    Colors.black,
    Colors.black,
    whiteShades[0],
  ];

  final List<QuiltedGridTile> _gridTileList = [
    const QuiltedGridTile(1, 1),
    const QuiltedGridTile(1, 1),
    const QuiltedGridTile(1, 2),
    const QuiltedGridTile(2, 1),
    const QuiltedGridTile(1, 1),
    const QuiltedGridTile(2, 1),
    const QuiltedGridTile(1, 1),
  ];

  // background picture list to cycle through
  final List<String> _backgroundIcons = [
    'assets/icons/a_icon.svg',
    'assets/icons/a_icon.svg',
    'assets/icons/flask_icon.svg',
    'assets/icons/flask_icon.svg',
    'assets/icons/a_icon.svg',
    'assets/icons/a_icon.svg',
    'assets/icons/flask_icon.svg',
  ];

  String classSessionId = '';
  String termId = '';

  @override
  void initState() {
    super.initState();
    // Provider.of<LessonNotesProvider>(context, listen: false).fetchClassGroup(
    //   spaceId: widget.spaceId,
    //   context: context,
    // );
    // classSessionId = localStore.get('sessionId',
    //     defaultValue: context.read<UserProvider>().classSessionId);
    // termId = localStore.get('termId',
    //     defaultValue: context.read<UserProvider>().termId);
    Provider.of<LessonNotesProvider>(context, listen: false).fetchLessonNotes(
      spaceId: widget.spaceId,
      input: GetLessonNotesInput(
        classGroupId: widget.classGroupId,
        subjectId: widget.subjectId,
        termId: widget.termId,
      ),
    );
    // selectedTerm = term[0];
    selectedSubject = subjects[0];
  }

  bool isSubjectDropdownEnabled = false;
  String id = '';
  SpaceTerm? selectedTerm;
  String? selectedClass;
  String? classId;

  void _navigateBack(BuildContext context) {
    final role = localStore.get(
      'role',
      defaultValue: context.read<UserProvider>().role,
    );

    context.push(StudentLandingScreen.routeName, extra: {
      'id': widget.spaceId,
      'provider': context.read<UserProvider>(),
      'currentIndex': role == 'teacher' ? 2 : 3,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: customAppBarLeadingIcon(context),
        leading: GestureDetector(
          onTap: () {
            // print('pressed');
           
            _navigateBack(context);
          },
          child: Icon(
      Icons.arrow_back_ios_new_rounded,
      color:   ThemeProvider().isDarkMode ? Colors.white : Colors.black,   
    ),
          // child: SvgPicture.asset(
          //   'assets/icons/appbar_leading_icon.svg',
          //   colorFilter: ColorFilter.mode(
          //       ThemeProvider().isDarkMode ? Colors.white : Colors.black,
          //       BlendMode.srcIn),
          //   fit: BoxFit.none,
          // ),
        ),
        title: Text(
          'Lesson Note',
          style: setTextTheme(fontSize: 24.sp),
        ),
      ),
      body: Consumer<LessonNotesProvider>(
        builder: (context, lessonNotesProvider, child) {
          if (lessonNotesProvider.isLoading) {
            // return Center(child: CircularProgressIndicator());
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return SkeletonItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: double.infinity,
                          height: 120,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 10),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 12,
                          width: 100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(height: 5),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 10,
                          width: 150,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (lessonNotesProvider.error != null) {
            return Center(child: Text('Error: ${lessonNotesProvider.error}'));
          }

          final lessonNotesList = lessonNotesProvider.lessonNotes;

          if (lessonNotesList.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/app/paparazi_image_a.png'),
                  SizedBox(height: 60.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      "No Lesson Note",
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
          return Padding(
            padding: EdgeInsets.all(10.r),
            child: GridView.custom(
              semanticChildCount: lessonNotesList.length,
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                repeatPattern: QuiltedGridRepeatPattern.same,
                pattern: [
                  ..._gridTileList // spreading the list of grid tile
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: lessonNotesList.length,
                (context, index) {
                  // final url = lessonNotesList[index].classGroup?.classes;
                  return GestureDetector(
                    onTap: () {
                      context.push(LessonTeacherClassScreen.routeName, extra: {
                        "lessonNoteId": lessonNotesList[index].id,
                        "spaceId": widget.spaceId,
                        "topic": lessonNotesList[index].topic,
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 30.h,
                            horizontal: 15.w,
                          ),
                          // height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            color: _cardColors[index % _cardColors.length],
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Positioned(
                          right: 7.w,
                          bottom: 7.h,
                          child: SvgPicture.asset(
                            _backgroundIcons[index % _backgroundIcons.length],
                          ),
                        ),
                        // Positioned(
                        //   left: 18.w,
                        //   bottom: 18.h,
                        //   child: Container(
                        //     width: 24.w,
                        //     height: 22.h,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(100.r),
                        //         image: DecorationImage(
                        //             fit: BoxFit.cover, image: NetworkImage('${lessonNotesList[index].topicCover}')
                        //             // AssetImage(
                        //             //   'assets/app/mock_person_image.jpg',
                        //             // ),
                        //             )),
                        //   ),
                        // ),
                        Positioned(
                          left: 18.w,
                          bottom: 18.h,
                          child: Container(
                            width: 24.w,
                            height: 22.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                              color: Colors
                                  .blue, // Background color for the letter avatar
                            ),
                            child: (lessonNotesList[index].topicCover != null &&
                                    lessonNotesList[index]
                                        .topicCover!
                                        .isNotEmpty)
                                ? ClipOval(
                                    child: Image.network(
                                      lessonNotesList[index].topicCover!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return _buildLetterAvatar(
                                            lessonNotesList[index].topic);
                                      },
                                    ),
                                  )
                                : _buildLetterAvatar(
                                    lessonNotesList[index].topic),
                          ),
                        ),
                        Positioned(
                          left: 18.w,
                          top: 18.h,
                          child: Builder(
                            builder: (context) {
                              // getting the current grid pattern
                              final QuiltedGridTile currentPattern =
                                  _gridTileList[index % _gridTileList.length];

                              // determine tile width based on the grid pattern
                              double gridTileWidth;
                              if (currentPattern ==
                                  const QuiltedGridTile(1, 2)) {
                                // full width for (1, 2) pattern
                                gridTileWidth =
                                    MediaQuery.of(context).size.width - 10.w;
                              } else {
                                gridTileWidth =
                                    (MediaQuery.of(context).size.width - 10.w) /
                                        2;
                              }

                              return SizedBox(
                                width: gridTileWidth -
                                    36.w, // responsible for padding
                                child: Text(
                                  lessonNotesList[index].topic,
                                  style: setTextTheme(
                                    color: _cardTextColors[
                                        index % _cardTextColors.length],
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // truncate long texts
                                  maxLines: currentPattern ==
                                          const QuiltedGridTile(2, 1)
                                      ? 9
                                      : 3,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff2F66EE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        onPressed: () {
          showCreateLessonNotesDialog(
              context: context,
              spaceId: widget.spaceId,
              classGroupId: widget.classGroupId,
              termId: widget.termId,
              subjectId: widget.subjectId);
        },
        label: Text('Add Topic',
            style: setTextTheme(
              color: whiteShades[0],
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }

  Widget _buildLetterAvatar(String? topic) {
    String firstLetter =
        (topic?.isNotEmpty ?? false) ? topic![0].toUpperCase() : "?";
    return Center(
      child: Text(
        firstLetter,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
