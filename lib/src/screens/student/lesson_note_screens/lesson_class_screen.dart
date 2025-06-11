import 'dart:developer';

import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/global_widgets/clean.dart';
import 'package:cloudnottapp2/src/config/config.dart';
// import 'package:cloudnottapp2/src/data/models/lesson_class_model.dart';
import 'package:cloudnottapp2/src/data/models/lesson_note_model.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:html_tags_cleaner/html_tags_cleaner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';
import 'package:html/parser.dart' show parse;
import 'package:markdown/markdown.dart' as md;
// import 'package:html2md/html2md.dart' as html2md;

// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

class LessonClassScreen extends StatefulWidget {
  const LessonClassScreen({
    super.key,
    required this.lessonClassModel,
    required this.spaceId,
    // required LessonNoteModel lessonNoteModel,
  });
  static const routeName = '/lesson_class_screen';

  final LessonNoteModel lessonClassModel;
  final String spaceId;

  @override
  State<LessonClassScreen> createState() => _LessonClassScreenState();
}

class _LessonClassScreenState extends State<LessonClassScreen> {
  // late VideoPlayerController _videoPlayerController;
  // ChewieController? _chewieController;
  // bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    Provider.of<LessonNotesProvider>(context, listen: false).fetchMyLesson(
      context: context,
      lessonNoteId: widget.lessonClassModel?.id ?? '',
      spaceId: widget.spaceId,
    );
    // _videoPlayerController = VideoPlayerController.networkUrl(
    //   Uri.parse(widget.lessonNoteModel.lessonClassModel.videoUrl),
    // );

    // _videoPlayerController.addListener(() {
    //   setState(() {});
    // });

    // _videoPlayerController.initialize().then(
    //   (_) {
    //     setState(
    //       () {
    //         isInitialized = true;
    //         _chewieController = ChewieController(
    //           videoPlayerController: _videoPlayerController,
    //           aspectRatio: _videoPlayerController.value.aspectRatio,
    //           // autoPlay: false,
    //           // looping: false,
    //           // allowFullScreen: true,
    //           // allowMuting: true,
    //           // showControlsOnInitialize: false,
    //         );
    //       },
    //     );
    //   },
    // );
  }

  // @override
  // void dispose() {
  //   _chewieController?.dispose();
  //   _videoPlayerController.dispose();
  //   super.dispose();
  // }
  bool _isCardExpanded = false;
