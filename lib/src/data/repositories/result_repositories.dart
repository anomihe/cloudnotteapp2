import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../api_strings/api_quries/result_query_mutation.dart';
import '../models/enter_score_model.dart';
import '../models/enter_score_widget_model.dart';

abstract class ResultRepositories {
  Future<Result<dynamic>> enterStudentScore(
      {required BuildContext context,
      required String spaceId,
      required ManySubjectReportInput input});
  Future<Result<dynamic>> getMyStudentAssessment(
      {required BuildContext context,
      required String spaceId,
      required String type,
      required String classId,
      required String termId});

  Future<Result<dynamic>> getMyStudentReport(
      {required BuildContext context,
      required String spaceId,
      required String assessmentId,
      required String classId,
      required List<String> subjectId});
  Future<Result<dynamic>> getSpaceReport({
    required BuildContext context,
    required String alias,
  });
  Future<Result<dynamic>> getStudent({
    required BuildContext context,
    required String spaceId,
    required String classId,
  });
  Future<Result<dynamic>> getStudentResult({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String userId,
    required String classId,
    required String assessmentId,
    required String spaceId,
  });
  Future<Result<dynamic>> publishStudentResult({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String classId,
    required List<String> assessmentId,
    required String spaceId,
  });
  Future<Result<dynamic>> setResumptionDate({
    required BuildContext context,
    required DateTime currentTermClosesOn,
    required DateTime nextTermBeginsOn,
    DateTime? boardingResumesOn,
    required int daysOpen,
    required String spaceId,
  });

  Future<Result<dynamic>> getClassBroadsheet({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String classId,
    required String assessmentId,
    required String spaceId,
  });

  Future<Result<dynamic>> daysSchoolOpen({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String spaceId,
  });
  Future<Result<dynamic>> updateAttendanceMatatdata({
    required BuildContext context,
    required String spaceId,
    required List<Map<String, dynamic>> input,
  });
  Future<Result<dynamic>> getForm({
    required BuildContext context,
    required String spaceId,
    required String classId,
  });
  Future<Result<dynamic>> addTeacherComment({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String comment,
  });
  Future<Result<dynamic>> addPrincipalComment({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String comment,
  });

  Future<Result<dynamic>> addCongnitive({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String name,
    required int rating,
    required String cognitiveKeyId,
  });

  Future<Result<dynamic>> getSchoolAssessment({
    required BuildContext context,
    required String spaceId,
    required String assessmentId,
  });

  Future<Result<dynamic>> getSchoolGrading({
    required BuildContext context,
    required String spaceId,
    required String assessmentId,
  });
  Future<Result<dynamic>> getSchoolCognitive({
    required BuildContext context,
    required String spaceId,
    required String classId,
  });
}

class ResultRepositoryImpl implements ResultRepositories {
  static GraphQLConfig graphqlConfig = GraphQLConfig();

