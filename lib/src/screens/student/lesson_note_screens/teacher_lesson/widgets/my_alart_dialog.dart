import 'dart:developer';
import 'dart:io';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/lesson_note_model.dart';
import 'package:cloudnottapp2/src/data/providers/lesson_note_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/data/repositories/file_uploader_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void showCreateLessonNotesDialog({
  required BuildContext context,
  required String spaceId,
  required String classGroupId,
  required String termId,
  required String subjectId,
  List<Map<String, dynamic>>? initialLessons,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return CreateLessonNotesDialog(
        spaceId: spaceId,
        classGroupId: classGroupId,
        termId: termId,
        subjectId: subjectId,
        initialLessons: initialLessons,
      );
    },
  );
}

class CreateLessonNotesDialog extends StatefulWidget {
  final String spaceId;
  final String classGroupId;
  final String termId;
  final String subjectId;
  final List<Map<String, dynamic>>? initialLessons;

  const CreateLessonNotesDialog({
    super.key,
    required this.spaceId,
    required this.classGroupId,
    required this.termId,
    required this.subjectId,
    this.initialLessons,
  });

  @override
  State<CreateLessonNotesDialog> createState() =>
      _CreateLessonNotesDialogState();
}

class _CreateLessonNotesDialogState extends State<CreateLessonNotesDialog> {
  String? role;
  late List<Map<String, dynamic>> _lessons;
  late List<bool> _showAdditionalFields;
  final ImagePicker _picker = ImagePicker();
  late List<String> _statusOptions;
 
  bool get _isEditing =>
      widget.initialLessons != null && widget.initialLessons!.isNotEmpty;

  @override
  void initState() {
    super.initState();
   role = localStore.get('role', defaultValue: context.read<UserProvider>().role);

    // Initialize _statusOptions after role is set
    _statusOptions = role == 'teacher'
        ? ["draft", "pending"]
        : ["draft", "pending", "approved", "rejected"];

    if (_isEditing) {
      _lessons = widget.initialLessons!
          .map((lesson) => Map<String, dynamic>.from(lesson))
          .toList();
    } else {
      _lessons = [
        {
          "topic": "",
          "status": "draft",
          "ageGroup": "",
          "week": "",
          "date": "",
          "duration": "",
          "coverImage": "",
        },
      ];
    }
    _showAdditionalFields = List<bool>.generate(_lessons.length, (_) => false);
    // _showAdditionalFields = List<bool>.filled(_lessons.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double dialogWidth = screenWidth * 0.95;
    final double dialogHeight = screenHeight * 0.6;
    return AlertDialog(
      title: Text(
        _isEditing ? "Edit Lesson Topic" : "Create Lesson Topics",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._buildLessonFields(),
              if (!_isEditing) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Lesson"),
                    onPressed: _addNewLesson,
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        Consumer<LessonNotesProvider>(builder: (context, value, _) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2F66EE)),
            onPressed: () => _handleSubmit(
              classGroupId: widget.classGroupId,
              spaceId: widget.spaceId,
              termId: widget.termId,
              subjectId: widget.subjectId,
            ),
            child: value.isLoading
                ? SizedBox(
                    height: 10.h,
                    width: 10.h,
                    child: const CircularProgressIndicator())
                : Text(
                    _isEditing ? "Update" : "Submit",
                    style: setTextTheme(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          );
        }),
      ],
    );
  }
List<Widget> _buildLessonFields() {
  return List.generate(_lessons.length, (index) {
    final lessonNumber = _isEditing ? "" : " ${index + 1}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with topic title and remove icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Topic$lessonNumber",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            // Only show remove icon if not editing and there's more than one lesson
            if (!_isEditing && _lessons.length > 1)
              IconButton(
                onPressed: () => _removeLesson(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Remove Lesson',
              ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          "Topic",
          style: setTextTheme(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5.h),
        TextFormField(
          initialValue: _lessons[index]["topic"],
          decoration: const InputDecoration(
            hintText: "Enter Class Topic",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => _lessons[index]["topic"] = value,
        ),
        const SizedBox(height: 5),
        Text(
          "Status",
          style: setTextTheme(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5.h),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
              hintText: "Status", border: OutlineInputBorder()),
          value: _lessons[index]["status"],
          items: _statusOptions
              .map((status) => DropdownMenuItem<String>(
                  value: status, child: Text(status)))
              .toList(),
          onChanged: (value) => setState(() {
            _lessons[index]["status"] = value;
          }),
        ),
        SizedBox(height: 8.h),
        _buildAdditionalFields(index),
        // Add some spacing between lesson items
        if (index < _lessons.length - 1) 
          const Divider(height: 32, thickness: 1),
      ],
    );
  });
}