@override
Widget build(BuildContext context) {
  
  String getValueOrNA(String? value) =>
      value?.isNotEmpty == true ? value! : 'N/A';

  return Scaffold(
    body: Consumer<LessonNotesProvider>(builder: (context, value, _) {
      log('note ${value.myLessonNote?.classNote?.content ?? ''} ${value.myLessonNote?.classGroup?.name}');
      final rawHtml = value.myLessonNote?.classNote?.content ?? 'No Lesson Note';

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
                SliverAppBar(
            expandedHeight: _isCardExpanded ? 280.h : 140.h, // Dynamic height
            pinned: false, // Keep the app bar pinned
            snap: false,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: customAppBarLeadingIcon(context),
            title: Text(
              'Lesson Note',
              style: setTextTheme(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              // Toggle button
              IconButton(
                icon: Icon(
                  _isCardExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isCardExpanded = !_isCardExpanded;
                  });
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Padding(
                padding: EdgeInsets.fromLTRB(15.r, 80.h, 15.r, 15.r),
                child: Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1E3A8A),
                          Color(0xFF3B82F6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Topic - Always visible
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${widget.lessonClassModel?.topic.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Expandable content
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: _isCardExpanded ? null : 0,
                          child: _isCardExpanded
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                        Text(formatDate(value.myLessonNote?.date ?? ''),
                                            style: TextStyle(color: Colors.white)),
                                        Text(getValueOrNA(value.myLessonNote?.week ?? ''),
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
                                        Text(
                                          getValueOrNA(value.myLessonNote?.classGroup?.name ?? ''),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          getValueOrNA(value.myLessonNote?.ageGroup ?? ''),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text('DURATION', style: TextStyle(color: Colors.white70)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          getValueOrNA(value.myLessonNote?.duration ?? ''),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
            // SliverAppBar(
            //   expandedHeight: 280.h,
            //   pinned: false, 
            //   snap: false,
            //   floating: false,
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   leading: customAppBarLeadingIcon(context),
            //   title: Text(
            //     'Lesson Note',
            //     style: setTextTheme(
            //       fontSize: 20.sp,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),
            //   flexibleSpace: FlexibleSpaceBar(
            //     collapseMode: CollapseMode.parallax,
            //     background: Padding(
            //       padding: EdgeInsets.fromLTRB(15.r, 80.h, 15.r, 15.r),
            //       child: Card(
            //         elevation: 0.0,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(15.0),
            //         ),
            //         child: Container(
            //           decoration: BoxDecoration(
            //             gradient: LinearGradient(
            //               colors: [
            //                 Color(0xFF1E3A8A),
            //                 Color(0xFF3B82F6),
            //               ],
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
            //                   Expanded(
            //                     child: Text(
            //                       '${widget.lessonClassModel?.topic.toUpperCase()}',
            //                       style: TextStyle(
            //                         fontSize: 24,
            //                         fontWeight: FontWeight.bold,
            //                         color: Colors.white,
            //                       ),
            //                       overflow: TextOverflow.ellipsis,
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
            //                   Text(formatDate(value.myLessonNote?.date ?? ''),
            //                       style: TextStyle(color: Colors.white)),
            //                   Text(getValueOrNA(value.myLessonNote?.week ?? ''),
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
            //                   Text(
            //                     getValueOrNA(value.myLessonNote?.classGroup?.name ?? ''),
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                   Text(
            //                     getValueOrNA(value.myLessonNote?.ageGroup ?? ''),
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(height: 20),
            //               Row(
            //                 children: [
            //                   Text('DURATION', style: TextStyle(color: Colors.white70)),
            //                 ],
            //               ),
            //               Row(
            //                 children: [
            //                   Text(
            //                     getValueOrNA(value.myLessonNote?.duration ?? ''),
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(15.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child:LessonNoteContent(content: value.myLessonNote?.classNote?.content ?? 'No Lesson Note'),

                    //  MarkdownBody(
                    //   data: value.myLessonNote?.classNote?.content ?? 'No Lesson Note',
                    //   styleSheet: MarkdownStyleSheet(
                    //     p: TextStyle(fontSize: 15.sp, height: 1.5, color: Colors.black),
                    //     h1: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    //     h2: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    //     h3: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    //     strong: TextStyle(fontWeight: FontWeight.bold),
                    //     em: TextStyle(fontStyle: FontStyle.italic),
                    //     listBullet: TextStyle(fontSize: 15.sp),
                    //     tableHead: TextStyle(fontWeight: FontWeight.bold),
                    //     tableBody: TextStyle(fontSize: 14.sp),
                    //   ),
                    // ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
    }),
  );
}

//   @override
//   Widget build(BuildContext context) {
//     String getValueOrNA(String? value) =>
//         value?.isNotEmpty == true ? value! : 'N/A';
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         leading: customAppBarLeadingIcon(context),
//         title: Text(
//           'Lesson Note',
//           style: setTextTheme(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: Consumer<LessonNotesProvider>(builder: (context, value, _) {
//         log('note ${value.myLessonNote?.classNote?.content ?? ''} ${value.myLessonNote?.classGroup?.name}');
//         return Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
                 
//                   Padding(
//                     padding: EdgeInsets.all(15.r),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
                     
//                         Card(
//                           elevation: 0.0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15.0),
//                           ),
//                           child: Container(
//                             width: 340.w,
//                             height: 220.h,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color(0xFF1E3A8A),
//                                   Color(0xFF3B82F6)
//                                 ], // Blue gradient
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text(
//                                         '${widget.lessonClassModel?.topic.toUpperCase()}',
//                                         style: TextStyle(
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                     ],
//                                   ),
//                                   SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('DATE',
//                                           style:
//                                               TextStyle(color: Colors.white70)),
//                                       Text('WEEK',
//                                           style:
//                                               TextStyle(color: Colors.white70)),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                           formatDate(value.myLessonNote?.date ?? ''),
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                       Text(
//                                           getValueOrNA(value.myLessonNote?.week ?? ''),
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                     ],
//                                   ),
//                                   SizedBox(height: 20),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('CLASS',
//                                           style:
//                                               TextStyle(color: Colors.white70)),
//                                       Text('AGE GROUP',
//                                           style:
//                                               TextStyle(color: Colors.white70)),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                           getValueOrNA(value.myLessonNote?.classGroup?.name ?? ''),
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                       Text(
//                                           getValueOrNA(value.myLessonNote?.ageGroup ?? ''),
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                     ],
//                                   ),
//                                   SizedBox(height: 20),
//                                   Row(
//                                     children: [
//                                       Text('DURATION',
//                                           style:
//                                               TextStyle(color: Colors.white70)),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                           getValueOrNA(value.myLessonNote?.duration ?? ''),
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
                       

// Card(
//   elevation: 0.0,
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(15.0),
//   ),
//   child: Container(
//     width: 330.w,
//     height: MediaQuery.of(context).size.height * 0.5,
//     padding: const EdgeInsets.all(16.0),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(15.0),
//       border: Border.all(color: Colors.grey[300]!),
//     ),
//     child: Scrollbar(
//       thumbVisibility: true,
//       thickness: 5,
//       radius: const Radius.circular(10),
//       child: SingleChildScrollView(
//         child: MarkdownBody(
//           data: value.myLessonNote?.classNote?.content ?? 'No Lesson Note',
//           styleSheet: MarkdownStyleSheet(
//             p: TextStyle(fontSize: 15.sp, height: 1.5, color: Colors.black),
//             h1: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
//             h2: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//             h3: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//             strong: TextStyle(fontWeight: FontWeight.bold),
//             em: TextStyle(fontStyle: FontStyle.italic),
//             listBullet: TextStyle(fontSize: 15.sp),
//             tableHead: TextStyle(fontWeight: FontWeight.bold),
//             tableBody: TextStyle(fontSize: 14.sp),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),

                  
//                         SizedBox(
//                           height: 20.h,
//                         ),
                    
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

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
}

String formatTextContent(String input) {
  // Step 1: Clean the input (remove extra spaces around Markdown symbols)
  String cleanedInput = _cleanMarkdownInput(input);

  // Step 2: Convert Markdown to HTML
  String htmlContent = md.markdownToHtml(cleanedInput);

  // Step 3: Optional - Return plain text by removing HTML tags
  // Uncomment the line below if you want plain text instead of HTML
  // return removeHtmlTags(htmlContent);

  return htmlContent; // Returns HTML by default
}

// Clean up Markdown input to handle malformed cases
String _cleanMarkdownInput(String input) {
  String cleaned = input
      .trim() // Remove leading/trailing whitespace
      .replaceAll(
          RegExp(r'\s*\*\*\s*'), '**') // Normalize spaces around bold (**)
      .replaceAll(
          RegExp(r'\s*##\s*'), '## '); // Normalize spaces around headings (##)
  return cleaned;
}

// Remove HTML tags to get plain text
String removeHtmlTags(String htmlString) {
  try {
    final document = parse(htmlString);
    final text = document.body?.text ?? '';
    return text.trim();
  } catch (e) {
    return htmlString; // Fallback to original string if parsing fails
  }
}

class LessonNoteContent extends StatelessWidget {
  final String content;

  const LessonNoteContent({super.key, required this.content});

  bool containsHtml(String content) {
    return content.contains('<') && content.contains('>');
  }

  @override
  Widget build(BuildContext context) {
    final isHtml = containsHtml(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   isHtml ? 'HTML Content' : 'Markdown Content',
        //   style: TextStyle(
        //     fontSize: 14.sp,
        //     fontWeight: FontWeight.bold,
        //     color: isHtml ? Colors.blue : Colors.green,
        //   ),
        // ),
        // const SizedBox(height: 8),
        isHtml
            ? Html(
                data: content,
                style: {
                  "p": Style(fontSize: FontSize(15.sp), lineHeight: LineHeight(1.5)),
                  "h3": Style(fontSize: FontSize(16.sp), fontWeight: FontWeight.bold),
                  "strong": Style(fontWeight: FontWeight.bold),
                  "li": Style(fontSize: FontSize(14.sp)),
                },
              )
            : MarkdownBody(
                data: content,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(fontSize: 15.sp, height: 1.5, color: Colors.black),
                  h3: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  strong: TextStyle(fontWeight: FontWeight.bold),
                  listBullet: TextStyle(fontSize: 15.sp),
                ),
              ),
      ],
    );
  }
}