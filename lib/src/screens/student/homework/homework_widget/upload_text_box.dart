import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/exam_session_model.dart';
import '../../../../data/providers/exam_home_provider.dart';
import '../../../../data/providers/user_provider.dart';
import '../../../../data/repositories/file_uploader_provider.dart';

// import 'package:quill_html_editor/quill_html_editor.dart';

class UploadTextBox extends StatefulWidget {
  UploadTextBox({
    super.key,
    this.onAddFileOrText,
    this.fileName,
    this.readOnly = false,
    required this.node,
    required this.examId,
    required this.spaceId,
    required this.examGroupId,
    required this.questionId,
    required this.examSessionId,
    required this.myAnswer,
  });
final Function(String? newFileName, String? newText)? onAddFileOrText;
  // final void Function(String?)? onAddFileOrText;
  final String? fileName;
  final bool readOnly;
  final FocusNode node;
  final String examId;
  final String spaceId;
  final String examGroupId;
  final String questionId;
  final String examSessionId;
  String myAnswer;

  @override
  State<UploadTextBox> createState() => _UploadTextBoxState();
}

class _UploadTextBoxState extends State<UploadTextBox> {
  String? fileName;
   bool _isInitialized = false;
  bool _isUserEditing = false;
  // final quill.QuillController _controller = quill.QuillController.basic();
  late quill.QuillController _controller;
  ScrollController _scrollController = ScrollController();
  // Method to pick a file
 String? _currentTextAnswer;
  String? _currentFileUrl;
   List<String> _currentResources = [];
  @override
  void dispose() {
    _scrollController.dispose();
    widget.node.removeListener(_onFocusChange);
    super.dispose();
  }

  // Future<void> _pickFile() async {
  //   widget.node.unfocus();
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx'],
  //   );
  //   if (result != null) {
  //     setState(() {
  //       fileName = result.files.single.name;
  //     });
  //     Provider.of<FileUploadNotifier>(context, listen: false)
  //         .uploadFile(File(result.files.single.path!));
  //     widget.onAddFileOrText!(
  //         result.files.single.name, _currentTextAnswer); //notifies parent of the change
  //   }
  // }

