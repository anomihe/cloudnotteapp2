import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../screens/student/homework/homework_screens/homework_submitted_screen.dart';
import '../../utils/alert.dart';
import '../models/exam_session_model.dart';
import '../models/response_model.dart';
import '../models/teacher_homework_model.dart' show ExamTeacherGroup;
import '../repositories/exam_or_home_work_repo.dart';

class ExamHomeProvider extends ChangeNotifier {
  final ExamOrHomeWorkRepo examOrHomeWorkRepo;
  ExamHomeProvider({required this.examOrHomeWorkRepo});
  ResponseSuccess? successResponse;
  ResponseError? errorResponse;
  bool _isLoading = false;
  bool _isLoadingStateTwo = false;
  bool _isError = false;
  List<ExamData> _examData = [];
  List<ExamGroupModel> _examGroup = [];
  TextEditingController? _scoreController;
  TextEditingController? get scoreController => _scoreController;
  // List<StudentExamSessionData> _correction = [];
  StudentExamSessionData? _correction;
   GetStudentExamSession? _examSummary;
   GetExamSessionsSummaryResponse? _mainSummary; 
  List<ExamDetailed> _examSessionData = [];
  List<ExamDataSubmission> _examSessionDataSub = [];
  List<ExamTeacherGroup> _examTeacherGroup = [];
  List<ExamSession> _gotExamSession = [];
  List<ExamSessionData> _gotWrittenExam = [];
  ExamData? _exam;
  ExamSession? _examSession;
  ExamSession? _markedSession;
  // List<StudentExamSessionData> get correct => _correction;
  StudentExamSessionData? get correct => _correction;
   GetStudentExamSession? get examSummary => _examSummary;
   GetExamSessionsSummaryResponse? get mainSummary => _mainSummary;
  bool get isLoading => _isLoading;
  List<ExamTeacherGroup> get examTeacherGroup => _examTeacherGroup;
  bool get isLoadingStateTwo => _isLoadingStateTwo;
  List<ExamGroupModel> get examGroup => _examGroup;
  bool get isError => _isError;
  List<ExamData> get examDate => _examData;
  List<ExamDetailed> get examSessionData => _examSessionData;
  List<ExamDataSubmission> get examSessionDataSub => _examSessionDataSub;
  ExamData? get exam => _exam;
  ExamSession? get examSession => _examSession;
  ExamSession? get markedSession => _markedSession;
  List<ExamSession> get gotExamSession => _gotExamSession;
  List<ExamSessionData> get gotWrittenExam => _gotWrittenExam;
  double _score = 0.0;
   Map<String, double?> questionScores = {};
   double? getScore(String questionId) => questionScores[questionId];
  double get score => _score;
  set examSession(ExamSession? value) {
    _examSession = value;
    notifyListeners();
  }

  String sessionId = '';
  String _examid = '';
  String get examId => _examid;
  Timer? _timer;
  int timeLeft = 0;
  Duration get remainingTime => Duration(seconds: timeLeft ?? 0);
  DateTime get timeStarted =>
      DateTime.parse(examSession?.timeStarted ?? DateTime.now().toString());
  // setScore(double value) {
  //   _score = value;
  //   developer.log('the score $_score');
  //   notifyListeners();
  // }
 void setScore(String questionId, double? score) {
  questionScores[questionId] = score;
  notifyListeners();
}
  // DateTime get expectedEndTime => DateTime.parse(
  //     examSession?.exam.duration.toString() ?? DateTime.now().toString());
  // DateTime get expectedEndTime {
  //   final timeString = examSession?.expectedEndTime;
  //   if (examSession == null || examSession!.exam.duration == null) {
  //     return DateTime.now(); // Fallback
  //   }

  //   return timeStarted.add(Duration(minutes: examSession?.exam.duration ?? 0));
  // }
  DateTime get expectedEndTime {
    if (examSession == null) {
      developer.log("⚠️ examSession is NULL. Using fallback time.");
      return DateTime.now(); // Fallback
    }

    if (examSession!.exam.duration == null) {
      developer.log("⚠️ examSession duration is NULL. Using fallback time.");
      return DateTime.now();
    }

    if (timeStarted == null) {
      developer.log("⚠️ timeStarted is NULL. Using fallback time.");
      return DateTime.now();
    }

    // ✅ Compute expectedEndTime correctly
    return timeStarted
        .add(Duration(minutes: examSession!.exam.duration.toInt()));
  }

