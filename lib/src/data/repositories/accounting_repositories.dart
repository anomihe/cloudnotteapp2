import 'dart:developer';
import 'dart:isolate';

import 'package:cloudnottapp2/src/api_strings/api_quries/account_queri_mutation.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/accounting_models.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/accounting_mode_second.dart' show StudentFeeSecond;
import '../models/enter_score_widget_model.dart';

abstract class AccountingRepositories {
  Future<Result<dynamic>> getStudentFeePayment({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  });
  Future<Result<dynamic>> getMyStudentAccount(
      {required BuildContext context,
      required String spaceId,
      required List<String> spaceSessionIds,
      required List<String> spaceTermIds,
      required String studentId});

  Future<Result<dynamic>> getMySettlementAccount({
    required BuildContext context,
    required String spaceId,
  });
  Future<Result<dynamic>> getAccountSummary({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  });
  Future<Result<dynamic>> getStudentPaymentItems({
    required BuildContext context,
    required String spaceId,
  });
  Future<Result<dynamic>> getAccountItemSummary({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
    required List<String> paymentItemIds,
  });
  Future<Result<dynamic>> getClassSummaryFee({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  });
  Future<Result<dynamic>> getFeePaymentHistory({
    required BuildContext context,
    required String spaceId,
    required List<String> studentIds,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  });

  // Future<Result<dynamic>> getClassBroadsheet({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String termId,
  //   required String classId,
  //   required String assessmentId,
  //   required String spaceId,
  // });

  // Future<Result<dynamic>> daysSchoolOpen({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String termId,
  //   required String spaceId,
  // });
  // Future<Result<dynamic>> updateAttendanceMatatdata({
  //   required BuildContext context,
  //   required String spaceId,
  //   required List<Map<String, dynamic>> input,
  // });
  // Future<Result<dynamic>> getForm({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String classId,
  // });
  // Future<Result<dynamic>> addTeacherComment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String comment,
  // });
  // Future<Result<dynamic>> addPrincipalComment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String comment,
  // });

  // Future<Result<dynamic>> addCongnitive({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String name,
  //   required int rating,
  //   required String cognitiveKeyId,
  // });

  // Future<Result<dynamic>> getSchoolAssessment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String assessmentId,
  // });

  // Future<Result<dynamic>> getSchoolGrading({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String assessmentId,
  // });
}

class AccountingRepositoriesImpl implements AccountingRepositories {
  static GraphQLConfig graphqlConfig = GraphQLConfig();

