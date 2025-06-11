import 'dart:developer';

import 'package:cloudnottapp2/src/api_strings/api_quries/user_quries.dart';
import 'package:cloudnottapp2/src/data/models/accounting_mode_second.dart'
    show StudentFeeSecond;
import 'package:cloudnottapp2/src/data/models/accounting_models.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_model.dart';
import 'package:cloudnottapp2/src/data/repositories/accounting_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:collection/collection.dart';
import '../models/enter_score_widget_model.dart';
import '../models/response_model.dart';
import '../repositories/result_repositories.dart';

class AccountingProvider extends ChangeNotifier {
  final AccountingRepositories accountProvider;
  AccountingProvider({required this.accountProvider});
  ResponseSuccess? successResponse;
  ResponseError? errorResponse;
  bool _isLoading = false;
  bool _isLoadingStateTwo = false;
  bool _isError = false;
  bool _isErrorTwo = false;
  List<StudentFeeSecond> _studentPay = [];
  List<SettlementAccount> _settlememtAcccount = [];
  // List<Student> _students = [];
  List<PaymentItemSecond> _paymentItem = [];
  Space? _space;
  List<FeePayment> _accountStudentData = [];
  List<FeePayment> _accountStudentHistoryData = [];
  List<ClassFeeData> _classFeeData = [];
  SpaceAccountingSummary? _accountingSummary;
  SpaceAccountingSummary? _accountingItemSummary;

  BasicAssessmentSecond? _basicAssessmentSecond;

  SpaceAccountingSummary? get itemFeeSummary => _accountingItemSummary;
  List<PaymentItemSecond> get paymentItem => _paymentItem;
  List<ClassFeeData> get classFeeData => _classFeeData;
  SpaceAccountingSummary? get accountingSummary => _accountingSummary;
  BasicAssessmentSecond? get basicAssessmentSecond => _basicAssessmentSecond;
  bool get isLoading => _isLoading;
  bool get isLoadingStateTwo => _isLoadingStateTwo;
  bool get isError => _isError;
  bool get isErrorTwo => _isErrorTwo;
  String errorMessage = '';
  List<StudentFeeSecond> get studentPay => _studentPay;
  List<SettlementAccount> get settlementAccount => _settlememtAcccount;
  Space? get space => _space;
  // List<Student> get students => _students;
  List<FeePayment> get accountStudentData => _accountStudentData;
  List<FeePayment> get accountStudentHistoryData => _accountStudentHistoryData;

  void setLoading(bool value) {
    _isLoading = value;
    // notifyListeners();
  }

  void setFeeItemSummary(SpaceAccountingSummary broad) {
    _accountingItemSummary = broad;
    notifyListeners();
  }

  void setAccountSummaryData(SpaceAccountingSummary? summary) {
    _accountingSummary = summary;
    notifyListeners();
  }

  void setLoadingTwo(bool value) {
    _isLoadingStateTwo = value;
    notifyListeners();
  }

  void setError(bool value) {
    _isError = value;
    // notifyListeners();
  }

  void setErrorTwo(bool value) {
    _isErrorTwo = value;
    notifyListeners();
  }

  void setAccountStudentData(List<FeePayment> result) {
    _accountStudentData = result;
    notifyListeners();
  }

  void setAccountHistory(List<FeePayment> result) {
    _accountStudentHistoryData = result;
    notifyListeners();
  }

  void setStudentPaidFees(List<StudentFeeSecond> assess) {
    _studentPay = assess;
    notifyListeners();
  }

  void setClassFee(List<ClassFeeData> mode) {
    _classFeeData = mode;
    notifyListeners();
  }

  void setItem(List<PaymentItemSecond> grade) {
    _paymentItem = grade;
    notifyListeners();
  }

