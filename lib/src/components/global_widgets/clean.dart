import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HtmlTagsCleaner {
  static String clean(String text) {
    // Replace <br>, <p>, <div>, etc. with newlines
    final newLineRegExp =
        RegExp(r"<\/?(?:br|p|div|span)\s*/?>", caseSensitive: false);

    // Remove all other HTML tags
    final otherTagsRegExp = RegExp(r"</?[^>]+>");

    // Remove Markdown-like symbols: **, __, #, `, ~~
    final markdownRegExp = RegExp(r'(\*\*|__|~~|`|#{1,6}|\*)');

    String cleanText = text
        .replaceAll(newLineRegExp, "\n")
        .replaceAll(otherTagsRegExp, "")
        .replaceAll(markdownRegExp, "")
        .replaceAll(RegExp(r"\n+"), "\n")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();

    return cleanText;
  }
}

class MarkdownNoteCard extends StatelessWidget {
  final String content;
  final String type;
  const MarkdownNoteCard({
    super.key,
    required this.type,
    required this.content,
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
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 5,
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            child: MarkdownBody(
              data: content.isNotEmpty ? content : 'No Lesson $type',
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(fontSize: 15.sp, height: 1.5, color: Colors.black),
                h1: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                h2: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                h3: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                strong: TextStyle(fontWeight: FontWeight.bold),
                em: TextStyle(fontStyle: FontStyle.italic),
                listBullet: TextStyle(fontSize: 15.sp),
                tableHead: TextStyle(fontWeight: FontWeight.bold),
                tableBody: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