  Future<void> _pickFile() async {
    widget.node.unfocus();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      // Show loading state or indicator if needed
      setState(() {
        fileName = "Uploading ${result.files.single.name}...";
      });
      
      // Upload file and wait for the result
      await Provider.of<FileUploadNotifier>(context, listen: false)
          .uploadFile(File(result.files.single.path!));
          
      // Now check for the file URL after upload is complete
      final fileUrl = Provider.of<FileUploadNotifier>(context, listen: false).fileUrl;
      
      if (fileUrl != null && fileUrl.isNotEmpty) {
        setState(() {
          // Only display the URL, not the filename
          fileName = fileUrl;
          _currentFileUrl = fileUrl;
          _currentResources = [fileUrl];
        });
        
        // Notify parent with the URL and current text
        if (widget.onAddFileOrText != null) {
          widget.onAddFileOrText!(fileUrl, _currentTextAnswer);
        }
        
        // Save to backend
        _saveAnswerToBackend(_currentTextAnswer, _currentResources);
        
        // Important: Clear the file URL from the provider to prevent affecting other questions
        Provider.of<FileUploadNotifier>(context, listen: false).clearImageUrl();
      }
    }
  }
  // Method to delete the selected file
  void _deleteFile() {
    setState(() {
      fileName = null;
       _currentFileUrl = null;
      widget.onAddFileOrText!(_currentFileUrl,null); //notifies parent of the change
    });
  }

  void _onTextChanged(String text) {
    if (text.isNotEmpty) {
      widget.onAddFileOrText!(null,_currentTextAnswer); //notifies parent of the change
    }
  }
    void _initializeWithExistingAnswer() {
    // Prevent multiple initializations for the same questionId
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      // Log initialization for debugging
      log('Initializing QuillController for questionId: ${widget.questionId}, myAnswer: ${widget.myAnswer}');
      
      _currentTextAnswer = widget.myAnswer.isNotEmpty ? widget.myAnswer : null;
      

      try {
  final document = widget.myAnswer.isNotEmpty
      ? quill.Document.fromJson(jsonDecode(widget.myAnswer))
      : quill.Document();
  _controller = quill.QuillController(
    document: document,
    selection: const TextSelection.collapsed(offset: 0),
  );
} catch (e) {
  // Fallback to plain text if parsing fails
  final fallbackDelta = Delta()..insert(widget.myAnswer)..insert('\n');
  _controller = quill.QuillController(
    document: quill.Document.fromDelta(fallbackDelta),
    selection: const TextSelection.collapsed(offset: 0),
  );
}


      // Set up listener to track changes
      _controller.document.changes.listen((event) {
        if (_isUserEditing) {
          final String text = _controller.document.toPlainText().trimRight();
          widget.myAnswer = text; // Update local copy
          _currentTextAnswer = text.isNotEmpty ? text : null;
          
          if (widget.onAddFileOrText != null && text.isNotEmpty) {
            widget.onAddFileOrText!(null, text); // Notify parent
          }
        }
      });

      // Enable user edit tracking after initialization
      Future.delayed(const Duration(milliseconds: 100), () {
        _isUserEditing = true;
      });
    } catch (e) {
      log('Error initializing QuillController for questionId: ${widget.questionId}, error: $e');
      _controller = quill.QuillController.basic();
      _isUserEditing = true;
    }
  }
 void _checkForExistingFile() {
    // Only check for file if we have a filename/URL passed in from parent
    if (widget.fileName != null && widget.fileName!.isNotEmpty) {
      // Always display the full URL regardless of format
      setState(() {
        // Display the full URL
        fileName = widget.fileName;
        _currentFileUrl = widget.fileName;
        
        // Add to resources if it looks like a URL
        if (widget.fileName!.startsWith('http')) {
          _currentResources = [widget.fileName!];
        }
      });
    }
  }
         
  // void _checkForExistingFile() {
  //   final fileUploadNotifier = Provider.of<FileUploadNotifier>(context, listen: false);

  //   if (fileUploadNotifier.fileUrl != null && fileUploadNotifier.fileUrl!.isNotEmpty) {
  //     final uri = Uri.parse(fileUploadNotifier.fileUrl!);
  //     fileName = uri.pathSegments.isNotEmpty 
  //         ? uri.pathSegments.last 
  //         : "Uploaded file";
  //     _currentFileUrl = fileUploadNotifier.fileUrl;
  //     _currentResources = [fileUploadNotifier.fileUrl!];
  //   }
  // }
  @override
void didUpdateWidget(UploadTextBox oldWidget) {
  super.didUpdateWidget(oldWidget);
  
  // Only do a full reset if questionId has changed (we're showing a different question)
  if (oldWidget.questionId != widget.questionId) {
    try {
      // Save state of the PREVIOUS question
      if (_controller != null && _controller.document != null) {
        final previousText = _controller.document.toPlainText().trim();
        
        if (previousText.isNotEmpty || _currentResources.isNotEmpty) {
          // Save answer for the PREVIOUS question ID
          _saveAnswerToBackend(
            previousText.isNotEmpty ? previousText : null, 
            _currentResources
          );
        }
      }
      
      // Clear all state for the new question
      _isInitialized = false;
      _isUserEditing = false;
      _currentResources = [];
      _currentFileUrl = null;
      fileName = widget.fileName; // Use the filename passed from parent
      
      // Initialize with the new question's data
      _initializeWithExistingAnswer();
      _checkForExistingFile();
      
      // Force a rebuild with the new state
      if (mounted) setState(() {});
    } catch (e) {
      print('Error in didUpdateWidget: $e');
    }
  } else if (widget.fileName != oldWidget.fileName) {
    // Only the filename changed, update just that
    fileName = widget.fileName;
    // if (widget.fileName != null) {
    //   _currentFileUrl = widget.fileName;
    //   _currentResources = [widget.fileName??''];
    // }
      _checkForExistingFile();
    if (mounted) setState(() {});
  }
}
// @override
// void didUpdateWidget(UploadTextBox oldWidget) {
//   super.didUpdateWidget(oldWidget);
  
//   // Only perform state transition if the question ID has changed
//   if (oldWidget.questionId != widget.questionId) {
//     try {
//       // Save current state for the previous question
//       final previousText = _controller.document.toPlainText().trim();
//       final previousTextAnswer = previousText.isNotEmpty ? previousText : null;
      
//       // Save answer with current resources for the previous question
//       _saveAnswerToBackend(previousTextAnswer, _currentResources);
      
