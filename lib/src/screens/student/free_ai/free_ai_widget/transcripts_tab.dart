import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/awaiting_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TranscriptsTab extends StatelessWidget {
  const TranscriptsTab({
    Key? key,
    required this.transcripts,
    required this.structureText,
  }) : super(key: key);

  final List<dynamic> transcripts;
  final List<Map<String, String>> Function(String) structureText;

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
                Text(
                  "Transcripts",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 10.h),
                transcripts.isEmpty
                    ? const Center(child: Text('No transcripts available.'))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: transcripts.map((transcript) {
                          final text = transcript['content'] as String? ??
                              'No transcript content available';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: structureText(text).map((item) {
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