  @override
  Future<Result<dynamic>> getMyStudentAssessment({
    required BuildContext context,
    required String spaceId,
    required String termId,
    required String type,
    required String classId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('assess token $token tojson $spaceId class $classId');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(assessmentQuery),
          variables: {
            "input": {
              "spaceId": spaceId,
              "termId": termId,
              "classId": classId,
              // "type": type,
            }
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      log('result:sssas $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final List<dynamic> data = result.data!['getAssessments'];
      final assessments =
          data.map((json) => BasicAssessment.fromJson(json)).toList();
      return Result(
          response: ResponseSuccess<List<BasicAssessment>>(
        data: assessments,
        message: "getMyStudentAssessment",
      ));
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result<dynamic>> getMyStudentReport(
      {required BuildContext context,
      required String spaceId,
      required String assessmentId,
      required String classId,
      required List<String> subjectId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token tojson $spaceId $subjectId class $classId, assessmentId$assessmentId');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getManySubjectReport),
          variables: {
            "input": {
              "classId": classId,
              "assessmentId": assessmentId,
              "subjectIds": subjectId,
              "pagination": {"limit": 100, "afterId": ""}
            },
            "spaceId": spaceId
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      log('result:sss $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final List<dynamic> data = result.data!['getManySubjectReport'];
      final lessonNotes =
          data.map((json) => SubjectReportModel.fromJson(json)).toList();
      return Result(
        response: ResponseSuccess<List<SubjectReportModel>>(
          data: lessonNotes,
          message: "getManySubjectReport",
        ),
      );
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result> getStudent({
    required BuildContext context,
    required String spaceId,
    required String classId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('space $spaceId class $classId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(getStudentQuery),
        variables: {
          "spaceId": spaceId,
          "classId": classId,
          "pagination": {"afterId": "", "limit": 100},
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getStudent(
              context: context,
              spaceId: spaceId,
              classId: classId,
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

      final classDataJson = result.data?['getClass'] as Map<String, dynamic>?;
      if (classDataJson == null) {
        return Result(
          response: ResponseError(message: "No Class Data"),
        );
      }

      final classData = ClassData.fromJson(classDataJson);
      final List<Student> myExams = classData.students ?? [];

      log('students $myExams');
      return Result(
        response: ResponseSuccess<List<Student>>(
          data: myExams,
          message: "getClass",
        ),
      );
    } catch (e) {
      log('errostd $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> enterStudentScore(
      {required BuildContext context,
      required String spaceId,
      required ManySubjectReportInput input}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${input.toJson()}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(enterScoreMutation),
        variables: {
          "spaceId": spaceId,
          "input": input.toJson(),
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
            return await enterStudentScore(
                context: context, input: input, spaceId: spaceId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['updateManySubjectReport'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "updateManySubjectReport",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> publishStudentResult({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String classId,
    required List<String> assessmentId,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space {}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(publishResultQuery),
        variables: {
          "input": {
            "assessmentIds": assessmentId,
            "classId": classId,
            "sessionId": sessionId,
            "termId": termId,
          },
          "spaceId": spaceId,
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
            return await publishStudentResult(
                context: context,
                sessionId: sessionId,
                termId: termId,
                classId: classId,
                assessmentId: assessmentId,
                spaceId: spaceId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final publishClassResult = result.data?['publishResults'] as bool?;
      if (publishClassResult == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: publishClassResult,
          message: " publishResults",
        ),
      );
    } catch (e) {
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
  Future<Result> getSpaceReport(
      {required BuildContext context, required String alias}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token alias $alias');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getSpaceQuery),
          variables: {
            "alias": alias,
            "isAdmin": false,
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      log('result:sssfgedhfhhdjd $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final Map<String, dynamic> data = result.data!['getSpace'];
      final Space lessonNote = Space.fromJson(data);

      return Result(
          response: ResponseSuccess<Space>(
        data: lessonNote,
        message: "getSpace",
      ));
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result> setResumptionDate(
      {required BuildContext context,
      required DateTime currentTermClosesOn,
      required DateTime nextTermBeginsOn,
      DateTime? boardingResumesOn,
      required int daysOpen,
      required String spaceId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space $currentTermClosesOn');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(setResumptionDateMutation),
        variables: {
          "input": {
            "boardingResumesOn": boardingResumesOn?.toIso8601String(),
            "currentTermClosesOn": currentTermClosesOn?.toIso8601String(),
            "daysOpen": daysOpen,
            "nextTermBeginsOn": nextTermBeginsOn.toIso8601String()
          },
          "spaceId": spaceId
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
            return await setResumptionDate(
              context: context,
              spaceId: spaceId,
              currentTermClosesOn: currentTermClosesOn,
              nextTermBeginsOn: nextTermBeginsOn,
              daysOpen: daysOpen,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['updateSpaceTermDate'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "updateSpaceTermDate",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getClassBroadsheet({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String classId,
    required String assessmentId,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${sessionId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(getClassBroadSheetQuery),
        variables: {
          "spaceId": spaceId,
          "input": {
            "sessionId": sessionId,
            "termId": termId,
            "classId": classId,
            "assessmentId": assessmentId,
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
            return await getClassBroadsheet(
              context: context,
              sessionId: sessionId,
              termId: termId,
              classId: classId,
              assessmentId: assessmentId,
              spaceId: spaceId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      // final userLessonCreate =
      //     result.data?['getClassBroadsheet'] as GetClassBroadsheet?;
      // if (userLessonCreate == null) {
      //   return Result(
      //     response:
      //         ResponseError(message: "getUserSpaces key is null or missing"),
      //   );
      // }

      return Result(
        response: ResponseSuccess<GetClassBroadsheet>.fromJson(result.data!,
            (data) => GetClassBroadsheet.fromJson(data), "getClassBroadsheet"),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> updateAttendanceMatatdata({
    required BuildContext context,
    required String spaceId,
    required List<Map<String, dynamic>> input,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${input}}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(updateAttendanceMatatdataMutatation),
        variables: {
          "input": input,
          "spaceId": spaceId,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await updateAttendanceMatatdata(
              context: context,
              spaceId: spaceId,
              input: input,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['updateResultsMetadata'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "updateResultsMetadata",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> daysSchoolOpen({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${termId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(getNumberOfDaysOpen),
        variables: {
          "spaceId": spaceId,
          "sessionId": sessionId,
          "termId": termId
        },
        // variables: input.toJson(),
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('daysSchoolOpen ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await daysSchoolOpen(
              context: context,
              sessionId: sessionId,
              termId: termId,
              spaceId: spaceId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      return Result(
        response: ResponseSuccess<GetSpaceTermDate>.fromJson(result.data!,
            (data) => GetSpaceTermDate.fromJson(data), "getSpaceTermDate"),
      );
    } catch (e) {
      log('dgdgdee $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getStudentResult({
    required BuildContext context,
    required String sessionId,
    required String termId,
    required String userId,
    required String classId,
    required String assessmentId,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('notedId $termId space $spaceId token $token');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token tojson ${termId}');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getResultQuery),
          variables: {
            "input": {
              "sessionId": sessionId,
              "termId": termId,
              // "classId": classId,
              "userId": userId,
              "assessmentId": assessmentId,
              "spaceId": spaceId
            }
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      log('plan $result');

      if (result.hasException) {
        // Check for subscription-related errors
        if (result.exception?.graphqlErrors != null &&
            result.exception!.graphqlErrors.isNotEmpty) {
          for (var error in result.exception!.graphqlErrors) {
            // Check if error is related to subscription
            if (error.message.contains("subscription") ||
                error.extensions != null &&
                    error.extensions!['code'] == 'INTERNAL_SERVER_ERROR' &&
                    error.message.contains("requires an active subscription")) {
              // Handle subscription error specifically
              return Result(
                response: ResponseError(
                  message: "This feature requires an active subscription plan",
                  // type: ErrorType.SUBSCRIPTION_REQUIRED,
                ),
              );
            }
          }
        }

        // For other types of errors
        throw Exception(result.exception.toString());
      }

      final Map<String, dynamic> data = result.data!['getResult'];
      final ResultData lessonNote = ResultData.fromJson(data);

      return Result(
        response: ResponseSuccess<ResultData>(
          data: lessonNote,
          message: "getResult",
        ),
      );
    } catch (e) {
      log('errors from $e');

      // Check if the error is a subscription issue
      if (e.toString().contains("subscription") ||
          e.toString().contains("requires an active subscription")) {
        return Result(
          response: ResponseError(
            message: "This feature requires an active subscription plan",
            // type: ErrorType.SUBSCRIPTION_REQUIRED,
          ),
        );
      }

      // General error handling
      return Result(
        response: ResponseError(
          message: "Failed to fetch result: ${e.toString()}",
          // type: ErrorType.GENERAL,
        ),
      );
    }
  }
  // @override
  // Future<Result> getStudentResult({
  //   required BuildContext context,
  //   required String sessionId,
  //   required String termId,
  //   required String userId,
  //   required String classId,
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
  //             // "classId": classId,
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

  @override
  Future<Result> getForm({
    required BuildContext context,
    required String classId,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${classId} classid $classId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(classFormQuery),
        variables: {"classId": classId, "spaceId": spaceId},
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules group tttt${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getForm(
              context: context,
              classId: classId,
              spaceId: spaceId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      return Result(
        response: ResponseSuccess<ClassModelForm>.fromJson(
            result.data!, (data) => ClassModelForm.fromJson(data), "getClass"),
      );
    } catch (e) {
      log('form error: $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> addTeacherComment({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String comment,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${comment}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(addFormTeacherMutation),
        variables: {
          "spaceId": spaceId,
          "resultId": resultId,
          "comment": comment
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
            return await addPrincipalComment(
                context: context,
                spaceId: spaceId,
                resultId: resultId,
                comment: comment);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate =
          result.data?['addResultFormTeacherComment'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "updateManySubjectReport",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> addPrincipalComment({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String comment,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${comment}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(addPrincipalMutation),
        variables: {
          "spaceId": spaceId,
          "resultId": resultId,
          "comment": comment
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
            return await addPrincipalComment(
                context: context,
                spaceId: spaceId,
                resultId: resultId,
                comment: comment);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate =
          result.data?['addResultPrincipalComment'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "addResultPrincipalComment",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> addCongnitive({
    required BuildContext context,
    required String spaceId,
    required String resultId,
    required String name,
    required int rating,
    required String cognitiveKeyId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('cognitive $name ${cognitiveKeyId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(updateCognitiveDomainMutation),
        variables: {
          // "input": {
          //   "cognitiveKeyId": cognitiveKeyId,
          //   "name": name,
          //   "spaceId": spaceId
          // }
          "input": {
            "resultId": resultId,
            "spaceId": spaceId,
            "ratings": [
              {
                "cognitiveKeyId": cognitiveKeyId,
                "rating": rating,
              }
            ]
          }
        },
        // variables: input.toJson(),
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('cognitiveGroup ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        debugPrint("cognitiveError2:  ${result.exception.toString()}");

        debugPrint("cognitiveError2:  ${result.exception?.graphqlErrors}");
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await addCongnitive(
                context: context,
                spaceId: spaceId,
                resultId: resultId,
                name: name,
                rating: rating,
                cognitiveKeyId: cognitiveKeyId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['rateCognitiveKeys'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "rateCognitiveKeys",
        ),
      );
    } catch (e) {
      debugPrint("cognitiveError2:  ${e.toString()}");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getSchoolAssessment({
    required BuildContext context,
    required String spaceId,
    required String assessmentId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${assessmentId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(basicAssesmentQuery),
        variables: {
          "spaceId": spaceId,
          "assessmentId": assessmentId,
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
            return await getSchoolAssessment(
              context: context,
              spaceId: spaceId,
              assessmentId: assessmentId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      return Result(
        response: ResponseSuccess<BasicAssessmentSecond>.fromJson(result.data!,
            (data) => BasicAssessmentSecond.fromJson(data), "getAssessment"),
      );
    } catch (e) {
      log('school error: $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getSchoolGrading({
    required BuildContext context,
    required String spaceId,
    required String assessmentId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' gradee ${assessmentId}   space $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(gradingSystemQuery),
        variables: {
          "spaceId": spaceId,
          "assessmentId": assessmentId,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schoolgtfdreddd ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retrygggfffgf?");
          if (shouldRetry) {
            return await getSchoolGrading(
              context: context,
              spaceId: spaceId,
              assessmentId: assessmentId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final List<dynamic> data = result.data!['getGradingSystems'];
      final grade = data.map((json) => GradingSystem.fromJson(json)).toList();
      return Result(
        response: ResponseSuccess<List<GradingSystem>>(
          data: grade,
          message: "getGradingSystems",
        ),
      );
    } catch (e) {
      log('rhhdhsjsj ${e}');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getSchoolCognitive({
    required BuildContext context,
    required String spaceId,
    required String classId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' gradee ${classId}   space $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(getCongitiveQuery),
        variables: {
          "spaceId": spaceId,
          "classId": classId,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('school ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getSchoolCognitive(
              context: context,
              spaceId: spaceId,
              classId: classId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final List<dynamic> data = result.data!['getClassCognitiveKeys'];
      final grade = data
          .map((json) => CognitiveKeyRating(
                cognitiveKey:
                    CognitiveKey.fromJson(json), // Fix: Parse as CognitiveKey
                rating: 0, // No rating in this query
              ))
          .toList();
      return Result(
        response: ResponseSuccess<List<CognitiveKeyRating>>(
          data: grade,
          message: "getClassCognitiveKeys",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }
}