//       if (widget.onAddFileOrText != null) {
//         widget.onAddFileOrText!(fileName, previousTextAnswer);
//       }
      
//       // IMPORTANT: Complete reset of state for the new question
//       _isInitialized = false;
//       _isUserEditing = false;
//       _currentResources = [];
//       _currentFileUrl = null;
//       fileName = null;  // Reset filename completely
      
//       // Now initialize for the new question
//       _initializeWithExistingAnswer();
      
//       // Fetch the correct file data for this specific question
//       // This needs to come from your backend or provider
      
//     } catch (e) {
//       print('Error in didUpdateWidget: $e');
//     }
//   }
// }
// @override
// void didUpdateWidget(UploadTextBox oldWidget) {
//   super.didUpdateWidget(oldWidget);
  
//   try {
//     // Step 1: Save current question's data before switching
//     if (_controller != null && _controller.document != null) {
//       final previousText = _controller.document.toPlainText().trim();
//       final previousTextAnswer = previousText.isNotEmpty ? previousText : null;
      
//       // Check if these methods/properties exist before calling them
//       if (previousTextAnswer != null) {
//         // Note: Fix the asterisks in your original code
//         _saveAnswerToBackend(previousTextAnswer, _currentResources);
//       }
      
//       if (widget.onAddFileOrText != null) {
//         widget.onAddFileOrText!(null, previousTextAnswer);
//       }
//     }
    
//     // Step 2: Reset local state for the next question
//     _isInitialized = false;
//     _isUserEditing = false;
//     _currentResources = [];
//     _currentFileUrl = null;
//     fileName = widget.fileName;
    
//     // Step 3: Re-initialize for the new question
//     _initializeWithExistingAnswer();
//     _checkForExistingFile();
//   } catch (e) {
//     print('Error in didUpdateWidget: $e');
//     // Handle the error gracefully
//   }
// }


  @override
  void initState() {
    super.initState();
      _initializeWithExistingAnswer();
      print('jjjjjaaa ${widget.myAnswer}');
      // _checkForExistingFile();
        fileName = widget.fileName;
    widget.node.addListener(_onFocusChange);

  }
  void _onFocusChange() {
    if (!widget.node.hasFocus) {
      log('TextField lost focus. Saving answer... ${widget.questionId} ${widget.myAnswer} ${_controller.document.toPlainText()}');
      
      final textAnswer = _controller.document.toPlainText().trim();
      _currentTextAnswer = textAnswer.isNotEmpty ? textAnswer : null;
      
      // Keep existing resources when saving text
      _saveAnswerToBackend(textAnswer, _currentResources);
      
      // widget.onAddFileOrText!(null, textAnswer);
        if (widget.onAddFileOrText != null) {
        widget.onAddFileOrText!(null, textAnswer);
      }

    }
  }
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final fileUploadNotifier = Provider.of<FileUploadNotifier>(context, listen: false);
    
    // Only process file changes when this is the active component
    // and when we have a new file URL from the provider
    if (fileUploadNotifier.fileUrl != null &&
        fileUploadNotifier.fileUrl!.isNotEmpty &&
        ModalRoute.of(context)?.isCurrent == true) {

      // Check if this file is intended for THIS question
      // This might need additional logic depending on your app structure
      // For example, you could add a targetQuestionId to your FileUploadNotifier
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        // Only update if the current file is meant for this question
        // Or if no specific question is targeted (depends on your implementation)
        log('New file uploaded for questionId ${widget.questionId}: ${fileUploadNotifier.fileUrl}');
        
        setState(() {
          _currentFileUrl = fileUploadNotifier.fileUrl;
          _currentResources = [fileUploadNotifier.fileUrl!];
          // Display the full URL instead of just the filename
          fileName = fileUploadNotifier.fileUrl;
        });
        
        _saveAnswerToBackend(_currentTextAnswer, _currentResources);
        
        // Clear the file URL from the provider to prevent affecting other questions
        fileUploadNotifier.clearImageUrl();
      });
    }
  }

// @override
// void didChangeDependencies() {
//   super.didChangeDependencies();

