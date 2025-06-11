import 'package:cloudnottapp2/src/data/models/free_ai_model.dart'; // Correct import
import 'package:cloudnottapp2/src/data/providers/free_ai_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({Key? key, required this.sessionId}) : super(key: key);

  final String sessionId;

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final TextEditingController _noteController = TextEditingController();
  bool _isAddingNote = false;

  void _addNote() async {
    if (_noteController.text.trim().isEmpty) return;
    setState(() {
      _isAddingNote = true;
    });
    final provider = Provider.of<FreeAiProvider>(context, listen: false);
    await provider.addNoteToSession(
        context, widget.sessionId, _noteController.text);
    if (mounted) {
      setState(() {
        _isAddingNote = false;
        _noteController.clear();
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FreeAiProvider>(
      builder: (context, provider, child) {
        final topic = provider.userAddedTopics.firstWhere(
          (t) => t.sessionId == widget.sessionId,
          orElse: () => FreeAiModel.empty(), // Use FreeAiModel.empty()
        );
        final note = topic.note ?? 'No notes available.';

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
                      "Notes",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Text(
                        note,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: 'Add a note...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _isAddingNote ? null : _addNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                        ),
                        child: _isAddingNote
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Add Note',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
