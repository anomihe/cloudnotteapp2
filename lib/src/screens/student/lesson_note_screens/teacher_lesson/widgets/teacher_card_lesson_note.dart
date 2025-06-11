import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LessonNoteCard extends StatelessWidget {
  final String topic;
  final String? content;
  final String? noteId;
  final String? spaceId;
  final String? contentId;
  final String routeName;

  const LessonNoteCard({
    super.key,
    required this.topic,
    required this.routeName,
    this.content,
    this.noteId,
    this.spaceId,
    this.contentId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 330.w,
        height: 330.h,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      topic.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Click to Add Lesson',
                    child: IconButton(
                      onPressed: () {
                        context.push(
                          routeName,
                          extra: {
                            'noteId': noteId ?? '',
                            'spaceId': spaceId ?? '',
                            'topic': topic,
                            'contentId': contentId ?? '',
                            'content': content ?? '',
                          },
                        );
                      },
                      icon: const ImageIcon(
                        AssetImage('assets/icons/lucide_edit.png'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              /// Markdown Content
              content != null && content!.isNotEmpty
                  ? MarkdownBody(
                      data: content!,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.4.h,
                          color: Colors.black,
                        ),
                        h3: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        strong: TextStyle(fontWeight: FontWeight.bold),
                        em: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )
                  : Text(
                      'No Lesson Note',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54,
                        height: 1.4.h,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}



class LessonPlanCard extends StatelessWidget {
  final String topic;
  final String? content;
  final String? noteId;
  final String? spaceId;
  final String? planId;
  final String routeName;
  final bool isDarkMode;

  const LessonPlanCard({
    super.key,
    required this.topic,
    required this.routeName,
    this.content,
    this.noteId,
    this.spaceId,
    this.planId,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 330.w,
        height: 330.h,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      topic.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Click to Add Plan',
                    child: IconButton(
                      onPressed: () {
                        context.push(
                          routeName,
                          extra: {
                            'noteId': noteId ?? '',
                            'spaceId': spaceId ?? '',
                            'topic': topic,
                            'id': planId ?? '',
                            'content': content ?? '',
                          },
                        );
                      },
                      icon: ImageIcon(
                        const AssetImage('assets/icons/lucide_edit.png'),
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              /// Markdown Content
              content != null && content!.isNotEmpty
                  ? MarkdownBody(
                      data: content!.replaceAll('#', ''),
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.4.h,
                        ),
                      ),
                    )
                  : Text(
                      'No Lesson Plan',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        height: 1.4.h,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}