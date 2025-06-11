import 'dart:developer';

import 'package:cloudnottapp2/src/api_strings/api_quries/user_quries.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:collection/collection.dart';
import '../models/enter_score_widget_model.dart';
import '../models/response_model.dart';
import '../repositories/result_repositories.dart';

class ResultProvider extends ChangeNotifier {
  final ResultRepositories resultProvider;
  ResultProvider({required this.resultProvider});
  ResponseSuccess? successResponse;
  ResponseError? errorResponse;
  bool _isLoading = false;
  bool _isLoadingStateTwo = false;
  bool _isError = false;
  bool _isErrorTwo = false;
  List<BasicAssessment> _assess = [];
  List<CognitiveKeyRating> _cognitiveKeyRating = [];
  List<SubjectReportModel> _report = [];
  List<Student> _students = [];
  List<GradingSystem> _gradeSystem = [];
  Space? _space;
  ResultData? _resultData;
  GetSpaceTermDate? _termDate;
  GetClassBroadsheet? _broadsheet;
  ClassModelForm? _classModel;
  BasicAssessmentSecond? _basicAssessmentSecond;

  GetClassBroadsheet? get broadsheet => _broadsheet;
  List<GradingSystem> get gradeSystem => _gradeSystem;
  ClassModelForm? get classModel => _classModel;
  GetSpaceTermDate? get termData => _termDate;
  BasicAssessmentSecond? get basicAssessmentSecond => _basicAssessmentSecond;
  List<CognitiveKeyRating> get cognitiveKeyRating => _cognitiveKeyRating;
  bool get isLoading => _isLoading;
  bool get isLoadingStateTwo => _isLoadingStateTwo;
  bool get isError => _isError;
  bool get isErrorTwo => _isErrorTwo;
  String errorMessage = '';
  List<BasicAssessment> get assess => _assess;
  List<SubjectReportModel> get report => _report;
  Space? get space => _space;
  List<Student> get students => _students;
  ResultData? get resultData => _resultData;

  void setLoading(bool value) {
    _isLoading = value;
    // notifyListeners();
  }

  void setBroadSheet(GetClassBroadsheet broad) {
    _broadsheet = broad;
    notifyListeners();
  }

  void setBroadToNull() {
    _broadsheet = null;
    // notifyListeners();
  }

  void setSpaceTermData(GetSpaceTermDate termData) {
    _termDate = termData;
    notifyListeners();
  }

  void setLoadingTwo(bool value) {
    _isLoadingStateTwo = value;
    // notifyListeners();
  }

  void setError(bool value) {
    _isError = value;
    // notifyListeners();
  }

  void setErrorTwo(bool value) {
    _isErrorTwo = value;
    notifyListeners();
  }

  void setResltData(ResultData result) {
    _resultData = result;
    notifyListeners();
  }

  setCognitiveKeyRating(List<CognitiveKeyRating> rating) {
    _cognitiveKeyRating = rating;
    notifyListeners();
  }

  void setAssessment(List<BasicAssessment> assess) {
    _assess = assess;
    notifyListeners();
  }

  void setClassMode(ClassModelForm mode) {
    _classModel = mode;
    notifyListeners();
  }

  void setGrade(List<GradingSystem> grade) {
    _gradeSystem = grade;
    notifyListeners();
  }

  // void setReport(List<SubjectReportModel> model) {
  //   _report = model;
  //   notifyListeners();
  // }
  void setReport(List<SubjectReportModel> data) {
    // ✅ Group all subjects per student
    final groupedReports = groupBy(data, (report) => report.userId);

    _report = groupedReports.values
        .expand((x) => x)
        .toList(); // ✅ Store the flattened list
    log('tttttt ${_report.map((e) => e.subject).where((subject) => subject != null)} ${_report.length}');

    notifyListeners();
  }
  // void setReport(List<SubjectReportModel> data) {
  //   // Group by userId and keep the first entry for each user
  //   final uniqueReports = <SubjectReportModel>[];
  //   final seenUserIds = <String>{};

  //   for (var report in data) {
  //     if (!seenUserIds.contains(report.userId)) {
  //       uniqueReports.add(report);
  //       seenUserIds.add(report.userId!);
  //     }
  //   }
  //   log('tttttt ${uniqueReports} ${uniqueReports.length}');
  //   _report = uniqueReports;
  //   notifyListeners();
  // }

  void setReportSpace(Space space) {
    _space = space;
    notifyListeners();
  }

  void setBasicAssessmentSecond(BasicAssessmentSecond second) {
    _basicAssessmentSecond = second;
    notifyListeners();
  }

  void setStudent(List<Student> stud) {
    _students = stud;
    notifyListeners();
  }

