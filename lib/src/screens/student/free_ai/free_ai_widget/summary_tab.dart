import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/awaiting_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryTab extends StatelessWidget {
  const SummaryTab({
    Key? key,
    required this.isLoadingSummary,
    this.summary,
    required this.structureText,
    required this.onReload, // New field for reload
  }) : super(key: key);

  final bool isLoadingSummary;
  final String? summary;
  final List<Map<String, String>> Function(String) structureText;
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
                      "Summary",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, size: 24.sp),
                      onPressed: onReload,
                      tooltip: 'Reload Summary',
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                isLoadingSummary
                    ? const AwaitingContent(contentType: 'summary')
                    : summary == null || summary!.isEmpty
                        ? const Center(child: Text('No summary available.'))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: structureText(summary!).map((item) {
                              if (item['type'] == 'heading') {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                      item['content']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        (0.6 + (item['content']!.length / 100)),
                                    child: Text(
                                      item['content']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                );
                              }
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
