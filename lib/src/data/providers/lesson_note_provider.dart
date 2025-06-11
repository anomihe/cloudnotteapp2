import 'dart:developer';

import 'package:cloudnottapp2/src/config/ai_api_prompt.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart';

import 'package:cloudnottapp2/src/data/models/lesson_note_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:cloudnottapp2/src/data/repositories/lesson_note_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LessonNotesProvider extends ChangeNotifier {
  final LessonNotesRepository lessonNoteRepository;

  LessonNotesProvider({required this.lessonNoteRepository});

  List<LessonNoteModel> _lessonNotes = [];
  List<LessonNoteModel> get lessonNotes => _lessonNotes;

  LessonNoteModel? _myLessonNote;
  LessonNoteModel? get myLessonNote => _myLessonNote;
  LessonNotePlan? _lessonNotePlan;
  LessonNotePlan? get lessonNotePlan => _lessonNotePlan;
  List<ClassGroup> _group = [];
  List<ClassGroup> get group => _group;
  ResponseError? errorResponse;
  ResponseSuccess? successResponse;
  List<ClassModel> _classes = [];
  List<ClassModel> get classes => _classes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;
  String? _termId;
  String? _classsId;
  String? _subjectId;

  String? get termId => _termId;
  String? get classId => _classsId;
  String? get subjectId => _subjectId;

  setDataGroup(
      {required String termId,
      required String classId,
      required String subjectId}) {
    _termId = termId;
    _classsId = classId;
    _subjectId = subjectId;
    notifyListeners();
  }

  setLessonNotes(List<LessonNoteModel> notes) {
    _lessonNotes = notes;
    notifyListeners();
  }

  setMyLessonNote(LessonNoteModel note) {
    _myLessonNote = note;
    notifyListeners();
  }

  setMyLessonPlan(LessonNotePlan plan) {
    _lessonNotePlan = plan;
    notifyListeners();
  }

  setGroup(List<ClassGroup> grp) {
    _group = grp;
    notifyListeners();
  }

  Future<void> fetchLessonNotes({
    required String spaceId,
    required GetLessonNotesInput input,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      // notifyListeners();

      var resultData = await lessonNoteRepository.getLessonNotes(
        spaceId: spaceId,
        input: input,
      );
      Result<dynamic> result = resultData;

      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        log("fetchLessonNotes Error: ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        // return false;
      }

      successResponse = result.response as ResponseSuccess;
      _lessonNotes = successResponse!.data;

      log('Lesson notes fetched: $_lessonNotes');
      _isLoading = false;
      notifyListeners();

      // return true;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log("fetchLessonNotes Exception: ${errorResponse?.errors.toString()}");
      _isLoading = false;
      notifyListeners();
      // return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchClassGroup(
      {required BuildContext context, required String spaceId}) async {
    try {
      _isLoading = true;
      _error = null;
      // notifyListeners();
      Result<dynamic> result = await lessonNoteRepository.getClassGroup(
          context: context, spaceId: spaceId);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        _isLoading = false;
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as List<ClassGroup>;
      log('trtrtrtrttr $data');
      setGroup(data);
      for (int i = 0; i < data.length; i++) {
        // log("CLASSES: ${data[i].classes.toString()}");
        for (int j = 0; j < data[i].classes.length; j++) {
          
          _classes.add(data[i].classes[j]);
        }
      }
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLessonPro(
      {required BuildContext context,
      required CreateLessonNoteRequest input}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result = await lessonNoteRepository.createLessonNote(
          context: context, input: input);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("getLeeerr   ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as bool;
      notifyListeners();

      log('my datata $data');
      return true;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("getLeeerr    ${errorResponse?.errors.toString()}");
      _isLoading = false;

      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLessonPro(
      {required BuildContext context,
      required String spaceId,
      required LessonNoteData input}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result = await lessonNoteRepository.updateLessonNote(
          context: context, input: input, spaceId: spaceId);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("updateerr  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as bool;
      notifyListeners();

      log('my datata $data');
      return true;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("updateerr  ${errorResponse?.errors.toString()}");
      _isLoading = false;

      notifyListeners();
      return false;
    }
  }

  Future<void> fetchMyLesson(
      {required BuildContext context,
      required String spaceId,
      required String lessonNoteId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result = await lessonNoteRepository.getLessonNote(
          context: context, spaceId: spaceId, lessonNoteId: lessonNoteId);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as LessonNoteModel;
      setMyLessonNote(data);
      _isLoading = false;
      log('my datata $data');
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLessonProMain(
      {required BuildContext context,
      required String noteId,
      required String spaceId,
      required String content}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result =
          await lessonNoteRepository.createClassNoteContent(
              context: context,
              noteId: noteId,
              spaceId: spaceId,
              content: content);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as bool;
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Note Created Successfully",
        ),
      );
      notifyListeners();
      _isLoading = false;
      log('my datata $data');
      return true;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
      _isLoading = false;

      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLessonProMain(
      {required BuildContext context,
      required String noteId,
      required String contentId,
      required String spaceId,
      required String content}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result =
          await lessonNoteRepository.updateClassNoteContent(
              context: context,
              noteId: noteId,
              spaceId: spaceId,
              content: content,
              contentId: contentId);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as bool;
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Lesson Note Update Successfully",
        ),
      );
      notifyListeners();
      _isLoading = false;
      log('my datata $data');
      return true;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
      _isLoading = false;

      notifyListeners();
      return false;
    }
  }

  Future<bool> creatLessonPlanProMain(
      {required BuildContext context,
      required String lessonNoteId,
      required String spaceId,
      required String lessonNotePlan}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result =
          await lessonNoteRepository.createLessonPlanNoteContent(
              context: context,
              lessonNoteId: lessonNoteId,
              spaceId: spaceId,
              lessonNotePlan: lessonNotePlan);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as bool;
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Lesson Note Created Successfully",
        ),
      );
      notifyListeners();
      _isLoading = false;
      log('my datata $data');
      return true;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
      _isLoading = false;

      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLessonPlanProMain(
      {required BuildContext context,
      required String lessonNoteId,
      required String spaceId,
      required String id,
      required String lessonNotePlan}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result =
          await lessonNoteRepository.updateLessonPlanNoteContent(
              context: context,
              lessonNoteId: lessonNoteId,
              id: id,
              spaceId: spaceId,
              lessonNotePlan: lessonNotePlan);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;

      var data = successResponse!.data as bool;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Lesson Plan Updated Successfully",
          ),
        );
      });
      notifyListeners();
      _isLoading = false;
      log('my datata $data');
      return true;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
      _isLoading = false;

      notifyListeners();
      return false;
    }
  }

  Future<void> fetchMyLessonPlan(
      {required BuildContext context,
      required String spaceId,
      required String lessonNoteId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Result<dynamic> result = await lessonNoteRepository.getLessonPlan(
          context: context, spaceId: spaceId, lessonNoteId: lessonNoteId);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      // ClassInfo
      var data = successResponse!.data as LessonNotePlan;
      setMyLessonPlan(data);
      _isLoading = false;
      log('my datata $data');
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("plan error:  ${errorResponse?.errors.toString()}");
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearLessonNote() {
    _lessonNotes = [];
    _myLessonNote = null;
    _lessonNotePlan = null;
    errorResponse = null;
    successResponse = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void clearData() {
    _lessonNotes = [];
    _myLessonNote = null;
    _lessonNotePlan = null;
    _group = [];
    errorResponse = null;
    successResponse = null;
    _isLoading = false;
    _error = null;
    _termId = null;
    _classsId = null;
    _subjectId = null;
    notifyListeners();
  }
  // Future<bool> updateLessonPro(
  //     {required BuildContext context,
  //     required CreateLessonNoteRequest input}) async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();
  //     Result<dynamic> result = await lessonNoteRepository.createLessonNote(
  //         context: context, input: input);
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
  //       _isLoading = false;
  //       notifyListeners();
  //       return false;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     // ClassInfo
  //     var data = successResponse!.data as bool;
  //     notifyListeners();

  //     log('my datata $data');
  //     return true;
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     print("ERRORssss delete:  ${errorResponse?.errors.toString()}");
  //     _isLoading = false;

  //     notifyListeners();
  //     return false;
  //   }
  // }
}