  Future<void> getBasicAssessments(
      {required BuildContext context,
      required String spaceId,
      required String type,
      required String classId,
      required String termId}) async {
    try {
      reset();
      setLoading(true);
      // notifyListeners();
      Result<dynamic> result = await resultProvider.getMyStudentAssessment(
          context: context,
          spaceId: spaceId,
          termId: termId,
          classId: classId,
          type: type);
      log('the result ${result.response} termid $termId');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("getBasicAssessmen:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<BasicAssessment>;
      log('assess $data');
      setAssessment(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getStudentsReport(
      {required BuildContext context,
      required String spaceId,
      required String classId,
      required List<String> subjectId,
      required String assessmentId}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.getMyStudentReport(
          context: context,
          spaceId: spaceId,
          assessmentId: assessmentId,
          classId: classId,
          subjectId: subjectId);
      log('the resultddddd ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        // print("getStudents:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<SubjectReportModel>;
      // log('assess $data');
      setReport(data);
      // final uniqueData = data
      //     .fold<Map<String, SubjectReportModel>>({}, (map, report) {
      //       if (map.containsKey(report.userId)) {
      //         // Aggregate scores if the student already exists in the map
      //         map[report.userId]!.total =
      //             (map[report.userId]!.total ?? 0) + (report.total ?? 0);
      //       } else {
      //         map[report.userId!] = report;
      //       }
      //       return map;
      //     })
      //     .values
      //     .toList();

      // setReport(uniqueData);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the errorfhfhfhfhf $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> enterStudentsScore(
      {required BuildContext context,
      required String spaceId,
      required ManySubjectReportInput input}) async {
    log('bus ${input.toJson()}');
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.enterStudentScore(
        context: context,
        spaceId: spaceId,
        input: input,
      );
      // ('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("enterScore:  ${errorResponse?.errors.toString()}");
         showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Result Updated Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  Future<void> getSpaceReportData({
    required BuildContext context,
    required String alias,
  }) async {
    try {
      reset();
      setLoading(true);
      // notifyListeners();
      Result<dynamic> result = await resultProvider.getSpaceReport(
        context: context,
        alias: alias,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as Space;
      log('reportdddddd $data');
      setReportSpace(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getStudentAssessments(
      {required BuildContext context,
      required String spaceId,
      required String classId}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.getStudent(
          context: context, spaceId: spaceId, classId: classId);
      log('the studenterr ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<Student>;
      log('student ${data.first.role}');
      setStudent(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }
Future<void> getFinalResult({
  required BuildContext context,
  required String spaceId,
  required String sessionId,
  required String termId,
  required String userId,
  required String assessmentId,
  required String classId
}) async {
  try {
    reset();
    setLoading(true);
    // notifyListeners();
    
    Result<dynamic> result = await resultProvider.getStudentResult(
      context: context,
      spaceId: spaceId,
      sessionId: sessionId,
      classId: classId,
      termId: termId,
      userId: userId,
      assessmentId: assessmentId
    );
    
    log('maxx result ${result.response} ');
    
    if (result.response is ResponseError) {
      log('getresult error ${result.response}');
      errorResponse = result.response as ResponseError;
      
      // Check specifically for subscription error
      if (errorResponse!.message!.contains("subscription") || 
          errorResponse!.message!.contains("requires an active subscription")) {
        
        // Show subscription specific error message
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "This feature requires an active subscription plan. Please upgrade to access student results.",
          ),
        );
      } else {
        // Show general error message for other errors
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
      }
      
      print("exaerr: ${errorResponse?.errors.toString()}");
      setErrorTwo(true);
      setLoading(false);
      // notifyListeners();
      
      return;
    }
    
    successResponse = result.response as ResponseSuccess;
    var data = successResponse!.data as ResultData;
    log('student $data');
    setResltData(data);
    
    await getCognitiveKeyRating(
      context: context,
      spaceId: spaceId,
      classId: classId,
    );
    
    setLoading(false);
    notifyListeners();
  } catch (e) {
    errorResponse = ResponseError(message: e.toString());
    log('the error $errorResponse ${e.toString()} ');
    
    // Check if the error is related to subscription
    if (e.toString().contains("subscription") || e.toString().contains("requires an active subscription")) {
      // Show subscription specific error using snackbar
      if (context.mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "This feature requires an active subscription plan. Please upgrade to access this content.",
          ),
        );
      }
    } else {
      // Show general error
      if (context.mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: e.toString(),
          ),
        );
      }
    }
    
    setError(true);
    setLoading(false);
    notifyListeners();
  } finally {
    setLoading(false);
  }
}
  // Future<void> getFinalResult(
  //     {required BuildContext context,
  //     required String spaceId,
  //     required String sessionId,
  //     required String termId,
  //     required String userId,
  //     required String assessmentId,
  //     required String classId}) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     // notifyListeners();
  //     Result<dynamic> result = await resultProvider.getStudentResult(
  //         context: context,
  //         spaceId: spaceId,
  //         sessionId: sessionId,
  //         classId: classId,
  //         termId: termId,
  //         userId: userId,
  //         assessmentId: assessmentId);
  //     log('maxx  resuklt ${result.response} ');
  //     if (result.response is ResponseError) {
  //       log('getresult error ${result.response}');
  //       errorResponse = result.response as ResponseError;
  //          showTopSnackBar(
  //         Overlay.of(context),
  //         CustomSnackBar.error(
  //           message: extractErrorMessage(errorResponse!),
  //         ),
  //       );
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setErrorTwo(true);
  //       setLoading(false);
  //       // notifyListeners();
        
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as ResultData;
  //     log('student $data');
  //     setResltData(data);
  //     //  final cognitiveParams = {
  //     //       'spaceId': spaceId,
  //     //       'classId': classId,
  //     //     };
  //     //     final cognitiveResult = await compute(getCognitiveKeyRating(classId: classId, context: context, spaceId: spaceId), cognitiveParams);
  //     await getCognitiveKeyRating(
  //       context: context,
  //       spaceId: spaceId,
  //       classId: classId,
  //     );
  //     setLoading(false);
  //     notifyListeners();
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     log('the error $errorResponse ${e.toString()} ');
  //     setError(true);
  //     setLoading(false);
  //     notifyListeners();
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  Future<void> publish({
    required BuildContext context,
    required String spaceId,
    required List<String> assessmentId,
    required String classId,
    required String termId,
    required String sessionId,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.publishStudentResult(
        context: context,
        spaceId: spaceId,
        sessionId: sessionId,
        termId: termId,
        classId: classId,
        assessmentId: assessmentId,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("published:  ${errorResponse?.errors.toString()}");
          showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Result Published Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  Future<void> setResumption({
    required BuildContext context,
    required String spaceId,
    required DateTime currentTermClosesOn,
    required DateTime nextTermBeginsOn,
    DateTime? boardingResumesOn,
    required int daysOpen,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.setResumptionDate(
        context: context,
        spaceId: spaceId,
        boardingResumesOn: boardingResumesOn,
        currentTermClosesOn: currentTermClosesOn,
        nextTermBeginsOn: nextTermBeginsOn,
        daysOpen: daysOpen,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("resumeed:  ${errorResponse?.errors.toString()}");
          showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Saved Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getBroadSheet({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String classId,
    required String assessmentId,
    required String spaceId,
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.getClassBroadsheet(
          context: context,
          spaceId: spaceId,
          termId: termId,
          sessionId: sessionId,
          classId: classId,
          assessmentId: assessmentId);
      log('the result ${result.response} termid $termId');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("broadsheet:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as GetClassBroadsheet;
      log('assess $data');
      setBroadSheet(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getTermDate({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String spaceId,
  }) async {
    try {
      reset();
      setLoading(true);
      // notifyListeners();

      Result<dynamic> result = await resultProvider.daysSchoolOpen(
          context: context,
          spaceId: spaceId,
          termId: termId,
          sessionId: sessionId);

      log('the result ${result.response} termid $termId');

      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("termDate:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }

      successResponse = result.response as ResponseSuccess;

      GetSpaceTermDate data;
      try {
        if (successResponse!.data == null) {
          data = GetSpaceTermDate();
        } else {
          if (successResponse!.data is Map<String, dynamic>) {
            data = GetSpaceTermDate.fromJson(
                successResponse!.data as Map<String, dynamic>);
          } else if (successResponse!.data is GetSpaceTermDate) {
            data = successResponse!.data as GetSpaceTermDate;
          } else {
            data = GetSpaceTermDate();
            log('Warning: Unexpected data type for GetSpaceTermDate: ${successResponse!.data.runtimeType}');
          }
        }
      } catch (castError) {
        log('Error casting to GetSpaceTermDate: $castError');
        data = GetSpaceTermDate();
      }

      log('assess $data');
      setSpaceTermData(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }
  // Future<void> getTermDate({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String termId,
  //   required String spaceId,
  // }) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.daysSchoolOpen(
  //         context: context,
  //         spaceId: spaceId,
  //         termId: termId,
  //         sessionId: sessionId);
  //     log('the result ${result.response} termid $termId');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoading(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as GetSpaceTermDate;
  //     log('assess $data');
  //     setSpaceTermData(data);
  //     setLoading(false);
  //     notifyListeners();
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     log('the error ${errorResponse} ${e.toString()} ');
  //     setError(true);
  //     setLoading(false);
  //     notifyListeners();
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  Future<void> markAttendance({
    required BuildContext context,
    required String spaceId,
    required List<Map<String, dynamic>> input,
    required String sessionId,
    required String termId,
    required String classId,
    required String assessmentId,
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.updateAttendanceMatatdata(
        context: context,
        spaceId: spaceId,
        input: input,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("markAttendance:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        // getBroadSheet(
        //     context: context,
        //     sessionId: sessionId,
        //     termId: termId,
        //     classId: classId,
        //     assessmentId: assessmentId,
        //     spaceId: spaceId);
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Result Updated Successfully",
          ),
        );
      }
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getFormTeacher(
      {required BuildContext context,
      required String spaceId,
      required String classId}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.getForm(
          context: context, spaceId: spaceId, classId: classId);
      log('maxx formteacher ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("formTeacher:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as ClassModelForm;
      log('student $data');
      setClassMode(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> teacherComent({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String comment,
  }) async {
    log('bus $comment');
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.addTeacherComment(
        context: context,
        spaceId: spaceId,
        resultId: resultId,
        comment: comment,
      );
      ('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("teacherCommennt:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Teacher Comment Added Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  Future<void> principalComment({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String comment,
  }) async {
    log('bus $comment');
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.addPrincipalComment(
        context: context,
        spaceId: spaceId,
        resultId: resultId,
        comment: comment,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("principalComment:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "Principal Comment Added Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  Future<void> addCognitive({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String name,
    required int rating,
    required String cognitiveKeyId,
  }) async {
    log('bus $name');
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.addCongnitive(
        context: context,
        spaceId: spaceId,
        name: name,
        cognitiveKeyId: cognitiveKeyId,
        resultId: resultId,
        rating: rating,
      );
      ('theCognitiveGet ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("cognitiveError:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      log('assess $data');
      if (data == true) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: "CognitiveKey Updated Successfully",
          ),
        );
      }
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  Future<void> getBasicAssessment({
    required BuildContext context,
    required String spaceId,
    required String assessmentID,
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.getSchoolAssessment(
        spaceId: spaceId,
        assessmentId: assessmentID,
        context: context,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("basicAssessment:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as BasicAssessmentSecond;
      log('report $data');
      setBasicAssessmentSecond(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getBasicGrading({
    required BuildContext context,
    required String spaceId,
    required String assessmentId,
  }) async {
    try {
      reset();
      setLoading(true);
      // notifyListeners();
      Result<dynamic> result = await resultProvider.getSchoolAssessment(
        spaceId: spaceId,
        assessmentId: assessmentId,
        context: context,
      );
      log('the result grade ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("basicgrading:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as BasicAssessmentSecond;
      log('report $data');
      setBasicAssessmentSecond(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getGradingSystems(
      {required BuildContext context,
      required String spaceId,
      required String assessmentId}) async {
    try {
      reset();
      setLoading(true);
      // notifyListeners();
      Result<dynamic> result = await resultProvider.getSchoolGrading(
        context: context,
        spaceId: spaceId,
        assessmentId: assessmentId,
      );
      log('the graderesult ${result.response} termid $assessmentId');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("gradingSystem:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<GradingSystem>;
      log('grade $data');
      setGrade(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('grade error $errorResponse ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getCognitiveKeyRating({
    required BuildContext context,
    required String spaceId,
    required String classId,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await resultProvider.getSchoolCognitive(
        context: context,
        spaceId: spaceId,
        classId: classId,
      );
      log('the cognitive result ${result.response}');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        debugPrint("cognitiveKeyRating:  ${errorResponse?.errors.toString()}");
           showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: extractErrorMessage(errorResponse!),
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<CognitiveKeyRating>;
      log('cognitive data $data');
      setCognitiveKeyRating(data);
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('cognitive error $errorResponse ${e.toString()}');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  void reset() {
    _report = [];
    setError(false);
    setLoading(false);
    // setLoadingStateTwo(false);
    // setSuccess(false);
  }

  void clearFilteredStudents() {
    _students = [];
    // notifyListeners();
  }

  void clearData() {
    successResponse = null;
    errorResponse = null;
    _isLoading = false;
    _termDate = null;
    _broadsheet = null;
    _isLoadingStateTwo = false;
    _isError = false;
    _assess = [];
    _report = [];
    _students = [];
    _space = null;
    _resultData = null;
    notifyListeners();
  }
 String extractErrorMessage(ResponseError error) {
  log('message $error');
  final errors = error.errors;

  if (errors == null || errors.isEmpty) {
    return "An error occurred";
  }

  try {
    final firstError = errors.first;

    
    if (firstError is Map<String, dynamic> && firstError.containsKey('message')) {
      return firstError['message'] as String;
    }

  
    final errorString = firstError.toString();
    final RegExp messageRegex = RegExp(r'message:\s*([^,]+)');
    final match = messageRegex.firstMatch(errorString);

    if (match != null && match.groupCount >= 1) {
      return match.group(1)?.trim() ?? "An error occurred";
    }
  } catch (e) {
    print("Error extracting message: $e");
  }

  return "An error occurred";
}

}