  @override
  Future<Result<dynamic>> getStudentFeePayment({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token tojson $spaceId ');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getStudentFeeQuery),
          variables: {
            "input": {
              "spaceId": spaceId,
              "spaceSessionId": spaceSessionId,
              "spaceTermIds": spaceTermIds,
              "paymentMethod": null,
              "status": null,
              "pageSize": 100
            }
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      log('result:sss $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      final Map<String, dynamic> getFeePayments =
          result.data!['getFeePayments'] as Map<String, dynamic>;
      final List<dynamic> data = getFeePayments['data'] as List<dynamic>;
      final List<FeePayment> feePayments = data
          .map((json) => FeePayment.fromJson(json as Map<String, dynamic>))
          .toList();
      return Result(
        response: ResponseSuccess<List<FeePayment>>(
          data: feePayments,
          message: "getFeePayments",
        ),
      );
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result<dynamic>> getMyStudentAccount(
      {required BuildContext context,
      required String spaceId,
      required List<String> spaceSessionIds,
      required List<String> spaceTermIds,
      required String studentId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token tojson $spaceId $studentId $spaceSessionIds $spaceTermIds');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getStudentAccountingFeesQuery),
          variables: {
            "input": {
              "spaceId": spaceId,
              "studentId": studentId,
              "spaceSessionIds": spaceSessionIds,
              "spaceTermIds": spaceTermIds,
              "pageSize": 100
            }
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      log('result:sss $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      final Map<String, dynamic> getFeePayments =
          result.data!['getStudentAccountingFees'] as Map<String, dynamic>;
      final List<dynamic> data = getFeePayments['data'] as List<dynamic>;

      final lessonNotes =
          data.map((json) => StudentFeeSecond.fromJson(json)).toList();
      return Result(
        response: ResponseSuccess<List<StudentFeeSecond>>(
          data: lessonNotes,
          message: "getStudentAccountingFees",
        ),
      );
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result> getAccountSummary({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('ttttttspace $spaceId class $spaceSessionId term $spaceTermIds');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(getSummaryFeeQuery),
        variables: {
          "input": {
            "spaceId": spaceId,
            "spaceSessionId": spaceSessionId,
            "spaceTermIds": spaceTermIds,
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group ${result.data} exeception ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getAccountSummary(
              context: context,
              spaceId: spaceId,
              spaceSessionId: spaceSessionId,
              spaceTermIds: spaceTermIds,
            );
          }
        }
        return Result(
          response: ResponseError(
            message: result.exception.toString(),
            errors: result.exception?.graphqlErrors,
          ),
        );
      }

      return Result(
        response: ResponseSuccess<SpaceAccountingSummary>.fromJson(
            result.data!,
            (data) => SpaceAccountingSummary.fromJson(data),
            "getSpaceAccountingSummary"),
      );
    } catch (e) {
      log('errostd $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getStudentPaymentItems({
    required BuildContext context,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${spaceId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(getPaymentItemSummary),
        variables: {
          "input": {"spaceId": spaceId, "pageSize": 100}
        },
        // variables: input.toJson(),
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getStudentPaymentItems(
                context: context, spaceId: spaceId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      // final userLessonCreate = result.data?['updateManySubjectReport'] as bool?;
      // if (userLessonCreate == null) {
      //   return Result(
      //     response:
      //         ResponseError(message: "getUserSpaces key is null or missing"),
      //   );
      // }
      final Map<String, dynamic> getFeePaymentsItems =
          result.data!['getPaymentItems'] as Map<String, dynamic>;
      final List<dynamic> data = getFeePaymentsItems['data'] as List<dynamic>;
      final items =
          data.map((json) => PaymentItemSecond.fromJson(json)).toList();
      return Result(
        response: ResponseSuccess<List<PaymentItemSecond>>(
          data: items,
          message: "updateManySubjectReport",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getAccountItemSummary({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
    required List<String> paymentItemIds,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space {}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(getPaymentItemSummaryQuery),
        variables: {
          "input": {
            "spaceId": spaceId,
            "spaceSessionId": spaceSessionId,
            "spaceTermIds": spaceTermIds,
            "paymentItemIds": paymentItemIds
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getAccountItemSummary(
                context: context,
                spaceId: spaceId,
                spaceSessionId: spaceSessionId,
                spaceTermIds: spaceTermIds,
                paymentItemIds: paymentItemIds);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      return Result(
        response: ResponseSuccess<SpaceAccountingSummary>.fromJson(
            result.data!,
            (data) => SpaceAccountingSummary.fromJson(data),
            "getPaymentItemSummary"),
      );
    } catch (e) {
      log('errostd $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  Future<bool> showRetryDialog(BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Retry"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Future<Result> getMySettlementAccount({
    required BuildContext context,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token alias $spaceId');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getSettlementAccountQuery),
          variables: {
            "input": {"spaceId": spaceId}
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      print('result:sss $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      /// final Map<String, dynamic> data = result.data!['getSettlementAccounts'];
      final List<dynamic> dataList = result.data!['getSettlementAccounts'];
      final List<SettlementAccount> lessonNote = dataList
          .map((data) =>
              SettlementAccount.fromJson(data as Map<String, dynamic>))
          .toList();

      return Result(
          response: ResponseSuccess<List<SettlementAccount>>(
        data: lessonNote,
        message: "getSettlementAccounts",
      ));
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result> getClassSummaryFee({
    required BuildContext context,
    required String spaceId,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(getClassAccounting),
        variables: {
          "input": {
            "spaceId": spaceId,
            "spaceSessionId": spaceSessionId,
            "spaceTermIds": spaceTermIds,
            "pageSize": 20
          }
        },
        // variables: input.toJson(),
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getClassSummaryFee(
              context: context,
              spaceId: spaceId,
              spaceSessionId: spaceSessionId,
              spaceTermIds: spaceTermIds,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final Map<String, dynamic> getFeePaymentsItems = result
          .data!['getAccountingClassesFeeSummary'] as Map<String, dynamic>;
      final List<dynamic> data = getFeePaymentsItems['data'] as List<dynamic>;
      final items = data.map((json) => ClassFeeData.fromJson(json)).toList();
      return Result(
        response: ResponseSuccess<List<ClassFeeData>>(
          data: items,
          message: "data",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getFeePaymentHistory({
    required BuildContext context,
    required String spaceId,
    required List<String> studentIds,
    required String spaceSessionId,
    required List<String> spaceTermIds,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${studentIds}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(getFeeHistoryQuery),
        variables: {
          "input": {
            "spaceId": spaceId,
            "studentIds": studentIds,
            "spaceSessionId": spaceSessionId,
            "spaceTermIds": spaceTermIds,
            "pageSize": 100,
            "status": null,
            "paymentMethod": null
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getFeePaymentHistory(
              context: context,
              spaceId: spaceId,
              studentIds: studentIds,
              spaceSessionId: spaceSessionId,
              spaceTermIds: spaceTermIds,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final Map<String, dynamic> getFeePaymentsItems =
          result.data!['getFeePayments'] as Map<String, dynamic>;
      final List<dynamic> data = getFeePaymentsItems['data'] as List<dynamic>;
      // final items = data.map((json) => FeePayment.fromJson(json)).toList();
      final List<FeePayment> items = await compute(parseFeePayments, data);
      return Result(
        response: ResponseSuccess<List<FeePayment>>(
          data: items,
          message: "getFeePayments",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  // @override
  // Future<Result> updateAttendanceMatatdata({
  //   required BuildContext context,
  //   required String spaceId,
  //   required List<Map<String, dynamic>> input,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log(' space ${input}}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.mutate(MutationOptions(
  //       document: gql(updateAttendanceMatatdataMutatation),
  //       variables: {
  //         "input": input,
  //         "spaceId": spaceId,
  //       },
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await updateAttendanceMatatdata(
  //             context: context,
  //             spaceId: spaceId,
  //             input: input,
  //           );
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }

  //     final userLessonCreate = result.data?['updateResultsMetadata'] as bool?;
  //     if (userLessonCreate == null) {
  //       return Result(
  //         response:
  //             ResponseError(message: "getUserSpaces key is null or missing"),
  //       );
  //     }

  //     return Result(
  //       response: ResponseSuccess<bool>(
  //         data: userLessonCreate,
  //         message: "updateResultsMetadata",
  //       ),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Result> daysSchoolOpen({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String termId,
  //   required String spaceId,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log(' space ${termId}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.mutate(MutationOptions(
  //       document: gql(getNumberOfDaysOpen),
  //       variables: {
  //         "spaceId": spaceId,
  //         "sessionId": sessionId,
  //         "termId": termId
  //       },
  //       // variables: input.toJson(),
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await daysSchoolOpen(
  //             context: context,
  //             sessionId: sessionId,
  //             termId: termId,
  //             spaceId: spaceId,
  //           );
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }

  //     return Result(
  //       response: ResponseSuccess<GetSpaceTermDate>.fromJson(result.data!,
  //           (data) => GetSpaceTermDate.fromJson(data), "getSpaceTermDate"),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Result> getStudentResult({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String termId,
  //   required String userId,
  //   required String assessmentId,
  //   required String spaceId,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log('notedId $termId space $spaceId token $token');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

  //     log('token $token tojson  ${termId}');
  //     QueryResult result = await client.query(
  //       QueryOptions(
  //         document: gql(getResultQuery),
  //         variables: {
  //           "input": {
  //             "sessionId": sessionId,
  //             "termId": termId,
  //             "userId": userId,
  //             "assessmentId": assessmentId,
  //             "spaceId": spaceId
  //           }
  //         },
  //         fetchPolicy: FetchPolicy.networkOnly,
  //       ),
  //     );
  //     log('plan $result');
  //     if (result.hasException) {
  //       throw Exception(result.exception.toString());
  //     }

  //     final Map<String, dynamic> data = result.data!['getResult'];
  //     final ResultData lessonNote = ResultData.fromJson(data);

  //     return Result(
  //         response: ResponseSuccess<ResultData>(
  //       data: lessonNote,
  //       message: "getResult",
  //     ));
  //   } catch (e) {
  //     log('errors from $e');
  //     throw Exception(e.toString());
  //   }
  // }

  // @override
  // Future<Result> getForm({
  //   required BuildContext context,
  //   required String classId,
  //   required String spaceId,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log(' space ${classId}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.mutate(MutationOptions(
  //       document: gql(classFormQuery),
  //       variables: {"classId": classId, "spaceId": spaceId},
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await getForm(
  //             context: context,
  //             classId: classId,
  //             spaceId: spaceId,
  //           );
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }

  //     return Result(
  //       response: ResponseSuccess<ClassModelForm>.fromJson(
  //           result.data!, (data) => ClassModelForm.fromJson(data), "getClass"),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Result> addTeacherComment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String comment,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log(' space ${comment}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.mutate(MutationOptions(
  //       document: gql(addFormTeacherMutation),
  //       variables: {
  //         "spaceId": spaceId,
  //         "resultId": resultId,
  //         "comment": comment
  //       },
  //       // variables: input.toJson(),
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await addPrincipalComment(
  //               context: context,
  //               spaceId: spaceId,
  //               resultId: resultId,
  //               comment: comment);
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }

  //     final userLessonCreate = result.data?['updateManySubjectReport'] as bool?;
  //     if (userLessonCreate == null) {
  //       return Result(
  //         response:
  //             ResponseError(message: "getUserSpaces key is null or missing"),
  //       );
  //     }

  //     return Result(
  //       response: ResponseSuccess<bool>(
  //         data: userLessonCreate,
  //         message: "updateManySubjectReport",
  //       ),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Result> addPrincipalComment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String comment,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log(' space ${comment}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.mutate(MutationOptions(
  //       document: gql(addPrincipalMutation),
  //       variables: {
  //         "spaceId": spaceId,
  //         "resultId": resultId,
  //         "comment": comment
  //       },
  //       // variables: input.toJson(),
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await addPrincipalComment(
  //               context: context,
  //               spaceId: spaceId,
  //               resultId: resultId,
  //               comment: comment);
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }

  //     final userLessonCreate = result.data?['updateManySubjectReport'] as bool?;
  //     if (userLessonCreate == null) {
  //       return Result(
  //         response:
  //             ResponseError(message: "getUserSpaces key is null or missing"),
  //       );
  //     }

  //     return Result(
  //       response: ResponseSuccess<bool>(
  //         data: userLessonCreate,
  //         message: "updateManySubjectReport",
  //       ),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Result> addCongnitive({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String resultId,
  //   required String name,
  //   required int rating,
  //   required String cognitiveKeyId,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log('cognitive $name ${cognitiveKeyId}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.mutate(MutationOptions(
  //       document: gql(updateCognitiveDomainMutation),
  //       variables: {
  //         // "input": {
  //         //   "cognitiveKeyId": cognitiveKeyId,
  //         //   "name": name,
  //         //   "spaceId": spaceId
  //         // }
  //         "input": {
  //           "resultId": resultId,
  //           "spaceId": spaceId,
  //           "ratings": [
  //             {
  //               "cognitiveKeyId": cognitiveKeyId,
  //               "rating": rating,
  //             }
  //           ]
  //         }
  //       },
  //       // variables: input.toJson(),
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await addCongnitive(
  //               context: context,
  //               spaceId: spaceId,
  //               resultId: resultId,
  //               name: name,
  //               rating: rating,
  //               cognitiveKeyId: cognitiveKeyId);
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }

  //     final userLessonCreate = result.data?['updateCognitiveKey'] as bool?;
  //     if (userLessonCreate == null) {
  //       return Result(
  //         response:
  //             ResponseError(message: "getUserSpaces key is null or missing"),
  //       );
  //     }

  //     return Result(
  //       response: ResponseSuccess<bool>(
  //         data: userLessonCreate,
  //         message: "updateCognitiveKey",
  //       ),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Result> getSchoolAssessment({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String assessmentId,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log(' space ${assessmentId}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.query(QueryOptions(
  //       document: gql(basicAssesmentQuery),
  //       variables: {
  //         "spaceId": spaceId,
  //         "assessmentId": assessmentId,
  //       },
  //       // variables: input.toJson(),
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await getSchoolAssessment(
  //             context: context,
  //             spaceId: spaceId,
  //             assessmentId: assessmentId,
  //           );
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }

  //     return Result(
  //       response: ResponseSuccess<BasicAssessmentSecond>.fromJson(
  //           result.data!,
  //           (data) => BasicAssessmentSecond.fromJson(data),
  //           "getBasicAssessment"),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Result> getSchoolGrading({
  //   required BuildContext context,
  //   required String spaceId,
  //   required String assessmentId,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     log(' space ${assessmentId}');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.query(QueryOptions(
  //       document: gql(gradingSystemQuery),
  //       variables: {
  //         "spaceId": spaceId,
  //         "assessmentId": assessmentId,
  //       },
  //       // variables: input.toJson(),
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     log('schedules group ${result.data} ${result.exception} token $token');
  //     if (result.hasException) {
  //       if (result.exception?.linkException != null) {
  //         bool shouldRetry =
  //             await showRetryDialog(context, "Network error. Retry?");
  //         if (shouldRetry) {
  //           return await getSchoolGrading(
  //             context: context,
  //             spaceId: spaceId,
  //             assessmentId: assessmentId,
  //           );
  //         }
  //       }
  //       return Result(
  //           response: ResponseError(
  //         message: result.exception.toString(),
  //         errors: result.exception?.graphqlErrors,
  //       ));
  //     }
  //     final List<dynamic> data = result.data!['getGradingSystems'];
  //     final grade = data.map((json) => GradingSystem.fromJson(json)).toList();
  //     return Result(
  //       response: ResponseSuccess<List<GradingSystem>>(
  //         data: grade,
  //         message: "getGradingSystems",
  //       ),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }
  List<FeePayment> parseFeePayments(List<dynamic> data) {
    print("🧠 Running in isolate: ${Isolate.current.debugName}");
    return data.map((json) => FeePayment.fromJson(json)).toList();
  }
}
