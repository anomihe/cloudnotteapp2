import 'dart:developer';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/exam_session_model.dart'
    show SubjectDetail;
import 'package:cloudnottapp2/src/data/models/user_model.dart' show SpaceTerm;
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/courses/courses_tab.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/lesson_class_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/lesson_note_model.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/models/exam_session_model.dart' as exam;

class LessonNoteScreen extends StatefulWidget {
  final String spaceId;
  const LessonNoteScreen({super.key, required this.spaceId});

  static const String routeName = "/lesson_note_screen";

  @override
  State<LessonNoteScreen> createState() => _LessonNoteScreenState();
}

class _LessonNoteScreenState extends State<LessonNoteScreen>
    with SingleTickerProviderStateMixin {
  final List<String> term = ['1st Term', '2nd Term'];
  final List<String> subjects = ['English ', 'Maths'];
  String? selectedSubject;

  late TabController _tabController;

  final List<Color> _cardColors = [
    purpleShades[0],
    greenShades[1],
    goldenShades[0],
    redShades[0],
    greenShades[1],
    blueShades[0],
    greenShades[0],
  ];

  final List<Color> _cardTextColors = [
    whiteShades[0],
    Colors.black,
    Colors.black,
    whiteShades[0],
    Colors.black,
    whiteShades[0],
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
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<LessonNotesProvider>(context, listen: false).fetchClassGroup(
      spaceId: widget.spaceId,
      context: context,
    );
    classSessionId = localStore.get('sessionId',
        defaultValue: context.read<UserProvider>().classSessionId);
    termId = localStore.get('termId',
        defaultValue: context.read<UserProvider>().termId);
    Provider.of<LessonNotesProvider>(context, listen: false).fetchLessonNotes(
        spaceId: widget.spaceId,
        input: GetLessonNotesInput(
            classGroupId: "",
            subjectId: selectedSubject ?? '',
            termId: termId));
    selectedSubject = subjects[0];
  }

  bool isSubjectDropdownEnabled = false;
  SpaceTerm? selectedTerm;
  String? selectedClass;
  String? classId;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          // 'Course | Notes',
          'Lesson Note',
          style: setTextTheme(fontSize: 24.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.r),
        // child: Column(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(100.r),
        //         border: Border.all(color: whiteShades[1]),
        //       ),
        //       child: TabBar(
        //         controller: _tabController,
        //         indicator: BoxDecoration(
        //           color: blueShades[0],
        //           borderRadius: BorderRadius.circular(100.r),
        //         ),
        //         indicatorSize: TabBarIndicatorSize.tab,
        //         labelColor: Colors.white,
        //         unselectedLabelColor:
        //             ThemeProvider().isDarkMode ? Colors.white : Colors.black,
        //         labelStyle: setTextTheme(),
        //         unselectedLabelStyle: setTextTheme(),
        //         dividerColor: Colors.transparent,
        //         tabs: [
        //           SizedBox(height: 35.h, child: Center(child: Text('Courses'))),
        //           SizedBox(height: 35.h, child: Center(child: Text('Notes'))),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: TabBarView(
        //         controller: _tabController,
        //         children: [
        //           CoursesScreen(),
        //           NotesTab(
        //             spaceId: widget.spaceId,
        //             selectedTerm: selectedTerm,
        //             termId: termId,
        //             cardColors: _cardColors,
        //             cardTextColors: _cardTextColors,
        //             gridTileList: _gridTileList,
        //             backgroundIcons: _backgroundIcons,
        //             onTermChanged: (value) {
        //               setState(() {
        //                 termId = value?.id ?? '';
        //                 selectedTerm = value;
        //                 log('Selected term: ${value?.name}, ID: $termId');
        //               });
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        child: NotesTab(
          spaceId: widget.spaceId,
          selectedTerm: selectedTerm,
          termId: termId,
          cardColors: _cardColors,
          cardTextColors: _cardTextColors,
          gridTileList: _gridTileList,
          backgroundIcons: _backgroundIcons,
          onTermChanged: (value) {
            setState(() {
              termId = value?.id ?? '';
              selectedTerm = value;
              log('Selected term: ${value?.name}, ID: $termId');
            });
          },
        ),
      ),
    );
  }
}

