import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/enter_teacher_lesson.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_view_lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../config/config.dart';
import '../../../../data/providers/ai_provider.dart';

class GeneratedContentScreen extends StatefulWidget {
  static String routeName = '/ai_generated';
  final String topic;
  final String mode;
  final String noteId;
  final String spaceId;
  final String subject;
  final int index;
  final String classGroup;
  final String id;
  final String contentId;
  final String content;

  const GeneratedContentScreen({
    super.key,
    required this.topic,
    required this.noteId,
    required this.spaceId,
    required this.subject,
    required this.index,
    required this.classGroup,
    required this.id,
    required this.contentId,
    required this.mode,
    required this.content,
  });

  @override
  State<GeneratedContentScreen> createState() => _GeneratedContentScreenState();
}

class _GeneratedContentScreenState extends State<GeneratedContentScreen> {
  String _selectedTone = "BALANCED";
  bool _includeImages = false;
  @override
  void initState() {
    super.initState();
    debugPrint('Topic: ${widget.topic}');
    debugPrint('Mode: ${widget.mode}');
    debugPrint('Note ID: ${widget.noteId}');
    debugPrint('Space ID: ${widget.spaceId}');
    debugPrint('Subject: ${widget.subject}');
    debugPrint('Index: ${widget.index}');
    debugPrint('Class Group: ${widget.classGroup}');
    debugPrint('ID: ${widget.id}');
    debugPrint('Content ID: ${widget.contentId}');
    debugPrint('Content: ${widget.content}');
    _generateContent();
  }

