import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/awaiting_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChaptersTab extends StatelessWidget {
  const ChaptersTab({
    Key? key,
    required this.isLoadingChapters,
    required this.chapters,
    required this.onReload,
  }) : super(key: key);

  final bool isLoadingChapters;
  final List<Map<String, dynamic>> chapters;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: 10.h,
      ),
      child: Scrollbar(
        thickness: 3,
        radius: const Radius.circular(5),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chapters",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, size: 24.sp),
                      onPressed: onReload,
                      tooltip: 'Reload Chapters',
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                isLoadingChapters
                    ? const AwaitingContent(contentType: 'chapters')
                    : chapters.isEmpty
                        ? const Center(child: Text('No chapters available.'))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: chapters.asMap().entries.map((entry) {
                              final index = entry.key;
                              final chapter = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ${chapter['title'] ?? 'Chapter ${index + 1}'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    if (chapter['startTime'] != null)
                                      Text(
                                        'Start Time: ${chapter['startTime']}s',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    if (chapter['pageNumber'] != null)
                                      Text(
                                        'Page: ${chapter['pageNumber']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      chapter['summary'] ??
                                          'No summary available.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
