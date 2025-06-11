import 'dart:convert';

import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/screens/student/lesson_note_screens/teacher_lesson/teacher_view_lesson_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class LessonNoteEditorScreen extends StatefulWidget {
  final String noteId;
  final String spaceId;
  final String content;
  final String topic;
  final String contentId;

  const LessonNoteEditorScreen(
      {super.key,
      required this.noteId,
      required this.spaceId,
      required this.topic,
      required this.content,
      required this.contentId});
  static const String routeName = "/lesson_note_editor";
  @override
  State<LessonNoteEditorScreen> createState() => _LessonNoteEditorScreenState();
}

class _LessonNoteEditorScreenState extends State<LessonNoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  // final quill.QuillController _quillController = quill.QuillController.basic();
  late quill.QuillController _quillController;
  @override
  void initState() {
    super.initState();
    _quillController = quill.QuillController(
      document: quill.Document()..insert(0, widget.content),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  void _saveLessonNote() {
    if (_quillController.document.isEmpty()) {
      // This block runs if the document is empty (no content)
    } else {
      // This block runs if the document has content
      final content = jsonEncode(_quillController.document.toDelta().toJson());
      String getPlainTextFromQuill(quill.QuillController controller) {
        return controller.document.toPlainText();
      }

      // print(content); // Uncomment this to debug the JSON content
      if (widget.content.isEmpty) {
        // Create new lesson note
        Provider.of<LessonNotesProvider>(context, listen: false)
            .createLessonProMain(
                context: context,
                spaceId: widget.spaceId,
                noteId: widget.noteId,
                content: getPlainTextFromQuill(_quillController))
            .then((_) {
          context.push(LessonTeacherClassScreen.routeName, extra: {
            "lessonNoteId": widget.noteId,
            "spaceId": widget.spaceId,
            "topic": widget.topic,
          });
          _quillController.clear();
        });
      } else {
        // Update existing lesson note
        Provider.of<LessonNotesProvider>(context, listen: false)
            .updateLessonProMain(
                context: context,
                spaceId: widget.spaceId,
                noteId: widget.noteId,
                contentId: widget.contentId,
                content: getPlainTextFromQuill(_quillController))
            .then((_) {
          context.push(LessonTeacherClassScreen.routeName, extra: {
            "lessonNoteId": widget.noteId,
            "spaceId": widget.spaceId,
            "topic": widget.topic,
          });
          _quillController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            // Navigator.of(context).pop();
            context.push(LessonTeacherClassScreen.routeName, extra: {
              "lessonNoteId": widget.noteId,
              "spaceId": widget.spaceId,
              "topic": widget.topic,
            });
          },
        ),
        title: Text(widget.content.isEmpty
            ? 'Create Lesson Note'
            : 'Update Lesson Note'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.save),
          //   onPressed: _saveLessonNote,
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SaveButton(onPressed: _saveLessonNote),
          )
        ],
      ),
      body: Consumer<LessonNotesProvider>(builder: (context, value, _) {
        return Stack(
          children: [
            if (value.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black
                      .withOpacity(0.5), // Semi-transparent background
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          const Text(
                            "Loading...",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lesson Note Content',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        quill.QuillSimpleToolbar(
                          controller: _quillController,
                          config: const quill.QuillSimpleToolbarConfig(),
                        ),
                        // quill.QuillToolbar.simple(
                        //   controller: _quillController,
                        //   configurations:
                        //       const quill.QuillSimpleToolbarConfigurations(),
                        // ),
                        Container(
                          height: MediaQuery.of(context).size.height *
                              0.53, // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: quill.QuillEditor.basic(
                            controller: _quillController,
                            config: const quill.QuillEditorConfig(
                              padding: EdgeInsets.all(8.0),
                            ),
                          ),
                          // child: quill.QuillEditor.basic(
                          //   controller: _quillController,
                          //   configurations:
                          //       const quill.QuillEditorConfigurations(
                          //     padding: EdgeInsets.all(8.0),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class LessonPlanEditorScreen extends StatefulWidget {
  final String noteId;
  final String spaceId;
  final String content;
  final String topic;
  final String id;

  const LessonPlanEditorScreen(
      {super.key,
      required this.noteId,
      required this.spaceId,
      required this.topic,
      required this.id,
      required this.content});
  static const String routeName = "/lesson_note_plan_editor";
  @override
  State<LessonPlanEditorScreen> createState() => _LessonPlanEditorScreenState();
}

class _LessonPlanEditorScreenState extends State<LessonPlanEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  // final quill.QuillController _quillController = quill.QuillController.basic();
  late quill.QuillController _quillController;
  @override
  void initState() {
    super.initState();
    final delta = markdownToQuillDelta(widget.content);
    _quillController = quill.QuillController(
      // document: quill.Document()..insert(0, widget.content),
      document: quill.Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  quill.Delta markdownToQuillDelta(String markdownText) {
    final delta = quill.Delta();
    final lines = markdownText.split('\n');

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        delta.insert('\n'); // Empty line
        continue;
      }

      // Headings
      if (line.startsWith('# ')) {
        delta.insert(line.substring(2), {'header': 1});
        delta.insert('\n');
      } else if (line.startsWith('## ')) {
        delta.insert(line.substring(3), {'header': 2});
        delta.insert('\n');
      }
      // Bold text (e.g., **text**)
      else if (line.contains(RegExp(r'\*\*[^*]+\*\*'))) {
        final parts = line.split(RegExp(r'(\*\*[^*]+\*\*)'));
        for (var part in parts) {
          if (part.startsWith('**') && part.endsWith('**')) {
            delta.insert(part.substring(2, part.length - 2), {'bold': true});
          } else {
            delta.insert(part);
          }
        }
        delta.insert('\n');
      }
      // Bullet points
      else if (line.startsWith('- ')) {
        delta.insert(line.substring(2));
        delta.insert('\n', {'list': 'bullet'});
      }
      // Plain text
      else {
        delta.insert('$line\n');
      }
    }

    return delta;
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  void _saveLessonNote() {
    if (_quillController.document.isEmpty()) {
    } else {
      final content = jsonEncode(_quillController.document.toDelta().toJson());
      String getPlainTextFromQuill(quill.QuillController controller) {
        return controller.document.toPlainText();
      }

      final BuildContext currentContext = context;
      // print(content);
      if (widget.content.isEmpty) {
        Provider.of<LessonNotesProvider>(context, listen: false)
            .creatLessonPlanProMain(
                context: currentContext,
                spaceId: widget.spaceId,
                lessonNoteId: widget.noteId,
                lessonNotePlan: getPlainTextFromQuill(_quillController))
            .then((_) {
          context.push(LessonTeacherClassScreen.routeName, extra: {
            "lessonNoteId": widget.noteId,
            "spaceId": widget.spaceId,
            "topic": widget.topic,
          });
          _quillController.clear();
        });
      } else {
        Provider.of<LessonNotesProvider>(context, listen: false)
            .updateLessonPlanProMain(
                context: context,
                spaceId: widget.spaceId,
                id: widget.id,
                lessonNoteId: widget.noteId,
                lessonNotePlan: getPlainTextFromQuill(_quillController))
            .then((_) {
          context.push(LessonTeacherClassScreen.routeName, extra: {
            "lessonNoteId": widget.noteId,
            "spaceId": widget.spaceId,
            "topic": widget.topic,
          });
          _quillController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double dialogWidth = screenWidth * 0.95; // 90% of screen width
    final double dialogHeight = screenHeight * 0.9;
    return Scaffold(
      appBar: AppBar(
        leading: customAppBarLeadingIcon(context),
        // leading: IconButton(
        //   icon: const Icon(CupertinoIcons.back),
        //   onPressed: () {
        //     // Navigator.of(context).pop();
        //     context.push(LessonTeacherClassScreen.routeName, extra: {
        //       "lessonNoteId": widget.noteId,
        //       "spaceId": widget.spaceId,
        //       "topic": widget.topic,
        //     });
        //   },
        // ),
        title: Text(widget.content.isEmpty
            ? 'Create Lesson Plan'
            : 'Update Lesson Plan'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.save),
          //   onPressed: _saveLessonNote,
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SaveButton(onPressed: _saveLessonNote),
          )
        ],
      ),
      body: Consumer<LessonNotesProvider>(builder: (context, value, _) {
        return Stack(
          children: [
            if (value.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          const Text(
                            "Loading...",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lesson Note Content',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      quill.QuillSimpleToolbar(
                        controller: _quillController,
                        config: const quill.QuillSimpleToolbarConfig(),
                      ),
                      // quill.QuillToolbar.simple(
                      //   controller: _quillController,
                      //   configurations:
                      //       const quill.QuillSimpleToolbarConfigurations(),
                      // ),
                      Container(
                        height: MediaQuery.of(context).size.height *
                            0.53, // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: quill.QuillEditor.basic(
                          controller: _quillController,
                          config: quill.QuillEditorConfig(
                              padding: EdgeInsets.all(8.0),
                              maxHeight: dialogHeight),
                          // configurations: quill.QuillEditorConfigurations(
                          //     padding: EdgeInsets.all(8.0),
                          //     maxHeight: dialogHeight),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.save_alt, color: Colors.white, size: 16),
      label: Text(
        'Save',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF9800), // Orange color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded edges
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