  void _generateContent() {
    Provider.of<AiContentProvider>(context, listen: false).generateContent(
      mode: widget.mode,
      tone: _selectedTone,
      topic: widget.topic,
      subject: widget.subject,
      classGroup: widget.classGroup,
      includeImages: _includeImages,
    );
  }

// enabled: aiProvider.isGenerating,
  @override
  Widget build(BuildContext context) {
    return Consumer<AiContentProvider>(
      builder: (context, aiProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("cloudnottapp2 Ai"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tone Selection
                const Text(
                  "Choose Your Lesson Note Tone",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "You can choose how you want your class note to sound",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ToneButton(
                      label: "More Creative",
                      isSelected: _selectedTone == "CREATIVE",
                      onPressed: aiProvider.isGenerating
                          ? null
                          : () {
                              setState(() {
                                _selectedTone = "CREATIVE";
                              });
                              _generateContent();
                            },
                    ),
                    _ToneButton(
                      label: "More Balanced",
                      isSelected: _selectedTone == "BALANCED",
                      onPressed: aiProvider.isGenerating
                          ? null
                          : () {
                              setState(() {
                                _selectedTone = "BALANCED";
                              });
                              _generateContent();
                            },
                    ),
                    _ToneButton(
                      label: "More Precise",
                      isSelected: _selectedTone == "FORMAL",
                      onPressed: aiProvider.isGenerating
                          ? null
                          : () {
                              setState(() {
                                _selectedTone = "FORMAL";
                              });
                              _generateContent();
                            },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  "Add Images Where Necessary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Yes, Assistant will return results with images",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _ImageOptionButton(
                        label: "No",
                        isSelected: !_includeImages,
                        onPressed: aiProvider.isGenerating
                            ? null
                            : () {
                                setState(() {
                                  _includeImages = false;
                                });
                                _generateContent();
                              },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ImageOptionButton(
                        label: "Yes",
                        isSelected: _includeImages,
                        onPressed: aiProvider.isGenerating
                            ? null
                            : () {
                                setState(() {
                                  _includeImages = true;
                                });
                                _generateContent();
                              },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Content Display
                Expanded(
                  child: aiProvider.isGenerating
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Grab your popcorn 🍿",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Hold on, we are generating content",
                                    style: setTextTheme(
                                      fontSize: 16.sp,
                                      color: darkShades[0],
                                      fontWeight: FontWeight.w600,
                                      lineHeight: 1.4.h,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue
                                              .withOpacity(0.4), // Soft glow
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.5),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween<double>(
                                            begin: 0, end: aiProvider.progress),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        builder: (context, value, child) {
                                          return ShaderMask(
                                            shaderCallback: (bounds) =>
                                                LinearGradient(
                                              colors: [
                                                Colors.blue,
                                                Colors.cyan
                                              ], // Gradient effect
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ).createShader(bounds),
                                            child: LinearProgressIndicator(
                                              value: value,
                                              backgroundColor:
                                                  Colors.blue.withOpacity(0.2),
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Skeletonizer(
                                enabled: true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Simulating a title
                                    Container(
                                      width: double.infinity,
                                      height: 24,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Simulating lines of text
                                    ...List.generate(
                                      5,
                                      (index) => Container(
                                        width: double.infinity,
                                        height: 14,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Simulating an image or large section
                                    Container(
                                      width: double.infinity,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              // Skeletonizer(
                              //   child: Container(
                              //     height: 300,
                              //     color: Colors.grey[300],
                              //     child: const Text(
                              //       "Placeholder content for skeleton effect",
                              //       style: TextStyle(fontSize: 16),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      : aiProvider.aiError.isNotEmpty
                          ? Center(
                              child: Text(
                                'Error: ${aiProvider.aiError}',
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                              ),
                            )
                          : aiProvider.aiResult.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No content generated yet.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            aiProvider.aiResult,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            if (widget.index == 0) {
                                              context.push(
                                                LessonPlanEditorScreen
                                                    .routeName,
                                                extra: {
                                                  'noteId': widget.noteId,
                                                  'spaceId': widget.spaceId,
                                                  'topic': widget.topic,
                                                  "id": widget.id ?? '',
                                                  "content":
                                                      aiProvider.aiResult ?? '',
                                                },
                                              );
                                            } else {
                                              context.push(
                                                LessonNoteEditorScreen
                                                    .routeName,
                                                extra: {
                                                  'noteId': widget.noteId,
                                                  'spaceId': widget.spaceId,
                                                  'topic': widget.topic,
                                                  "contentId":
                                                      widget.contentId ?? '',
                                                  "content":
                                                      aiProvider.aiResult,
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                ),

                if (!aiProvider.isGenerating &&
                    aiProvider.aiResult.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        _ActionButton(
                          icon: Icons.add,
                          label: widget.index==0? "Insert into My plan": "Insert into My Note",
                          onPressed: () {
                            if (widget.index == 0) {
                              widget.content.isNotEmpty
                                  ? Provider.of<LessonNotesProvider>(context,
                                          listen: false)
                                      .updateLessonPlanProMain(
                                          context: context,
                                          spaceId: widget.spaceId,
                                          id: widget.id,
                                          lessonNoteId: widget.noteId,
                                          lessonNotePlan: aiProvider.aiResult)
                                      .then((_) {
                                      context.push(
                                          LessonTeacherClassScreen.routeName,
                                          extra: {
                                            "lessonNoteId": widget.noteId,
                                            "spaceId": widget.spaceId,
                                            "topic": widget.topic,
                                          });
                                    })
                                  : Provider.of<LessonNotesProvider>(context,
                                          listen: false)
                                      .creatLessonPlanProMain(
                                          context: context,
                                          spaceId: widget.spaceId,
                                          lessonNoteId: widget.noteId,
                                          lessonNotePlan: aiProvider.aiResult)
                                      .then((_) {
                                      context.push(
                                          LessonTeacherClassScreen.routeName,
                                          extra: {
                                            "lessonNoteId": widget.noteId,
                                            "spaceId": widget.spaceId,
                                            "topic": widget.topic,
                                          });
                                    });
                            } else {
                              widget.content.isNotEmpty
                                  ? Provider.of<LessonNotesProvider>(context,
                                          listen: false)
                                      .updateLessonProMain(
                                          context: context,
                                          spaceId: widget.spaceId,
                                          noteId: widget.noteId,
                                          contentId: widget.contentId,
                                          content: aiProvider.aiResult)
                                      .then((_) {
                                      context.push(
                                          LessonTeacherClassScreen.routeName,
                                          extra: {
                                            "lessonNoteId": widget.noteId,
                                            "spaceId": widget.spaceId,
                                            "topic": widget.topic,
                                          });
                                    })
                                  : Provider.of<LessonNotesProvider>(context,
                                          listen: false)
                                      .createLessonProMain(
                                          context: context,
                                          spaceId: widget.spaceId,
                                          noteId: widget.noteId,
                                          content: aiProvider.aiResult)
                                      .then((_) {
                                      context.push(
                                          LessonTeacherClassScreen.routeName,
                                          extra: {
                                            "lessonNoteId": widget.noteId,
                                            "spaceId": widget.spaceId,
                                            "topic": widget.topic,
                                          });
                                    });
                            }
                          },
                        ),
                        _ActionButton(
                          icon: Icons.refresh,
                          label: "Regenerate",
                          onPressed: () {
                            _generateContent();
                          },
                        ),
                        _ActionButton(
                          icon: Icons.copy,
                          label: "Copy Response",
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: aiProvider.aiResult));
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                message: "Result Copied to clipBoard",
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Tone Button Widget
class _ToneButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;

  const _ToneButton({
    required this.label,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
            foregroundColor: isSelected ? Colors.white : Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
      ),
    );
  }
}

// Custom Image Option Button Widget
class _ImageOptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;

  const _ImageOptionButton({
    required this.label,
    required this.isSelected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}

// Custom Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