  void setSettement(List<SettlementAccount> model) {
    _settlememtAcccount = model;
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

  // void setStudent(List<Student> stud) {
  //   _students = stud;
  //   notifyListeners();
  // }

  Future<void> getBasicPayment(
      {required BuildContext context,
      required String spaceId,
      required String spaceSessionId,
      required List<String> spaceTermIds}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await accountProvider.getStudentFeePayment(
          context: context,
          spaceId: spaceId,
          spaceSessionId: spaceSessionId,
          spaceTermIds: spaceTermIds);
      log('the result ${result.response} termid $spaceTermIds spaceID $spaceId spaceSessionId $spaceSessionId');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<FeePayment>;
      log('fee $data');
      setAccountStudentData(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getStudentsPayment(
      {required BuildContext context,
      required String spaceId,
      required List<String> spaceSessionIds,
      required List<String> spaceTermIds,
      required String studentId}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await accountProvider.getMyStudentAccount(
          context: context,
          spaceId: spaceId,
          spaceSessionIds: spaceSessionIds,
          spaceTermIds: spaceTermIds,
          studentId: studentId);
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<StudentFeeSecond>;
      // log('assess $data');
      setStudentPaidFees(data);
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
      await getSpaceSettlementAccount(
        context: context,
        spaceId: spaceId,
      );
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getAccountSummary(
      {required BuildContext context,
      required String spaceId,
      required List<String> spaceTermIds,
      required String spaceSessionId}) async {
    log('bus ${spaceId} i ${spaceTermIds} ii ${spaceSessionId}');
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await accountProvider.getAccountSummary(
        context: context,
        spaceId: spaceId,
        spaceSessionId: spaceSessionId,
        spaceTermIds: spaceTermIds,
      );
      // ('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setError(true);
        setAccountSummaryData(null);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as SpaceAccountingSummary;
      log('assess $data');
      setAccountSummaryData(data);
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  Future<void> getSpaceSettlementAccount({
    required BuildContext context,
    required String spaceId,
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await accountProvider.getMySettlementAccount(
        context: context,
        spaceId: spaceId,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<SettlementAccount>;
      log('report $data');
      setSettement(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getStudentPaymentItem({
    required BuildContext context,
    required String spaceId,
  }) async {
    try {
      reset();
      setLoading(true);
      // notifyListeners();
      Result<dynamic> result = await accountProvider.getStudentPaymentItems(
        context: context,
        spaceId: spaceId,
      );
      log('the studenterr ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<PaymentItemSecond>;
      log('student ${data.first}');
      setItem(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> getFeeItemSummary({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
    required List<String> paymentItemIds,
  }) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      Result<dynamic> result = await accountProvider.getAccountItemSummary(
        context: context,
        spaceId: spaceId,
        spaceSessionId: spaceSessionId,
        spaceTermIds: spaceTermIds,
        paymentItemIds: paymentItemIds,
      );
      log('maxx ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        errorMessage = errorResponse?.errors
                ?.map((e) =>
                    e.message) // Extracts the message from each GraphQLError
                ?.join(", ") ??
            "Unknown error";
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setErrorTwo(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as SpaceAccountingSummary;
      log('student $data');
      setFeeItemSummary(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> classFee({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  }) async {
    try {
      reset();
      setLoadingTwo(true);
      notifyListeners();
      Result<dynamic> result = await accountProvider.getClassSummaryFee(
        context: context,
        spaceId: spaceId,
        spaceSessionId: spaceSessionId,
        spaceTermIds: spaceTermIds,
      );
      log('the result ${result.response} ');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "${errorResponse?.message}",
          ),
        );
        setError(true);
        setLoadingTwo(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<ClassFeeData>;
      setClassFee(data);
      setLoadingTwo(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoadingTwo(false);
      notifyListeners();
    } finally {
      setLoadingTwo(false);
    }
  }

  Future<void> getBasicPaymentHistory(
      {required BuildContext context,
      required String spaceId,
      required String spaceSessionId,
      required String studentId,
      required List<String> spaceTermIds}) async {
    try {
      reset();
      setLoading(true);
      notifyListeners();
      final args = {
        'accountProvider': accountProvider,
        'context': context,
        'spaceId': spaceId,
        'spaceSessionId': spaceSessionId,
        'spaceTermIds': spaceTermIds,
        'studentId': studentId,
      };
      //Result result = await compute(fetchPaymentHistoryInIsolate, args);
      Result<dynamic> result = await accountProvider.getFeePaymentHistory(
          context: context,
          spaceId: spaceId,
          spaceSessionId: spaceSessionId,
          spaceTermIds: spaceTermIds,
          studentIds: [
            studentId
          ]); // Add empty list or provide actual student IDs
      log('the result ${result.response} termid $spaceTermIds spaceID $spaceId spaceSessionId $spaceSessionId');
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("exaerr:  ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as List<FeePayment>;
      log('fee $data');
      setAccountHistory(data);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      log('the error ${errorResponse} ${e.toString()} ');
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  // Future<void> getBroadSheet({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String termId,
  //   required String classId,
  //   required String assessmentId,
  //   required String spaceId,
  // }) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.getClassBroadsheet(
  //         context: context,
  //         spaceId: spaceId,
  //         termId: termId,
  //         sessionId: sessionId,
  //         classId: classId,
  //         assessmentId: assessmentId);
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
  //     var data = successResponse!.data as GetClassBroadsheet;
  //     log('assess $data');
  //     setBroadSheet(data);
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

  // Future<void> markAttendance({
  //   required BuildContext context,
  //   required String spaceId,
  //   required List<Map<String, dynamic>> input,
  //   required String sessionId,
  //   required String termId,
  //   required String classId,
  //   required String assessmentId,
  // }) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.updateAttendanceMatatdata(
  //       context: context,
  //       spaceId: spaceId,
  //       input: input,
  //     );
  //     log('the result ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoading(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as bool;
  //     log('assess $data');
  //     if (data == true) {
  //       // getBroadSheet(
  //       //     context: context,
  //       //     sessionId: sessionId,
  //       //     termId: termId,
  //       //     classId: classId,
  //       //     assessmentId: assessmentId,
  //       //     spaceId: spaceId);
  //       showTopSnackBar(
  //         Overlay.of(context),
  //         CustomSnackBar.success(
  //           message: "Result Updated Successfully",
  //         ),
  //       );
  //     }
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

  // Future<void> getFormTeacher(
  //     {required BuildContext context,
  //     required String spaceId,
  //     required String classId}) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.getForm(
  //         context: context, spaceId: spaceId, classId: classId);
  //     log('maxx ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoading(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as ClassModelForm;
  //     log('student $data');
  //     setClassMode(data);
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

  // Future<void> teacherComent({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String comment,
  // }) async {
  //   log('bus ${comment}');
  //   try {
  //     reset();
  //     setLoadingTwo(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.addTeacherComment(
  //       context: context,
  //       spaceId: spaceId,
  //       resultId: resultId,
  //       comment: comment,
  //     );
  //     ('the result ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoadingTwo(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as bool;
  //     log('assess $data');
  //     if (data == true) {
  //       showTopSnackBar(
  //         Overlay.of(context),
  //         CustomSnackBar.success(
  //           message: "Teacher Comment Added Successfully",
  //         ),
  //       );
  //     }
  //     setLoadingTwo(false);
  //     notifyListeners();
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     log('the error ${errorResponse} ${e.toString()} ');
  //     setError(true);
  //     setLoadingTwo(false);
  //     notifyListeners();
  //   } finally {
  //     setLoadingTwo(false);
  //   }
  // }

  // Future<void> principalComment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String comment,
  // }) async {
  //   log('bus ${comment}');
  //   try {
  //     reset();
  //     setLoadingTwo(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.addPrincipalComment(
  //       context: context,
  //       spaceId: spaceId,
  //       resultId: resultId,
  //       comment: comment,
  //     );
  //     ('the result ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoadingTwo(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as bool;
  //     log('assess $data');
  //     if (data == true) {
  //       showTopSnackBar(
  //         Overlay.of(context),
  //         CustomSnackBar.success(
  //           message: "Principal Comment Added Successfully",
  //         ),
  //       );
  //     }
  //     setLoadingTwo(false);
  //     notifyListeners();
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     log('the error ${errorResponse} ${e.toString()} ');
  //     setError(true);
  //     setLoadingTwo(false);
  //     notifyListeners();
  //   } finally {
  //     setLoadingTwo(false);
  //   }
  // }

  // Future<void> addCognitive({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String name,
  //   required int rating,
  //   required String cognitiveKeyId,
  // }) async {
  //   log('bus ${name}');
  //   try {
  //     reset();
  //     setLoadingTwo(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.addCongnitive(
  //       context: context,
  //       spaceId: spaceId,
  //       name: name,
  //       cognitiveKeyId: cognitiveKeyId,
  //       resultId: resultId,
  //       rating: rating,
  //     );
  //     ('the result ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoadingTwo(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as bool;
  //     log('assess $data');
  //     if (data == true) {
  //       showTopSnackBar(
  //         Overlay.of(context),
  //         CustomSnackBar.success(
  //           message: "CognitiveKey Successfully",
  //         ),
  //       );
  //     }
  //     setLoadingTwo(false);
  //     notifyListeners();
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     log('the error ${errorResponse} ${e.toString()} ');
  //     setError(true);
  //     setLoadingTwo(false);
  //     notifyListeners();
  //   } finally {
  //     setLoadingTwo(false);
  //   }
  // }

  // Future<void> getBasicAssessment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String assessmentID,
  // }) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.getSchoolAssessment(
  //       spaceId: spaceId,
  //       assessmentId: assessmentID,
  //       context: context,
  //     );
  //     log('the result ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoading(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as BasicAssessmentSecond;
  //     log('report $data');
  //     setBasicAssessmentSecond(data);
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

  // Future<void> getBasicGrading({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String assessmentId,
  // }) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.getSchoolAssessment(
  //       spaceId: spaceId,
  //       assessmentId: assessmentId,
  //       context: context,
  //     );
  //     log('the result ${result.response} ');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoading(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as BasicAssessmentSecond;
  //     log('report $data');
  //     setBasicAssessmentSecond(data);
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

  // Future<void> getGradingSystems(
  //     {required BuildContext context,
  //     required String spaceId,
  //     required String assessmentId}) async {
  //   try {
  //     reset();
  //     setLoading(true);
  //     notifyListeners();
  //     Result<dynamic> result = await resultProvider.getSchoolGrading(
  //       context: context,
  //       spaceId: spaceId,
  //       assessmentId: assessmentId,
  //     );
  //     log('the result ${result.response} termid $assessmentId');
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       print("exaerr:  ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoading(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     var data = successResponse!.data as List<GradingSystem>;
  //     log('grade $data');
  //     setGrade(data);
  //     setLoading(false);
  //     notifyListeners();
  //   } catch (e) {
  //     errorResponse = ResponseError(message: e.toString());
  //     log('grade error ${errorResponse} ${e.toString()} ');
  //     setError(true);
  //     setLoading(false);
  //     notifyListeners();
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  void reset() {
    _settlememtAcccount = [];
    setError(false);
    setLoading(false);
    // setLoadingStateTwo(false);
    // setSuccess(false);
  }

  // void clearFilteredStudents() {
  //   _students = [];
  //   notifyListeners();
  // }

  // void clearData() {
  //   successResponse = null;
  //   errorResponse = null;
  //   _isLoading = false;
  //   _termDate = null;
  //   _broadsheet = null;
  //   _isLoadingStateTwo = false;
  //   _isError = false;
  //   _assess = [];
  //   _report = [];
  //   _students = [];
  //   _space = null;
  //   _resultData = null;
  //   notifyListeners();
  // }
}

Future<Result> fetchPaymentHistoryInIsolate(Map<String, dynamic> args) async {
  return await args['accountProvider'].getFeePaymentHistory(
    context: args['context'],
    spaceId: args['spaceId'],
    spaceSessionId: args['spaceSessionId'],
    spaceTermIds: args['spaceTermIds'],
    studentIds: [args['studentId']],
  );
}
