import 'package:cloudnottapp2/src/components/global_widgets/clean.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/lesson_note_model.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/enter_teacher_lesson.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/widgets/my_alart_dialog.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/widgets/teacher_card_lesson_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:html/parser.dart';
import 'package:html/parser.dart' show parse;
import 'package:markdown/markdown.dart' as md;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TabViewOne extends StatefulWidget {
  final LessonNoteModel? lessonClassModel;
  final String lessonId;
  final String spaceId;
  final String topic;
  final LessonNotePlan? plan;
  const TabViewOne(
      {super.key,
      required this.lessonClassModel,
      this.plan,
      required this.lessonId,
      required this.spaceId,
      required this.topic});

  @override
  State<TabViewOne> createState() => _TabViewOneState();
}
class _TabViewOneState extends State<TabViewOne> {
    bool _showCard = true;
  String getValueOrNA(String? value) =>
      value?.isNotEmpty == true ? value! : 'N/A';

 @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
          expandedHeight: _showCard ? 260.h : 80.h, // Dynamic height based on card visibility
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          floating: false,
          pinned: false,
          snap: false,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Padding(
              padding: EdgeInsets.only(top: 20.h, left: 16.r, right: 16.r),
              child: _showCard ? _buildCard() : _buildTopicHeader(),
            ),
          ),
        ),
      
        // SliverAppBar(
        //   expandedHeight: 260.h,
        //     automaticallyImplyLeading: false,
        //     toolbarHeight: 0,
        //   backgroundColor: Colors.transparent,
        //   floating: false,
        //   pinned: false,
        //   snap: false,
        //   elevation: 0,
        //   flexibleSpace: FlexibleSpaceBar(
        //     collapseMode: CollapseMode.parallax,
        //     background: Padding(
        //       padding: EdgeInsets.only(top: 20.h, left: 16.r, right: 16.r),
        //       child: Card(
        //         elevation: 0.0,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(15.0),
        //         ),
        //         child: Container(
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        //               begin: Alignment.topLeft,
        //               end: Alignment.bottomRight,
        //             ),
        //             borderRadius: BorderRadius.circular(15.0),
        //           ),
        //           padding: const EdgeInsets.all(16.0),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Row(
        //                 children: [
        //                   Flexible(
        //                     child: Text(
        //                       '${widget.lessonClassModel?.topic.toUpperCase()}',
        //                       maxLines: 1,
        //                       overflow: TextOverflow.ellipsis,
        //                       softWrap: true,
        //                       style: TextStyle(
        //                         fontSize: 24,
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.white,
        //                       ),
        //                     ),
        //                   ),
        //                   SizedBox(width: 8),
        //                   GestureDetector(
        //                     onTap: () {
        //                       showCreateLessonNotesDialog(
        //                         context: context,
        //                         spaceId: widget.spaceId,
        //                         classGroupId: context.read<LessonNotesProvider>().classId ?? '',
        //                         termId: context.read<LessonNotesProvider>().termId ?? '',
        //                         subjectId: context.read<LessonNotesProvider>().subjectId ?? '',
        //                         initialLessons: [
        //                           {
        //                             "id": widget.lessonClassModel?.id,
        //                             "topic": widget.lessonClassModel?.topic,
        //                             "status": widget.lessonClassModel?.status,
        //                             "ageGroup": widget.lessonClassModel?.ageGroup,
        //                             "week": widget.lessonClassModel?.week,
        //                             "date": widget.lessonClassModel?.date,
        //                             "duration": widget.lessonClassModel?.duration,
        //                             "coverImage": widget.lessonClassModel?.topicCover,
        //                           }
        //                         ],
        //                       );
        //                     },
        //                     child: CircleAvatar(
        //                       backgroundColor: Colors.white,
        //                       radius: 15.r,
        //                       child: Icon(Icons.edit, size: 16, color: Color(0xFF1E3A8A)),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 20),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('DATE', style: TextStyle(color: Colors.white70)),
        //                   Text('WEEK', style: TextStyle(color: Colors.white70)),
        //                 ],
        //               ),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('${formatDate(widget.lessonClassModel?.date)}',
        //                       style: TextStyle(color: Colors.white)),
        //                   Text('${getValueOrNA(widget.lessonClassModel?.week)}',
        //                       style: TextStyle(color: Colors.white)),
        //                 ],
        //               ),
        //               SizedBox(height: 20),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('CLASS', style: TextStyle(color: Colors.white70)),
        //                   Text('AGE GROUP', style: TextStyle(color: Colors.white70)),
        //                 ],
        //               ),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text('${getValueOrNA(widget.lessonClassModel?.classGroup?.name)}',
        //                       style: TextStyle(color: Colors.white)),
        //                   Text('${getValueOrNA(widget.lessonClassModel?.ageGroup)}',
        //                       style: TextStyle(color: Colors.white)),
        //                 ],
        //               ),
        //               SizedBox(height: 20),
        //               Text('DURATION', style: TextStyle(color: Colors.white70)),
        //               Text('${getValueOrNA(widget.lessonClassModel?.duration)}',
        //                   style: TextStyle(color: Colors.white)),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 10.h),
        child: LessonPlanCard(
          topic: widget.lessonClassModel?.topic ?? 'No Topic',
          content: widget.plan?.lessonNotePlan ?? '',
          noteId: widget.lessonId,
          spaceId: widget.spaceId,
          planId: widget.plan?.id ?? '',
          routeName: LessonPlanEditorScreen.routeName,
          isDarkMode: ThemeProvider().isDarkMode,
        ),
      ),
    );
  }

  Column myWrapped({required String lessonClassModel, required String title}) {
    print('myWrapped - title: $title, lessonClassModel: $lessonClassModel');
    return Column(
      children: [
        Text(title,
            style: setTextTheme(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 5.h),
        Text(lessonClassModel,
            style: setTextTheme(fontSize: 15.sp, fontWeight: FontWeight.w700)),
      ],
    );
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
      int day = dateTime.day;
      String suffix = (day % 10 == 1 && day != 11)
          ? 'st'
          : (day % 10 == 2 && day != 12)
              ? 'nd'
              : (day % 10 == 3 && day != 13)
                  ? 'rd'
                  : 'th';
      return '$day$suffix ${DateFormat('MMM yyyy').format(dateTime)}';
    } catch (e) {
      return 'N/A';
    }
  }
   Widget _buildCard() {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${widget.lessonClassModel?.topic.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showCreateLessonNotesDialog(
                      context: context,
                      spaceId: widget.spaceId,
                      classGroupId: context.read<LessonNotesProvider>().classId ?? '',
                      termId: context.read<LessonNotesProvider>().termId ?? '',
                      subjectId: context.read<LessonNotesProvider>().subjectId ?? '',
                      initialLessons: [
                        {
                          "id": widget.lessonClassModel?.id,
                          "topic": widget.lessonClassModel?.topic,
                          "status": widget.lessonClassModel?.status,
                          "ageGroup": widget.lessonClassModel?.ageGroup,
                          "week": widget.lessonClassModel?.week,
                          "date": widget.lessonClassModel?.date,
                          "duration": widget.lessonClassModel?.duration,
                          "coverImage": widget.lessonClassModel?.topicCover,
                        }
                      ],
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15.r,
                    child: Icon(Icons.edit, size: 16, color: Color(0xFF1E3A8A)),
                  ),
                ),
                SizedBox(width: 8),
                // Toggle button to hide card
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCard = false;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 15.r,
                    child: Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DATE', style: TextStyle(color: Colors.white70)),
                Text('WEEK', style: TextStyle(color: Colors.white70)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${formatDate(widget.lessonClassModel?.date)}',
                    style: TextStyle(color: Colors.white)),
                Text('${getValueOrNA(widget.lessonClassModel?.week)}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CLASS', style: TextStyle(color: Colors.white70)),
                Text('AGE GROUP', style: TextStyle(color: Colors.white70)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${getValueOrNA(widget.lessonClassModel?.classGroup?.name)}',
                    style: TextStyle(color: Colors.white)),
                Text('${getValueOrNA(widget.lessonClassModel?.ageGroup)}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 20),
            Text('DURATION', style: TextStyle(color: Colors.white70)),
            Text('${getValueOrNA(widget.lessonClassModel?.duration)}',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // Build the compact topic header when _showCard is false
  Widget _buildTopicHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.lessonClassModel?.topic.toUpperCase()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showCreateLessonNotesDialog(
                context: context,
                spaceId: widget.spaceId,
                classGroupId: context.read<LessonNotesProvider>().classId ?? '',
                termId: context.read<LessonNotesProvider>().termId ?? '',
                subjectId: context.read<LessonNotesProvider>().subjectId ?? '',
                initialLessons: [
                  {
                    "id": widget.lessonClassModel?.id,
                    "topic": widget.lessonClassModel?.topic,
                    "status": widget.lessonClassModel?.status,
                    "ageGroup": widget.lessonClassModel?.ageGroup,
                    "week": widget.lessonClassModel?.week,
                    "date": widget.lessonClassModel?.date,
                    "duration": widget.lessonClassModel?.duration,
                    "coverImage": widget.lessonClassModel?.topicCover,
                  }
                ],
              );
            },
            child: CircleAvatar(
              backgroundColor: Color(0xFF1E3A8A).withOpacity(0.1),
              radius: 15.r,
              child: Icon(Icons.edit, size: 16, color: Color(0xFF1E3A8A)),
            ),
          ),
          SizedBox(width: 8),
          // Toggle button to show card
          GestureDetector(
            onTap: () {
              setState(() {
                _showCard = true;
              });
            },
            child: CircleAvatar(
              backgroundColor: Color(0xFF1E3A8A).withOpacity(0.1),
              radius: 15.r,
              child: Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF1E3A8A)),
            ),
          ),
        ],
      ),
    );
  }

}

