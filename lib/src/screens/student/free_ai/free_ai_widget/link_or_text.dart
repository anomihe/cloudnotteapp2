import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_widget/awaiting_topic.dart';

class LinkOrText extends StatefulWidget {
  final Function(String) onSubmit; // For submitting URLs
  final Function(String) onAddNote; // For submitting notes

  const LinkOrText({
    super.key,
    required this.onSubmit,
    required this.onAddNote,
  });

  @override
  State<LinkOrText> createState() => _LinkOrTextState();
}

class _LinkOrTextState extends State<LinkOrText> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isUrlFieldActive = true; // Track which field is being used

  @override
  void dispose() {
    _urlController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    final urlText = _urlController.text.trim();
    final noteText = _noteController.text.trim();

    if (noteText.isEmpty && urlText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a link or note")),
      );
      return;
    }

    // Show the AwaitingTopic modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext modalContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: const AwaitingTopic(),
          ),
        );
      },
    );

    try {
      if (noteText.isNotEmpty) {
        await widget.onAddNote(noteText); // Submit note
      } else if (urlText.isNotEmpty) {
        await widget.onSubmit(urlText); // Submit URL
      }
      // Close the parent dialog after successful submission
      if (mounted) {
        Navigator.of(context).pop(); // Close the LinkOrText dialog
      }
    } catch (e) {
      // Show error if submission fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submission failed: $e")),
        );
      }
    } finally {
      // Dismiss the AwaitingTopic modal
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Close the AwaitingTopic modal
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.link,
                    weight: 700,
                    size: 20.sp,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'YouTube, TikTok, Etc.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20.sp),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Text(
            "Enter a YouTube Link, Pdf, Docx, Etc",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'https://youtu.be/dQw4w9WgXcQ',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            maxLines: 1,
            onTap: () {
              setState(() {
                _isUrlFieldActive = true;
              });
            },
            onChanged: (value) {
              setState(() {
                _isUrlFieldActive = true;
              });
            },
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider(color: Colors.grey)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  "or",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                Icons.note,
                weight: 700,
                size: 20.sp,
                color: Colors.black,
              ),
              SizedBox(width: 8.w),
              Text(
                'Paste Text',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "Copy and paste text to add as content",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: 'Paste your notes here',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            maxLines: 3,
            onTap: () {
              setState(() {
                _isUrlFieldActive = false;
              });
            },
            onChanged: (value) {
              setState(() {
                _isUrlFieldActive = false;
              });
            },
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Add',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