// Widget for the Notes Tab
class NotesTab extends StatefulWidget {
  final String spaceId;
  final SpaceTerm? selectedTerm;
  final String termId;
  final List<Color> cardColors;
  final List<Color> cardTextColors;
  final List<QuiltedGridTile> gridTileList;
  final List<String> backgroundIcons;
  final ValueChanged onTermChanged;

  const NotesTab({
    super.key,
    required this.spaceId,
    required this.selectedTerm,
    required this.termId,
    required this.cardColors,
    required this.cardTextColors,
    required this.gridTileList,
    required this.backgroundIcons,
    required this.onTermChanged,
  });

  @override
  _NotesTabState createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  @override
  Widget build(BuildContext context) {
    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
    // final studentClass = context.watch()<UserProvider>().data?.studentClass;
    // final classGroupId = context.read<UserProvider>().singleSpace?.classInfo?.classGroupId;
    // final spaceSubject = context.watch<LessonNotesProvider>().group ?? [];
    // List<SubjectDetail> allSubjects = spaceSubject
    //     .expand((group) => group.classes)
    //     .expand((classModel) => classModel.subjectDetails)
    //     .toList();
    final classGroupId =
        context.read<UserProvider>().singleSpace?.classInfo?.classGroupId;

// Fetch all subject details under the matching class group
    final spaceSubject = context.watch<LessonNotesProvider>().group ?? [];
    List<SubjectDetail> allSubjects = spaceSubject
        .where((group) => group.id == classGroupId) // Filter class group
        .expand((group) => group.classes)
        .expand((classModel) => classModel.subjectDetails)
        .toSet()
        .toList();

// List<SubjectDetail> allSubjects = spaceSubject
//     .expand((group) => group.classes)
//     .where((classModel) => classModel. == classGroupId) // 🔍 filter by group
//     .expand((classModel) => classModel.subjectDetails)
//     .toList();

    return Column(
      children: [
        // SizedBox(height: 15.h),
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CustomDropdownFormField(
                hintText: 'Select Term',
                items: spaceTerms.map((spaceTerm) {
                  return DropdownMenuItem(
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
                onChanged: widget.onTermChanged,
              ),
            ),
            // Expanded(
            //   child: SizedBox(
            //     height: 40.h,
            //     child: DropdownButtonFormField<SpaceTerm>(
            //       value: widget.selectedTerm,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         contentPadding:
            //             const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            //       ),
            //       style: setTextTheme(
            //           fontSize: 16.sp, fontWeight: FontWeight.w700),
            //       hint: Text('Select Term'),
            //       isDense: true,
            //       icon: Padding(
            //         padding: EdgeInsets.only(top: 0, left: 4.w, bottom: 4.h),
            //         child: Icon(Icons.arrow_drop_down),
            //       ),
            //       items: spaceTerms.map((spaceTerm) {
            //         return DropdownMenuItem<SpaceTerm>(
            //           value: spaceTerm,
            //           child: Text(
            //             spaceTerm.name,
            //             style: setTextTheme(
            //               fontSize: 16.sp,
            //               fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //         );
            //       }).toList(),
            //       onChanged: widget.onTermChanged,
            //     ),
            //   ),
            // ),
            Expanded(
              child: CustomDropdownFormField(
                hintText: 'Subject',
                items: allSubjects.toSet().map((subject) {
                  print(
                      "Creating dropdown item for: ${subject.name} with ID: ${subject.id}");
                  return DropdownMenuItem<exam.SubjectDetail>(
                    value: subject,
                    child: SizedBox(
                      width: 100.w,
                      child: Text(
                        subject.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: setTextTheme(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  log('message: ${value?.id} ${spaceSubject.first.id} ${widget.selectedTerm?.id}');
                  Provider.of<LessonNotesProvider>(context, listen: false)
                      .fetchLessonNotes(
                          spaceId: widget.spaceId,
                          input: GetLessonNotesInput(
                              classGroupId: context
                                      .read<UserProvider>()
                                      .singleSpace
                                      ?.classInfo
                                      ?.classGroupId ??
                                  '',
                              subjectId: value?.id ?? '',
                              termId: widget.selectedTerm?.id ?? ''));
                },
              ),
            ),
            // Flexible(
            //   child: SizedBox(
            //     height: 40.h,
            //     child: DropdownButtonFormField<SubjectDetail>(
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8)),
            //         contentPadding: const EdgeInsets.symmetric(
            //             horizontal: 14, vertical: 10),
            //       ),
            //       hint: Text(
            //         "Subject",
            //         style: setTextTheme(
            //           fontSize: 14.sp,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       isDense: true,
            //       style: setTextTheme(
            //           fontSize: 12.sp, fontWeight: FontWeight.w700),
            //       icon: Padding(
            //         padding: EdgeInsets.only(right: 4.w),
            //         child: Icon(Icons.arrow_drop_down, size: 20),
            //       ),
            //       items: allSubjects.toSet().map((subject) {
            //         print(
            //             "Creating dropdown item for: ${subject.name} with ID: ${subject.id}");
            //         return DropdownMenuItem<exam.SubjectDetail>(
            //           value: subject,
            //           child: SizedBox(
            //             width: 100.w,
            //             child: Text(
            //               subject.name,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 1,
            //               style: setTextTheme(
            //                 fontSize: 12.sp,
            //                 fontWeight: FontWeight.w700,
            //               ),
            //             ),
            //           ),
            //         );
            //       }).toList(),
            //       onChanged: (value) {
            //         log('message: ${value?.id} ${spaceSubject.first.id} ${widget.selectedTerm?.id}');
            //         Provider.of<LessonNotesProvider>(context, listen: false)
            //             .fetchLessonNotes(
            //                 spaceId: widget.spaceId,
            //                 input: GetLessonNotesInput(
            //                     classGroupId: context
            //                             .read<UserProvider>()
            //                             .singleSpace
            //                             ?.classInfo
            //                             ?.classGroupId ??
            //                         '',
            //                     subjectId: value?.id ?? '',
            //                     termId: widget.selectedTerm?.id ?? ''));
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
        Expanded(
          child: Consumer<LessonNotesProvider>(
            builder: (context, LessonNotesProvider, child) {
              if (LessonNotesProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (LessonNotesProvider.error != null) {
                return Center(
                    child: Text('Error: ${LessonNotesProvider.error}'));
              }

              final lessonNotesList = LessonNotesProvider.lessonNotes;
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
                    pattern: [...widget.gridTileList],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    childCount: lessonNotesList.length,
                    (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(LessonClassScreen.routeName, extra: {
                            "lessonNoteModel": lessonNotesList[index],
                            "spaceId": widget.spaceId,
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 30.h,
                                horizontal: 15.w,
                              ),
                              decoration: BoxDecoration(
                                color: widget.cardColors[
                                    index % widget.cardColors.length],
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            Positioned(
                              right: 7.w,
                              bottom: 7.h,
                              child: SvgPicture.asset(
                                widget.backgroundIcons[
                                    index % widget.backgroundIcons.length],
                              ),
                            ),
                            Positioned(
                              left: 18.w,
                              bottom: 18.h,
                              child: Container(
                                width: 24.w,
                                height: 22.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.r),
                                  border: Border.all(
                                      color: Colors.grey[300]!), // Light border

                                  // image: const DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   image: AssetImage(
                                  //     'assets/app/mock_person_image.jpg',
                                  //   ),
                                  // ),
                                ),
                                child: (lessonNotesList[index].topicCover !=
                                            null &&
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
                                  final QuiltedGridTile currentPattern =
                                      widget.gridTileList[
                                          index % widget.gridTileList.length];
                                  double gridTileWidth;
                                  if (currentPattern ==
                                      const QuiltedGridTile(1, 2)) {
                                    gridTileWidth =
                                        MediaQuery.of(context).size.width -
                                            10.w;
                                  } else {
                                    gridTileWidth =
                                        (MediaQuery.of(context).size.width -
                                                10.w) /
                                            2;
                                  }

                                  return SizedBox(
                                    width: gridTileWidth - 36.w,
                                    child: Text(
                                      lessonNotesList[index].topic,
                                      style: setTextTheme(
                                        color: widget.cardTextColors[index %
                                            widget.cardTextColors.length],
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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
        ),
      ],
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