//   final fileUploadNotifier = Provider.of<FileUploadNotifier>(context, listen: false);
//   if (fileUploadNotifier.fileUrl != null &&
//       fileUploadNotifier.fileUrl!.isNotEmpty &&
//       ModalRoute.of(context)?.isCurrent == true) {

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       log('New file uploaded: ${fileUploadNotifier.fileUrl}');
      
//       _currentFileUrl = fileUploadNotifier.fileUrl;
//       _currentResources = [fileUploadNotifier.fileUrl!];
//       //  fileName = Uri.parse(fileUploadNotifier.fileUrl!).pathSegments.last;
//  fileName = fileUploadNotifier.fileUrl;

      
//       setState(() {});
//       _saveAnswerToBackend(_currentTextAnswer, _currentResources);
//       fileUploadNotifier.clearImageUrl();
//     });
//   }
// }






    void _saveAnswerToBackend(String? textAnswer, List<String> resources) {
    try {
      Provider.of<ExamHomeProvider>(context, listen: false).updateExamSession(
        context: context,
        examSessionInput: ExamSessionInput(
          examId: widget.examId,
          spaceId: widget.spaceId,
          id: widget.examSessionId,
          examGroupId: widget.examGroupId,
          studentId: context.read<UserProvider>().memberId,
          status: "inProgress",
          answer: AnswerInput(
            questionId: widget.questionId,
            answer: textAnswer ?? '',
            resources: resources,
          ),
        ),
      );
    } catch (e) {
      log('Error saving answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.readOnly
        ? Container(
            width: 320.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: whiteShades[0],
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                width: 1.w,
                color: blueShades[1],
              ),
            ),
            child: Text(
              fileName ?? "No file uploaded or text added",
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                  //height: 400.h,
                  // height: constraints.maxHeight -
                  //     MediaQuery.of(context).viewInsets.bottom,
                  // height: constraints.maxHeight,
                  constraints: BoxConstraints(
                    maxHeight: widget.node.hasFocus
                        ? MediaQuery.of(context).size.height * 0.9
                        : MediaQuery.of(context).size.height *
                            0.6, // 80% of screen height
                  ),
                  child: Consumer<FileUploadNotifier>(
                      builder: (context, value, _) {
             
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Upload Box
                        GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            height: 61.h,
                            width: 320.w,
                            decoration: BoxDecoration(
                              color: blueShades[11],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                width: 2.w,
                                color: whiteShades[2],
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.cloud_upload),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Upload file',
                                    style: setTextTheme(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        // Display the uploaded file name
                        if (value.isUploading) const LinearProgressIndicator(),
                        // if (fileName != null)
                      //  if (!value.isUploading && value.fileUrl != null)
                        // if (!value.isUploading && (value.fileUrl != null || fileName != null))
                         if (!value.isUploading &&  fileName != null)
                          Container(
                            width: 320.w,
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: whiteShades[0],
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                width: 1.w,
                                color: blueShades[1],
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 310,
                                  child: Text(
                                  // value.fileUrl!,
                                     fileName ?? 'No file selected',
                                     maxLines: 1,
                                     softWrap: true,
                                    style: setTextTheme(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: _deleteFile,
                                    icon: Icon(
                                      Icons.delete,
                                      color: redShades[0],
                                    ))
                              ],
                            ),
                          ),
                        SizedBox(height: 5.h),

                        quill.QuillSimpleToolbar(
                            controller: _controller,
                            config: quill.QuillSimpleToolbarConfig(
                              // controller: _controller,
                              showBoldButton: true,
                              showItalicButton: true,
                              showUnderLineButton: true,
                              showStrikeThrough: false,
                              showFontFamily: false,
                              showFontSize: false,
                              showSubscript: false,
                              showSuperscript: false,
                              showListNumbers: true,
                              showListBullets: true,
                              showIndent: false,
                              showSearchButton: false,
                              showCodeBlock: false,
                              showQuote: false,
                              showDirection: false,
                              showLink: false,
                              showUndo: false,
                              showRedo: false,
                              showClipboardCut: false,
                              showClipboardCopy: false,
                            )),

                        // Editor
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                                border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1), // Subtle border
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 5,
                                //     spreadRadius: 1,
                                //   ),
                                // ],
                              ),
                              child: SizedBox(
                                height: 180.h,
                                child: quill.QuillEditor.basic(
                                  controller: _controller,
                                  scrollController: _scrollController,
                                  focusNode: widget.node,
                                  config: QuillEditorConfig(
                                    expands: true,
                                    scrollable: true,
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                );
              }),
            ),
          );
  }
}