// Add this new method to handle lesson removal
void _removeLesson(int index) {
  // Show confirmation dialog before removing
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Remove Lesson'),
        content: Text(
          'Are you sure you want to remove "${_lessons[index]["topic"].isEmpty ? "this lesson" : _lessons[index]["topic"]}"?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _lessons.removeAt(index);
                _showAdditionalFields.removeAt(index);
              });
              Navigator.of(context).pop();
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lesson removed successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}



  // List<Widget> _buildLessonFields() {
  //   return List.generate(_lessons.length, (index) {
  //     final lessonNumber = _isEditing ? "" : " ${index + 1}";
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Topic$lessonNumber",
  //           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  //         ),
  //         SizedBox(height: 10.h),
  //         Text(
  //           "Topic",
  //           style: setTextTheme(fontSize: 10.sp, fontWeight: FontWeight.w400),
  //         ),
  //         SizedBox(height: 5.h),
  //         TextFormField(
  //           initialValue: _lessons[index]["topic"],
  //           decoration: const InputDecoration(
  //             hintText: "Enter Class Topic",
  //             border: OutlineInputBorder(),
  //           ),
  //           onChanged: (value) => _lessons[index]["topic"] = value,
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           "Status",
  //           style: setTextTheme(fontSize: 10.sp, fontWeight: FontWeight.w400),
  //         ),
  //         SizedBox(height: 5.h),
  //         DropdownButtonFormField<String>(
  //           decoration: const InputDecoration(
  //               hintText: "Status", border: OutlineInputBorder()),
  //           value: _lessons[index]["status"],
  //           items: _statusOptions
  //               .map((status) => DropdownMenuItem<String>(
  //                   value: status, child: Text(status)))
  //               .toList(),
  //           onChanged: (value) => setState(() {
  //             _lessons[index]["status"] = value;
  //           }),
  //         ),
  //         SizedBox(height: 8.h),
  //         _buildAdditionalFields(index),
  //       ],
  //     );
  //   });
  // }

  Widget _buildAdditionalFields(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _showAdditionalFields[index] = !_showAdditionalFields[index];
          }),
          child: Row(
            children: [
              const Text("Additional Fields",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(_showAdditionalFields[index]
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_showAdditionalFields[index]) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Age Group",
                  style: setTextTheme(
                      fontSize: 10.sp, fontWeight: FontWeight.w400)),
              SizedBox(height: 5.h),
              SizedBox(
                height: 40.h,
                child: TextFormField(
                  initialValue: _lessons[index]["ageGroup"],
                  decoration: const InputDecoration(
                    hintText: "eg, 10-12 years",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _lessons[index]["ageGroup"] = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Week",
                  style: setTextTheme(
                      fontSize: 10.sp, fontWeight: FontWeight.w400)),
              SizedBox(height: 5.h),
              SizedBox(
                height: 40.h,
                child: TextFormField(
                  initialValue: _lessons[index]["week"],
                  decoration: const InputDecoration(
                    hintText: "eg, week 1",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _lessons[index]["week"] = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date",
                  style: setTextTheme(
                      fontSize: 10.sp, fontWeight: FontWeight.w400)),
              SizedBox(height: 5.h),
              SizedBox(
                height: 40.h,
                child: TextFormField(
                  controller: TextEditingController(
                      text: formatDateForDisplay(_lessons[index]["date"])),
                  decoration: const InputDecoration(
                    hintText: "dd/mm/yyyy",
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, index),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Duration",
                  style: setTextTheme(
                      fontSize: 10.sp, fontWeight: FontWeight.w400)),
              SizedBox(height: 5.h),
              SizedBox(
                height: 40.h,
                child: TextFormField(
                  initialValue: _lessons[index]["duration"],
                  decoration: const InputDecoration(
                    hintText: "eg, 45 minutes",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _lessons[index]["duration"] = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Consumer<FileUploadNotifier>(
            builder: (context, value, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Topic Cover Image",
                      style: setTextTheme(
                          fontSize: 10.sp, fontWeight: FontWeight.w400)),
                  SizedBox(height: 5.h),
                  GestureDetector(
                    onTap: () => _pickImage(index, value),
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (value.isUploading)
                              SizedBox(
                                  height: 20.h,
                                  width: 20.h,
                                  child: const CircularProgressIndicator()),
                            if (!value.isUploading)
                              _buildImageWidget(_lessons[index]["coverImage"]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildImageWidget(String? fileUrl) {
    if (fileUrl == null || fileUrl.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Icon(Icons.image), Text('Click to Upload image here')],
      );
    } else {
      return Image.network(fileUrl, fit: BoxFit.cover);
    }
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final String formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      setState(() {
        _lessons[index]["date"] = formattedDate;
      });
    }
  }

  String formatDateForDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      // Handle different possible incoming formats
      DateTime date;
      if (dateString.contains('T')) {
        // ISO 8601 format (e.g., "2025-03-14T12:25:22.223Z")
        date = DateTime.parse(dateString);
      } else {
        // Assume dd/MM/yyyy format (e.g., "14/03/2025")
        date = DateFormat('dd/MM/yyyy').parse(dateString);
      }
      return DateFormat('dd/MM/yyyy').format(date); // Output as dd/MM/yyyy
    } catch (e) {
      debugPrint("Error formatting date: $e");
      return dateString ?? ''; // Fallback to raw string if parsing fails
    }
  }

  Future<void> _pickImage(int index, FileUploadNotifier value) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500,
      );
      if (pickedFile != null) {
        value.uploadFile(File(pickedFile.path));
        setState(() {
          _lessons[index]["coverImage"] = value.fileUrl;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick image")),
      );
    }
  }

  void _addNewLesson() {
    setState(() {
      _lessons.add({
        "topic": "",
        "status": "draft",
        "ageGroup": "",
        "week": "",
        "date": "",
        "duration": "",
        "coverImage": "",
      });
        _showAdditionalFields.add(false);
      // _showAdditionalFields.add(false);
    });
  }

  void _handleSubmit({
    required String spaceId,
    required String classGroupId,
    required String termId,
    required String subjectId,
  }) async {
    final lessonData = _lessons.map((lesson) {
      return LessonNoteData(
        topic: lesson["topic"],
        status: lesson["status"],
        ageGroup: lesson["ageGroup"],
        week: lesson["week"],
        date: formatDateForSubmission(lesson["date"]),
        duration: lesson["duration"],
        topicCover: lesson["coverImage"],
      );
    }).toList();

    final provider = Provider.of<LessonNotesProvider>(context, listen: false);
    bool success;
    if (_isEditing) {
      log(' my data ${_lessons[0]['id']}');
      success = await provider.updateLessonPro(
        context: context,
        spaceId: spaceId,
        input: LessonNoteData(
          id: _lessons[0]['id'],
          topic: _lessons[0]["topic"],
          status: _lessons[0]["status"],
          ageGroup: _lessons[0]["ageGroup"],
          week: _lessons[0]["week"],
          date: formatDateForSubmission(_lessons[0]["date"]),
          duration: _lessons[0]["duration"],
          topicCover: _lessons[0]["coverImage"],
        ), // Single lesson for update
      );
      if (success) {
        provider.fetchMyLesson(
          context: context,
          spaceId: spaceId,
          lessonNoteId: _lessons[0]['id'],
        );
        Navigator.pop(context);
        if (!_isEditing) _lessons.clear();
      }
    } else {
      success = await provider.createLessonPro(
        context: context,
        input: CreateLessonNoteRequest(
          data: lessonData,
          spaceId: spaceId,
          classGroupId: classGroupId,
          termId: termId,
          subjectId: subjectId,
        ),
      );
      Provider.of<LessonNotesProvider>(context, listen: false).fetchLessonNotes(
        spaceId: spaceId,
        input: GetLessonNotesInput(
          classGroupId: classGroupId,
          subjectId: subjectId,
          termId: termId,
        ),
      );
      Navigator.pop(context);
      _lessons.clear();
    }
  }

  String formatDateForSubmission(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "1970-01-01T00:00:00"; // Default value if null or empty
    }

    try {
      // Parse dd/MM/yyyy format
      final DateTime localDate = DateFormat('dd/MM/yyyy').parse(dateString);

      // Create a DateTime without UTC conversion
      final DateTime formattedDate =
          DateTime(localDate.year, localDate.month, localDate.day);

      return formattedDate.toIso8601String(); // Convert to ISO 8601 (without Z)
    } catch (e) {
      debugPrint("Error formatting date for submission: $e");
      return "1970-01-01T00:00:00"; // Fallback to default if parsing fails
    }
  }
}