class TabViewTwo extends StatefulWidget {
  final LessonNoteModel? lessonClassModel;
  final String lessonId;
  final String spaceId;
  final String topic;
  const TabViewTwo(
      {super.key,
      required this.lessonClassModel,
      required this.lessonId,
      required this.spaceId,
      required this.topic});

  @override
  State<TabViewTwo> createState() => _TabViewTwoState();
}

class _TabViewTwoState extends State<TabViewTwo> {
  bool _showCard = true;
  String getValueOrNA(String? value) =>
      value?.isNotEmpty == true ? value! : 'N/A';

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
         SliverAppBar(
          expandedHeight: _showCard ? 260.h : 80.h, // Dynamic height based on card visibility
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          floating: false,
          pinned: false,
          snap: false,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Padding(
              padding: EdgeInsets.only(top: 20.h, left: 16.r, right: 16.r),
              child: _showCard ? _buildCard() : _buildTopicHeader(),
            ),
          ),
        ),
        // SliverAppBar(
        //   expandedHeight: 260.h, // Same height as the first one
        //   automaticallyImplyLeading: false,
        //   toolbarHeight: 0,
        //   backgroundColor: Colors.transparent,
        //   floating: false,
        //   pinned: false,
        //   snap: false,
        //   elevation: 0,
        //   flexibleSpace: FlexibleSpaceBar(
        //     collapseMode: CollapseMode.parallax,
        //     background: Padding(
        //       padding: EdgeInsets.only(top: 20.h, left: 16.r, right: 16.r),
        //       child: Card(
        //         elevation: 0.0,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(15.0),
        //         ),
        //         child: Container(
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        //               begin: Alignment.topLeft,
        //               end: Alignment.bottomRight,
        //             ),
        //             borderRadius: BorderRadius.circular(15.0),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.all(16.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Row(
        //                   children: [
        //                     Flexible(
        //                       child: Text(
        //                         '${widget.lessonClassModel?.topic.toUpperCase()}',
        //                         maxLines: 1,
        //                         overflow: TextOverflow.ellipsis,
        //                         softWrap: true,
        //                         style: TextStyle(
        //                           fontSize: 24,
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                         ),
        //                       ),
        //                     ),
        //                     SizedBox(width: 8),
        //                     GestureDetector(
        //                       onTap: () {
        //                         showCreateLessonNotesDialog(
        //                           context: context,
        //                           spaceId: widget.spaceId,
        //                           classGroupId: context.read<LessonNotesProvider>().classId ?? '',
        //                           termId: context.read<LessonNotesProvider>().termId ?? '',
        //                           subjectId: context.read<LessonNotesProvider>().termId ?? '',
        //                           initialLessons: [
        //                             {
        //                               "id": widget.lessonClassModel?.id,
        //                               "topic": widget.lessonClassModel?.topic,
        //                               "status": widget.lessonClassModel?.status,
        //                               "ageGroup": widget.lessonClassModel?.ageGroup,
        //                               "week": widget.lessonClassModel?.week,
        //                               "date": widget.lessonClassModel?.date,
        //                               "duration": widget.lessonClassModel?.duration,
        //                               "coverImage": widget.lessonClassModel?.topicCover,
        //                             }
        //                           ],
        //                         );
        //                       },
        //                       child: CircleAvatar(
        //                         backgroundColor: Colors.white,
        //                         radius: 15.r,
        //                         child: Icon(Icons.edit, size: 16, color: Color(0xFF1E3A8A)),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 SizedBox(height: 20),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Text('DATE', style: TextStyle(color: Colors.white70)),
        //                     Text('WEEK', style: TextStyle(color: Colors.white70)),
        //                   ],
        //                 ),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Text('${formatDate(widget.lessonClassModel?.date)}',
        //                         style: TextStyle(color: Colors.white)),
        //                     Text('${getValueOrNA(widget.lessonClassModel?.week)}',
        //                         style: TextStyle(color: Colors.white)),
        //                   ],
        //                 ),
        //                 SizedBox(height: 20),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Text('CLASS', style: TextStyle(color: Colors.white70)),
        //                     Text('AGE GROUP', style: TextStyle(color: Colors.white70)),
        //                   ],
        //                 ),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Text('${getValueOrNA(widget.lessonClassModel?.classGroup?.name)}',
        //                         style: TextStyle(color: Colors.white)),
        //                     Text('${getValueOrNA(widget.lessonClassModel?.ageGroup)}',
        //                         style: TextStyle(color: Colors.white)),
        //                   ],
        //                 ),
        //                 SizedBox(height: 20),
        //                 Text('DURATION', style: TextStyle(color: Colors.white70)),
        //                 Text('${getValueOrNA(widget.lessonClassModel?.duration)}',
        //                     style: TextStyle(color: Colors.white)),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 10.h),
        child: LessonNoteCard(
          topic: widget.lessonClassModel?.topic ?? 'No Topic',
          content: widget.lessonClassModel?.classNote?.content ?? '',
          noteId: widget.lessonId,
          spaceId: widget.spaceId,
          contentId: widget.lessonClassModel?.classNote?.id ?? '',
          routeName: LessonNoteEditorScreen.routeName,
        ),
      ),
    );
    
  }



  Column myWrapped({required String lessonClassModel, required String title}) {
    print('myWrapped - title: $title, lessonClassModel: $lessonClassModel');
    return Column(
      children: [
        Text(title,
            style: setTextTheme(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 5.h),
        Text(lessonClassModel,
            style: setTextTheme(fontSize: 15.sp, fontWeight: FontWeight.w700)),
      ],
    );
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
      int day = dateTime.day;
      String suffix = (day % 10 == 1 && day != 11)
          ? 'st'
          : (day % 10 == 2 && day != 12)
              ? 'nd'
              : (day % 10 == 3 && day != 13)
                  ? 'rd'
                  : 'th';
      return '$day$suffix ${DateFormat('MMM yyyy').format(dateTime)}';
    } catch (e) {
      return 'N/A';
    }
  }
   Widget _buildCard() {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${widget.lessonClassModel?.topic.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showCreateLessonNotesDialog(
                      context: context,
                      spaceId: widget.spaceId,
                      classGroupId: context.read<LessonNotesProvider>().classId ?? '',
                      termId: context.read<LessonNotesProvider>().termId ?? '',
                      subjectId: context.read<LessonNotesProvider>().subjectId ?? '',
                      initialLessons: [
                        {
                          "id": widget.lessonClassModel?.id,
                          "topic": widget.lessonClassModel?.topic,
                          "status": widget.lessonClassModel?.status,
                          "ageGroup": widget.lessonClassModel?.ageGroup,
                          "week": widget.lessonClassModel?.week,
                          "date": widget.lessonClassModel?.date,
                          "duration": widget.lessonClassModel?.duration,
                          "coverImage": widget.lessonClassModel?.topicCover,
                        }
                      ],
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15.r,
                    child: Icon(Icons.edit, size: 16, color: Color(0xFF1E3A8A)),
                  ),
                ),
                SizedBox(width: 8),
                // Toggle button to hide card
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showCard = false;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 15.r,
                    child: Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DATE', style: TextStyle(color: Colors.white70)),
                Text('WEEK', style: TextStyle(color: Colors.white70)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${formatDate(widget.lessonClassModel?.date)}',
                    style: TextStyle(color: Colors.white)),
                Text('${getValueOrNA(widget.lessonClassModel?.week)}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CLASS', style: TextStyle(color: Colors.white70)),
                Text('AGE GROUP', style: TextStyle(color: Colors.white70)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${getValueOrNA(widget.lessonClassModel?.classGroup?.name)}',
                    style: TextStyle(color: Colors.white)),
                Text('${getValueOrNA(widget.lessonClassModel?.ageGroup)}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 20),
            Text('DURATION', style: TextStyle(color: Colors.white70)),
            Text('${getValueOrNA(widget.lessonClassModel?.duration)}',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // Build the compact topic header when _showCard is false
  Widget _buildTopicHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.lessonClassModel?.topic.toUpperCase()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showCreateLessonNotesDialog(
                context: context,
                spaceId: widget.spaceId,
                classGroupId: context.read<LessonNotesProvider>().classId ?? '',
                termId: context.read<LessonNotesProvider>().termId ?? '',
                subjectId: context.read<LessonNotesProvider>().subjectId ?? '',
                initialLessons: [
                  {
                    "id": widget.lessonClassModel?.id,
                    "topic": widget.lessonClassModel?.topic,
                    "status": widget.lessonClassModel?.status,
                    "ageGroup": widget.lessonClassModel?.ageGroup,
                    "week": widget.lessonClassModel?.week,
                    "date": widget.lessonClassModel?.date,
                    "duration": widget.lessonClassModel?.duration,
                    "coverImage": widget.lessonClassModel?.topicCover,
                  }
                ],
              );
            },
            child: CircleAvatar(
              backgroundColor: Color(0xFF1E3A8A).withOpacity(0.1),
              radius: 15.r,
              child: Icon(Icons.edit, size: 16, color: Color(0xFF1E3A8A)),
            ),
          ),
          SizedBox(width: 8),
          // Toggle button to show card
          GestureDetector(
            onTap: () {
              setState(() {
                _showCard = true;
              });
            },
            child: CircleAvatar(
              backgroundColor: Color(0xFF1E3A8A).withOpacity(0.1),
              radius: 15.r,
              child: Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF1E3A8A)),
            ),
          ),
        ],
      ),
    );
  }

}

// String removeHtmlTags(String htmlString) {
//   try {
//     final document = parse(htmlString);

//     final text = document.body?.text ?? '';

//     return text.trim();
//   } catch (e) {
//     return htmlString;
//   }
// }

String formatTextContent(String input) {
  // First, remove any HTML tags
  String cleanedHtml = removeHtmlTags(input);

  // Convert Markdown to HTML
  String htmlContent = md.markdownToHtml(cleanedHtml);

  // Optional: If you want plain text without any formatting
  // String plainText = removeHtmlTags(htmlContent);
  // return plainText;

  return htmlContent;
}

String removeHtmlTags(String htmlString) {
  try {
    final document = parse(htmlString);
    // final text = document.body?.text ?? '';
    final String parsedString =
        parse(document.body?.text).documentElement?.text ?? '';
    // return text.trim();
    return parsedString;
  } catch (e) {
    return htmlString;
  }
}