class UploadTeacherTextBox extends StatefulWidget {
  UploadTeacherTextBox({
    super.key,
    this.onAddFileOrText,
    this.fileName,
    this.readOnly = false,
    required this.node,
    required this.examId,
    required this.spaceId,
    required this.examGroupId,
    required this.questionId,
    required this.examSessionId,
    required this.myAnswer,
  });

  final void Function(String?)? onAddFileOrText;
  final String? fileName;
  final bool readOnly;
  final FocusNode node;
  final String examId;
  final String spaceId;
  final String examGroupId;
  final String questionId;
  final String examSessionId;
  String myAnswer;

  @override
  State<UploadTeacherTextBox> createState() => _UploadTeacherTextBoxState();
}

class _UploadTeacherTextBoxState extends State<UploadTeacherTextBox> {
  String? fileName;
  final quill.QuillController _controller = quill.QuillController.basic();
  ScrollController _scrollController = ScrollController();
  TextEditingController? textController;
  // Method to pick a file

  @override
  void dispose() {
   
    _scrollController.dispose();
    widget.node.removeListener(_onFocusChange);
    super.dispose();
  }

  Future<void> _pickFile() async {
    widget.node.unfocus();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
      Provider.of<FileUploadNotifier>(context, listen: false)
          .uploadFile(File(result.files.single.path!));
      widget.onAddFileOrText!(
          result.files.single.name); //notifies parent of the change
    }
  }

  // Method to delete the selected file
  void _deleteFile() {
    setState(() {
      fileName = null;
      widget.onAddFileOrText!(null); //notifies parent of the change
    });
  }

  void _onTextChanged(String text) {
    if (text.isNotEmpty) {
      widget.onAddFileOrText!(text); //notifies parent of the change
    }
  }

  @override
  void initState() {
    super.initState();
     print('my datarrrrr ${widget.fileName}');
    widget.node.addListener(_onFocusChange);
    textController = TextEditingController(text: widget.fileName);
    // if (!widget.node.hasFocus) {
    //   log('the answer isdddd ${widget.myAnswer}');
    //  try{
    //    Provider.of<ExamHomeProvider>(context, listen: false).updateExamSession(
    //       context: context,
    //       examSessionInput: ExamSessionInput(
    //         examId: widget.examId,
    //         spaceId: widget.spaceId,
    //         id: widget.examSessionId,
    //         examGroupId: widget.examGroupId,
    //         studentId: context.read<UserProvider>().memberId,
    //         status: "completed",
    //         //questionId: answer!.id,
    //         answer: AnswerInput(
    //           questionId: widget.questionId,
    //           answer: _controller.document.toPlainText(),
    //           resources: [],

    //           // score: 0.0,
    //           // isCorrect: false,
    //           //score: answer?.options[optionIndex].score,
    //         ),
    //       ));
    //  }catch(e){
    //    log('the error is $e');
    //  }
    // }
    fileName = widget.fileName; // Initialize with the fileName from parent
  }

  void _onFocusChange() {
    if (!widget.node.hasFocus) {
      log('TextField lost focus. Saving answer... ${widget.questionId} ${widget.myAnswer} ${_controller.document.toPlainText()}');
      //widget.myAnswer = _controller.document.toPlainText();
      // setState(() {
      //   widget.myAnswer = _controller.document.toPlainText();
      // });
      try {
        Provider.of<ExamHomeProvider>(context, listen: false).updateExamSession(
          context: context,
          examSessionInput: ExamSessionInput(
            examId: widget.examId,
            spaceId: widget.spaceId,
            id: widget.examSessionId,
            examGroupId: widget.examGroupId,
            studentId: context.read<UserProvider>().memberId,
            status: "inProgress",
            answer: AnswerInput(
              questionId: widget.questionId,
              // answer: widget.myAnswer,
              answer: _controller.document.toPlainText(),
              resources: [],
            ),
          ),
        );
      } catch (e) {
        log('Error saving answer: $e');
      }
    }
  }

  bool _isEditorVisible = false;

  @override
  Widget build(BuildContext context) {
    return widget.readOnly
        ?
        //  Container(
        //     width: 320.w,
        //     padding: EdgeInsets.all(8.r),
        //     decoration: BoxDecoration(
        //       color: whiteShades[0],
        //       borderRadius: BorderRadius.circular(5.r),
        //       border: Border.all(
        //         width: 1.w,
        //         color: blueShades[1],
        //       ),
        //     ),
        //     child: Text(
        //       fileName ?? "No file uploaded or text added",
        //       style: setTextTheme(
        //         fontSize: 14.sp,
        //         fontWeight: FontWeight.w400,
        //       ),
        //       overflow: TextOverflow.ellipsis,
        //     ),
        //   )
        Container(
            width: 320.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: whiteShades[0],
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                width: 1.w,
                color: blueShades[1],
              ),
            ),
            child: TextField(
              controller: textController,
              readOnly: true,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none, // Removes default underline
                hintText: "No text added",
              ),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                  //height: 400.h,
                  // height: constraints.maxHeight -
                  //     MediaQuery.of(context).viewInsets.bottom,
                  // height: constraints.maxHeight,
                  constraints: BoxConstraints(
                    maxHeight: widget.node.hasFocus
                        ? MediaQuery.of(context).size.height * 0.9
                        : MediaQuery.of(context).size.height *
                            0.6, // 80% of screen height
                  ),
                  child: Consumer<FileUploadNotifier>(
                      builder: (context, value, _) {
                    if (value.fileUrl != null) {
                      log('message is ${value.fileUrl}');
                      Provider.of<ExamHomeProvider>(context, listen: false)
                          .updateExamSession(
                        context: context,
                        examSessionInput: ExamSessionInput(
                          examId: widget.examId,
                          spaceId: widget.spaceId,
                          id: widget.examSessionId,
                          examGroupId: widget.examGroupId,
                          studentId: context.read<UserProvider>().memberId,
                          status: "inProgress",
                          answer: AnswerInput(
                            questionId: widget.questionId,
                            answer: '',
                            // answer: _controller.document.toPlainText(),
                            resources: [value.fileUrl!],
                          ),
                        ),
                      );
                      //     .then((_) {
                      //   value.clearImageUrl();
                      // });
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Upload Box
                        GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            height: 61.h,
                            width: 320.w,
                            decoration: BoxDecoration(
                              color: blueShades[11],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                width: 2.w,
                                color: whiteShades[2],
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.cloud_upload),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Upload file',
                                    style: setTextTheme(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        // Display the uploaded file name
                        if (value.isUploading) const LinearProgressIndicator(),
                        // if (fileName != null)
                        if (!value.isUploading && value.fileUrl != null)
                          Container(
                            width: 320.w,
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: whiteShades[0],
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                width: 1.w,
                                color: blueShades[1],
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  // value.fileUrl!,
                                  fileName!,
                                  style: setTextTheme(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: _deleteFile,
                                    icon: Icon(
                                      Icons.delete,
                                      color: redShades[0],
                                    ))
                              ],
                            ),
                          ),
                        SizedBox(height: 5.h),

                        quill.QuillSimpleToolbar(
                            controller: _controller,
                            config: quill.QuillSimpleToolbarConfig(
                              showBoldButton: true,
                              showItalicButton: true,
                              showUnderLineButton: true,
                              showStrikeThrough: false,
                              showFontFamily: false,
                              showFontSize: false,
                              showSubscript: false,
                              showSuperscript: false,
                              showListNumbers: true,
                              showListBullets: true,
                              showIndent: false,
                              showSearchButton: false,
                              showCodeBlock: false,
                              showQuote: false,
                              showDirection: false,
                              showLink: false,
                              showUndo: false,
                              showRedo: false,
                              showClipboardCut: false,
                              showClipboardCopy: false,
                            )),

                        // Editor
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                                border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1), // Subtle border
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 5,
                                //     spreadRadius: 1,
                                //   ),
                                // ],
                              ),
                              child: SizedBox(
                                height: 180.h,
                                child: quill.QuillEditor.basic(
                                  controller: _controller,
                                  scrollController: _scrollController,
                                  focusNode: widget.node,
                                  // configurations: QuillEditorConfigurations(
                                  //   expands: true,
                                  //   scrollable: true,
                                  //   padding: EdgeInsets.only(
                                  //       bottom: MediaQuery.of(context)
                                  //           .viewInsets
                                  //           .bottom),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                );
              }),
            ),
          );
  }
}