  // DateTime get expectedEndTime {
  //   final timeString = examSession?.expectedEndTime;
  //   if (timeString == null || timeString.isEmpty) {
  //     log("⚠️ expectedEndTime is NULL. Using default time.");
  //     return DateTime.now().add(Duration(minutes: 30)); // Default to 30 minutes
  //   }
  //   return DateTime.parse(timeString);
  // }

  DateTime get lastSavedAt =>
      DateTime.parse(examSession?.lastSavedAt ?? DateTime.now().toString());

  // void startTimer({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String examId,
  //   required String answer,
  //   required String examGroupId,
  //   required String questionId,
  // }) {
  //   try {
  //     stopTimer();

  //     final now = DateTime.now();
  //     final secondsLeft = expectedEndTime.difference(now).inSeconds;

  //     if (secondsLeft <= 0) {
  //       log("⚠️ Timer already expired at start.");
  //       timeLeft = 0;
  //       notifyListeners();
  //       return;
  //     }

  //     timeLeft = secondsLeft;
  //     notifyListeners();

  //     log("⏳ Timer Started: $timeLeft seconds remaining");

  //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       if (timeLeft > 0) {
  //         timeLeft--;
  //         notifyListeners();
  //       } else {
  //         _timer?.cancel();
  //         showTimeUpDialog(
  //           context: context,
  //           examId: examSession!.examId,
  //           examSessionId: examSession!.id,
  //           examGroupId: examGroupId,
  //           questionId: questionId,
  //           myAnswer: answer,
  //           spaceId: spaceId,
  //         );
  //         notifyListeners();
  //       }
  //     });
  //   } catch (e) {
  //     log('the error $e');
  //   }
  // }
  void startTimer({
    required BuildContext context,
    required String spaceId,
    required String examId,
    required String answer,
    required String examGroupId,
    required String questionId,
  }) {
    try {
      stopTimer(); // Ensure previous timer is canceled

      // ✅ Ensure `expectedEndTime` is not null
      if (examSession?.expectedEndTime == null) {
        developer.log("⚠️ expectedEndTime is NULL. Timer cannot start.");
        return;
      }

      final now = DateTime.now();
      final endTime = DateTime.tryParse(examSession!.expectedEndTime);

      if (endTime == null) {
        developer.log("❌ Invalid expectedEndTime format.");
        return;
      }

      final secondsLeft = endTime.difference(now).inSeconds;
      developer.log("⏳ Timer Starting: $secondsLeft seconds remaining");

      if (secondsLeft <= 0) {
        developer.log("⚠️ Timer already expired at start.");
        timeLeft = 0;
        notifyListeners();
        return;
      }

      timeLeft = secondsLeft;
      notifyListeners(); // ✅ Update UI immediately

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeLeft > 0) {
          timeLeft--; // ✅ Decrement time
          notifyListeners(); // ✅ Update UI every second
        } else {
          _timer?.cancel(); // ✅ Stop timer
          notifyListeners();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              showTimeUpDialog(
                context: context,
                examId: examSession!.examId,
                examSessionId: examSession!.id,
                examGroupId: examGroupId,
                questionId: questionId,
                myAnswer: answer,
                spaceId: spaceId,
              );
            }
          });
        }
      });
    } catch (e) {
      developer.log('❌ Timer Error: $e');
    }
  }

  // void startTimer() {
  //   stopTimer();
  //   log("Starting timer...");
  //   log("Expected End Time: $expectedEndTime");
  //   log("Current Time: ${DateTime.now()}");

  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     final now = DateTime.now();
  //     final secondsLeft = expectedEndTime.difference(now).inSeconds;

  //     if (secondsLeft > 0) {
  //       timeLeft = secondsLeft;
  //       notifyListeners();
  //     } else {
  //       stopTimer();
  //       timeLeft = 0;
  //       _timer?.cancel();
  //       notifyListeners();
  //     }
  //   });
  // }

  void stopTimer() {
    timeLeft = 0;
    _timer?.cancel();
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void updateTimeLeft() {
    //  session= examSession ;
    timeLeft = examSession?.timeLeft ?? 0; // Ensure `timeLeft` updates
    notifyListeners();
    // startTimer();
  }

  void setLoading(bool value) {
    _isLoading = value;
    // notifyListeners();
  }

  void setLoadingTwo(bool value) {
    _isLoadingStateTwo = value;
    notifyListeners();
  }

  void setError(bool value) {
    _isError = value;
    notifyListeners();
  }

  void setExams(List<ExamData> exams) {
    _examData = exams;
    notifyListeners();
  }

  void setExamSessionData(List<ExamDetailed> exams) {
    _examSessionData = exams;
    notifyListeners();
  }

  void setExamSessionDataSubmission(List<ExamDataSubmission> exams) {
    _examSessionDataSub = exams;
    notifyListeners();
  }

  // void setCorrection(List<StudentExamSessionData> correct) {
  //   _correction = correct;
  //   notifyListeners();
  // }
  void setCorrection(StudentExamSessionData correct) {
    _correction = correct;
    notifyListeners();
  }

  void setMarked(ExamSession data) {
    _examSession = data;
    notifyListeners();
  }

  void getFilterResult(String id) {
    _examid = id;
    notifyListeners();
  }

  void setExamSessionGotten(List<ExamSession> exams) {
    _gotExamSession = exams;
    notifyListeners();
  }

  void setGottenExamSession(List<ExamSessionData> exam) {
    _gotWrittenExam = exam;
    notifyListeners();
    developer.log('exam gropus $exam');
  }

  void setExamGroup(List<ExamGroupModel> group) {
    _examGroup = group;
    notifyListeners();
  }

  void setExam(ExamData exams) {
    _exam = exams;
    notifyListeners();
  }

  void setExamSession(ExamSession exams) {
    _examSession = exams;
    notifyListeners();
  }

  void setTeacherExamGroup(List<ExamTeacherGroup> group) {
    _examTeacherGroup = group;
    notifyListeners();
  }

  void setExamSummary( GetStudentExamSession? summary){
    _examSummary = summary;
    notifyListeners();
  }
  void setMainExamSummary(GetExamSessionsSummaryResponse? summary){
    _mainSummary = summary; 
    notifyListeners();
  }
    double get averageDuration => mainSummary?.examSessionBreakdown.averageDuration ?? 0;
  int get totalSessions => mainSummary?.examSessionBreakdown.totalSessions ?? 0;
  double get averageScore => mainSummary?.examSessionBreakdown.averageScore ?? 0;

  String get highestStudentName {
    final student = mainSummary?.examSessionBreakdown.highestSession?.first.student;
    return '${student?.user.firstName ?? ''} ${student?.user.lastName ?? ''}';
  }

  String get lowestStudentName {
    final student = mainSummary?.examSessionBreakdown.lowestSession?.first.student;
     return '${student?.user.firstName ?? ''} ${student?.user.lastName ?? ''}';
  }

  List<ExamLessonNoteBreakdown> get topicBreakdown =>
      mainSummary?.examLessonNoteBreakdown ?? [];

  Future<void> getUserExams({
    required BuildContext context,
    required String spaceId,
    required int pageSize,
    required bool offline,
  }) async {
    try {
      reset();
      setLoading(true);
      // notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.getExams(
          context: context,
          spaceId: spaceId,
          pageSize: pageSize,
          offline: offline);
          print("the result ${result.response}");
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ExamData>;

      setExams(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getUserExam({
    required BuildContext context,
    required String spaceId,
    required String id,
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.getExam(
        context: context,
        spaceId: spaceId,
        id: id,
      );
      developer.log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as ExamData;
      developer.log('examined $data');
      sessionId = data.id;
      setExam(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getUserExamSession({
    required BuildContext context,
    required String spaceId,
    required String examGroupId,
    required String examId,
    required String pin,
    required String studentId,
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.userPersonnelExam(
          context: context,
          spaceId: spaceId,
          examGroupId: examGroupId,
          examId: examId,
          pin: pin,
          examSessionId: sessionId,
          studentId: studentId);
      developer.log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as ExamSession;

      setExamSession(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateExamSession({
    required BuildContext context,
    required ExamSessionInput examSessionInput,
  }) async {
    try {
      reset();
      // setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.userUpdateExamSession(
          context: context, data: examSessionInput);

      developer.log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        if (errorResponse?.message == 'Time Up') {
          // updateExamSession(
          //     context: context,
          //     examSessionInput: ExamSessionInput(
          //       id: examSessionInput.id,
          //       spaceId: examSessionInput.spaceId,
          //       examId: examSessionInput.examId,
          //       studentId: examSessionInput.studentId,
          //       status: 'completed',
          //       examGroupId: examSessionInput.examGroupId,
          //       // answer: examSessionInput.answer
          //     ));
        }
        print("ERRORssss:cred  ${errorResponse?.errors.toString()}");
        setError(true);
        // setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as ExamSession;
      setExamSession(data);
      //setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getMyExamSession(
      {required BuildContext context,
      required String spaceId,
      required String examGroupId,
      required List<String> examId,
      required String? claseId}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      // Result<dynamic> result = await examOrHomeWorkRepo.writtenExamSession(
      //     context: context,
      //     data: GetExamSessionsInput(
      //       spaceId: spaceId,
      //       examGroupId: examGroupId,
      //       examId: examId,
      //       pageSize: 100,
      //       classId: claseId,
      //     ));
      Result<dynamic> result = await examOrHomeWorkRepo.writtenExamSession(
        context: context,
        spaceId: spaceId,
        examGroupId: examGroupId,
        examId: examId,
        pageSize: 50,
        classId: claseId,
      );
      developer.log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss:  ${errorResponse?.errors.toString()}");

        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ExamSessionData>;
      developer.log('the error $data ');
      // setExamSessionGotten(data);
      setGottenExamSession(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getMyExams({
    required BuildContext context,
    required String spaceId,
    required String classGroupId,
    required String examGroupId,
  }) async {
    try {
      setLoading(true);
      // notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.getHomeworks(
        context: context,
        spaceId: spaceId,
        pageSize: 100,
        classGroupId: classGroupId,
        examGroupId: examGroupId,
      );
      developer.log('my result ${result.response}');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        developer
            .log('examdetaileror$errorResponse ${errorResponse?.message}');
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ExamDetailed>;
      setExamSessionData(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('examdetaileror $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getMySubmission({
    required BuildContext context,
    required String spaceId,
    required String classGroupId,
    required String examGroupId,
  }) async {
    try {
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.getSubmission(
        context: context,
        spaceId: spaceId,
        pageSize: 100,
        classGroupId: classGroupId,
        examGroupId: examGroupId,
      );
      developer.log('my result ${result.response}');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        developer
            .log('examdetaileror$errorResponse ${errorResponse?.message}');
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ExamDataSubmission>;
      setExamSessionDataSubmission(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('examdetaileror $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getMyExamsGroup({
    required BuildContext context,
    required String spaceId,
    required String classGroupId,
    required String sessId,
    required String termId,
  }) async {
    try {
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.getExamGroup(
          context: context,
          spaceId: spaceId,
          pageSize: 100,
          classGroupId: classGroupId,
          sessionId: sessId,
          termId: termId);
      developer.log('my result ${result.response}');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        developer.log('the error $errorResponse ${errorResponse?.message}');
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ExamGroupModel>;
      developer.log('my data data $data');
      setExamGroup(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getMyTeachersGroup(
      {required BuildContext context,
      required String spaceId,
      required String termId,
      required List<String> classGroupId,
      required String sessionId}) async {
    try {
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.getTeacherExamGroup(
        context: context,
        spaceId: spaceId,
        termid: termId,
        classGroupId: classGroupId,
        sessionId: sessionId,
      );
      developer.log('my result ${result.response}');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        developer.log('the error $errorResponse ${errorResponse?.message}');
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ExamTeacherGroup>;
      setTeacherExamGroup(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> getfiter({
    required BuildContext context,
    required String spaceId,
    required String classGroupId,
    required String examGroupId,
  }) async {
    try {
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.filter(
        context: context,
        spaceId: spaceId,
        pageSize: 100,
        classGroupId: classGroupId,
        examGroupId: examGroupId,
      );
      developer.log('my result ${result.response}');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        developer.log('the error $errorResponse ${errorResponse?.message}');
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ExamSessionData>;
      developer.log('the error data $data ');
      for (var exam in data) {
        developer.log(
            'Exam ID: ${exam.id}, Name: ${exam.student.user.lastName}, Status: ${exam.status}');
      }
      setGottenExamSession(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> deleteStudent(
      {required BuildContext context,
      required String spaceId,
      required String examGroupId,
      required String examid,
      required String id,
      required String studentId}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.deleteExams(
        context: context,
        spaceId: spaceId,
        examGroupId: examGroupId,
        examId: examid,
        id: id,
        studentId: studentId,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");

        setError(true);
        setLoading(false);
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<DeleteExamSessionData>;
      // data.id;
      // setExamSession(data);
      if (data.isNotEmpty) {
        getMyExamSession(
          context: context,
          spaceId: spaceId,
          examGroupId: examGroupId,
          examId: [examid],
          claseId: "",
        );

        return true;
      }
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);

      notifyListeners();
      return false;
    }
    return false;
  }

  Future<void> correctStudent(
      {required BuildContext context,
      required String spaceId,
      required String examGroupId,
      required String examid,
      required String id,
      required int index,
      required String studentId}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.correctExams(
        context: context,
        spaceId: spaceId,
        examGroupId: examGroupId,
        examId: examid,
        id: id,
        studentId: studentId,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");

        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as StudentExamSessionData;
      //  _score = data.examSession.answers[index].score;
      // setScore(data.examSession.answers[index].score);
       for (var answer in data.examSession.answers) {
        setScore(answer.questionId, answer.score);
      }
      // data.id;
      setCorrection(data);
      developer.log('success $data  ');
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('submit error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);

      notifyListeners();
      return;
    }
  }

  Future<void> markStudent(
      {required BuildContext context,
      required String examGroupId,
      required String id,
      required String spaceId,
      required String questionId,
      required String examId,
      required String studentId,
      required int index,
      required int score}) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.markExams(
        context: context,
        spaceId: spaceId,
        examGroupId: examGroupId,
        examId: examId,
        id: id,
        studentId: studentId,
        questionId: questionId,
        score: score,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERRORssss delete:  ${errorResponse?.errors.toString()}");

        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as ExamSession;
      // data.id;
      setMarked(data);
      _scoreController?.text = score.toString();
      //  _score = data.examSession.answers[index].score;
      // setScore(data.answers[index].score);
      correctStudent(
        context: context,
        spaceId: spaceId,
        examGroupId: examGroupId,
        examid: examId,
        id: id,
        studentId: studentId,
        index: index,
      );
      developer.log('success $data  ');
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('submit error $errorResponse ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);

      notifyListeners();
      return;
    }
  }



 Future<void>   getExamSummary({
    required BuildContext context,
      required String examId,
      required String examGroupId,
      required String studentId,
      required String spaceId,
      required String id
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.examBreakDown(
        context: context,
        spaceId: spaceId,
        id: id,
        examGroupId: examGroupId, 
        examId: examId,
        studentId: studentId
      );
      developer.log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
         setExamSummary(null);
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as GetStudentExamSession;
      developer.log('examined $data');
     
      setExamSummary(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
         setExamSummary(null);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }
  
  
   Future<void>   examMainSummary({
    required BuildContext context,
      required String examId,
      required String examGroupId,
     
      required String spaceId,
   
  }) async {
    developer.log('my datawwwwwwwwww $examId $examGroupId $spaceId');
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await examOrHomeWorkRepo.spaceExamBreakDown(
        context: context,
        spaceId: spaceId,
     
        examGroupId: examGroupId, 
        examId: examId,
     
      );
      developer.log('the resultwwwwssaaa ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
         setMainExamSummary(null);
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as GetExamSessionsSummaryResponse;
      developer.log('frftftefwcvds $data');
     
      setMainExamSummary(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      developer.log('the error $errorResponse ${e.toString()} ');
      setError(true);
         setExamSummary(null);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }
  
Future<bool> resetExamSession({
  required BuildContext context,
  required ExamSessionInput examSessionInput,
}) async {
  try {
    reset();
    notifyListeners();
    
    Result<dynamic> result = await examOrHomeWorkRepo.resetExamSession(
        context: context, data: examSessionInput);

    developer.log('the result ${result.response}');
    
    if (result.response is ResponseError) {
      errorResponse = result.response as ResponseError;
      print("ERRORssss:ressd ${errorResponse?.errors.toString()}");
      setError(true);
      notifyListeners();
      return false;
    }
    
    successResponse = result.response as ResponseSuccess<ExamSession>;
    ExamSession data = successResponse!.data;
    setExamSession(data);
    notifyListeners();
    return true;
    
  } catch (e) {
    errorResponse = ResponseError(message: e.toString());
    developer.log('the error resert $errorResponse ${e.toString()}');
    setError(true);
    setLoading(false);
    notifyListeners();
    return false;
  } finally {
    setLoading(false);
  }
}

  //  Future<bool> resetExamSession({
  //   required BuildContext context,
  //   required ExamSessionInput examSessionInput,
  // }) async {
  //   try {
  //     reset();
  //     // setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await examOrHomeWorkRepo.resetExamSession(
  //         context: context, data: examSessionInput);

  //     developer.log('the result ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
       
  //       print("ERRORssss:ressd  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       // setLoading(false);
  //       notifyListeners();
  //       return false;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as ExamSession;
  //     setExamSession(data);
  //     //setLoading(false);
      
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     developer.log('the error  resert $errorResponse ${e.toString()} ');
  //     setError(true);
  //     setLoading(false);
  //     notifyListeners();
  //      return false;
  //   } finally {
  //     setLoading(false);
      
  //   }
  // }
  void reset() {
    setError(false);
    setLoading(false);
    // setLoadingStateTwo(false);
    // setSuccess(false);
    notifyListeners();
  }

  void clearData() {
    _examData = [];
    _examGroup = [];
    _scoreController?.clear();
    _correction = null;
    _examSessionData = [];
    _examSessionDataSub = [];
    _examTeacherGroup = [];
    _gotExamSession = [];
    _gotWrittenExam = [];
    _exam = null;
    _examSession = null;
    _markedSession = null;
    _score = 0.0;
    sessionId = '';
    _examid = '';
    _timer?.cancel();
    timeLeft = 0;
    successResponse = null;
    errorResponse = null;
    _isLoading = false;
    _isLoadingStateTwo = false;
    _isError = false;
    notifyListeners();
  }
}

void showTimeUpDialog(
    {required BuildContext context,
    required String examId,
    required String examSessionId,
    required String examGroupId,
    required String questionId,
    required String myAnswer,
    required String spaceId}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Time Up!'),
      content:
          const Text('You have run out of time. Please submit your homework.'),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<ExamHomeProvider>(context, listen: false)
                .updateExamSession(
                    context: context,
                    examSessionInput: ExamSessionInput(
                      examId: examId,
                      spaceId: spaceId,
                      id: examSessionId,
                      examGroupId: examGroupId,
                      studentId: context.read<UserProvider>().memberId,
                      status: "completed",
                      //questionId: answer!.id,
                      answer: AnswerInput(
                        questionId: questionId,
                        answer: myAnswer,
                        resources: [],

                        // score: 0.0,
                        // isCorrect: false,
                        //score: answer?.options[optionIndex].score,
                      ),
                    ))
                .then((_) {
              Provider.of<ExamHomeProvider>(context, listen: false).stopTimer();
              developer.log(
                  'my datasssssa id id session session examsessionId $examSessionId questionId $questionId myAnswer $myAnswer');
              context.push(
                // HomeworkSubmissionScreen.routeName,
                HomeworkSubmittedScreen.routeName,
                // '/homework_submission_screen',
                extra: {
                  // 'homeworkModel': widget.homeworkModel,
                  // 'selectedAnswers': selectedAnswers,
                  // 'chosenAnswer': chosenAnswer,
                  // 'uploadFiles': uploadFiles,
                  "session": context.read<ExamHomeProvider>().examSession
                },
              );
            });
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


//StudentExamSessionData