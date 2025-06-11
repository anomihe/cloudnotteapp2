import 'dart:developer';

import 'package:cloudnottapp2/src/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../api_strings/api_quries/exams_homework_quires.dart';
import '../../config/config.dart';
import '../models/exam_session_model.dart';
import '../models/homework_model.dart';
import '../models/response_model.dart';
import '../models/teacher_homework_model.dart' show ExamTeacherGroup;

abstract class ExamOrHomeWorkRepo {
  Future<Result<dynamic>> getExams(
      {required BuildContext context,
      required String spaceId,
      required int pageSize,
      required bool offline});
  Future<Result<dynamic>> getExam(
      {required BuildContext context,
      required String spaceId,
      required String id});
  Future<Result<dynamic>> userPersonnelExam({
    required BuildContext context,
    required String examGroupId,
    required String examId,
    required String pin,
    required String spaceId,
    required String studentId,
    required String examSessionId,
  });
  Future<Result<dynamic>> userUpdateExamSession(
      {required BuildContext context, required ExamSessionInput data});
  // Future<Result<dynamic>> writtenExamSession(
  //     {required BuildContext context, required GetExamSessionsInput data});
  Future<Result<dynamic>> writtenExamSession(
      {required BuildContext context,
      required String spaceId,
      required String examGroupId,
      required List<String> examId,
      required String? classId,
      required int pageSize});
  Future<Result<dynamic>> getHomeworks({
    required BuildContext context,
    required String classGroupId,
    required String examGroupId,
    required String spaceId,
    required int pageSize,
    // required String termId,
  });
  Future<Result<dynamic>> getSubmission({
    required BuildContext context,
    required String classGroupId,
    required String examGroupId,
    required String spaceId,
    required int pageSize,
    // required String termId,
  });
  Future<Result<dynamic>> filter({
    required BuildContext context,
    required String classGroupId,
    required String examGroupId,
    required String spaceId,
    required int pageSize,
    // required String termId,
  });
  Future<Result<dynamic>> getExamGroup({
    required BuildContext context,
    required String classGroupId,
    required String sessionId,
    required String spaceId,
    required int pageSize,
    required String termId,
  });

  Future<Result<dynamic>> getTeacherExamGroup({
    required BuildContext context,
    required String sessionId,
    required String spaceId,
    required String termid,
    required List<String> classGroupId,
  });
  Future<Result<dynamic>> deleteExams({
    required BuildContext context,
    required String examGroupId,
    required String id,
    required String spaceId,
    required String studentId,
    required String examId,
  });
  Future<Result<dynamic>> correctExams({
    required BuildContext context,
    required String examGroupId,
    required String id,
    required String spaceId,
    required String studentId,
    required String examId,
  });
  Future<Result<dynamic>> markExams({
    required BuildContext context,
    required String examGroupId,
    required String id,
    required String spaceId,
    required String questionId,
    required String examId,
    required String studentId,
    required int score,
  });
  Future<Result<dynamic>> examBreakDown(
      {required BuildContext context,
      required String examId,
      required String examGroupId,
      required String studentId,
      required String spaceId,
      required String id});
        Future<Result<dynamic>> spaceExamBreakDown(
      {required BuildContext context,
      required String examId,
      required String examGroupId,
   
      required String spaceId,
      });
      Future<Result<dynamic>>  resetExamSession(
      {required BuildContext context, required ExamSessionInput data});
}

class ExamOrHomeWorkRepoImpl implements ExamOrHomeWorkRepo {
  static GraphQLConfig graphqlConfig = GraphQLConfig();
  @override
  Future<Result> getExams(
      {required BuildContext context,
      required String spaceId,
      required int pageSize,
      required bool offline}) async {
    final token = localStore.get('token', defaultValue: '');
    log('token: $token spaceId: $spaceId');
    GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
    QueryResult result = await client.query(QueryOptions(
        document: gql(examHomeWork),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          "input": {
            "spaceId": spaceId,
            "pageSize": pageSize,
            "isOffline": offline,
            // "cursor": null,
            // "classGroupId": null
          },
        }));
    if (result.hasException) {
      log("GraphQL Exception: ${result.exception}");

      // Check for actual network connectivity problems
      if (result.exception?.linkException != null) {
        final linkException = result.exception!.linkException;

        // Only show retry dialog for actual network failures
        // Check for specific types of network errors
        if (linkException is NetworkException ||
            linkException.toString().contains('SocketException') ||
            linkException.toString().contains('Connection refused')) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getExams(
                context: context,
                spaceId: spaceId,
                pageSize: pageSize,
                offline: offline);
          }
        }
      }

      // Handle GraphQL errors
      if (result.exception?.graphqlErrors.isNotEmpty == true) {
        String firstErrorMessage =
            result.exception?.graphqlErrors.first.message ?? '';

        if (firstErrorMessage == 'User not found') {
          await showLogOutDialog(context, firstErrorMessage);
          return Result(
            response: ResponseError(
              message: firstErrorMessage,
              errors: result.exception?.graphqlErrors,
            ),
          );
        }
      }

      // Return general error if not handled above
      return Result(
          response: ResponseError(
        message: result.exception.toString(),
        errors: result.exception?.graphqlErrors,
      ));
    }

    final userExamsData =
        result.data?['getStudentActiveExams']['data'] as List<dynamic>?;

    if (userExamsData == null) {
      return Result(
        response:
            ResponseError(message: "getUserSpaces key is null or missing"),
      );
    }
    final List<ExamData> userExams = userExamsData
        .map((item) => ExamData.fromJson(item as Map<String, dynamic>))
        .toList();
    log('fectched data $userExams');
    return Result(
        response:
            ResponseSuccess<List<ExamData>>(data: userExams, message: "data"));
  }

  @override
  Future<Result> getExam(
      {required context, required String spaceId, required String id}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('gata $id $spaceId');
      QueryResult result = await client.query(QueryOptions(
        document: gql(singleExamWork),
        variables: {
          "input": {
            "id": id,
            "spaceId": spaceId,
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      if (result.hasException) {
        log('message ${result.exception?.graphqlErrors.first.message}');
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getExam(context: context, id: id, spaceId: spaceId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      log('examnn ${result.data}');
      return Result(
        response: ResponseSuccess<ExamData>.fromJson(
          result.data!,
          (data) => ExamData.fromJson(data),
          "getStudentActiveExam",
        ),
      );
    } catch (e) {
      print('this is an $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> userPersonnelExam(
      {required BuildContext context,
      required String examGroupId,
      required String examId,
      required String pin,
      required String spaceId,
      required String studentId,
      required String examSessionId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(examSession),
        variables: {
          "input": {
            "studentId": studentId,
            "examId": examId,
            "pin": pin,
            "spaceId": spaceId,
            "examGroupId": examGroupId
            // "classGroupId": classGroupId,
            // "examId": examId,
            // "pin": pin,
            // "spaceId": spaceId,
            // "studentId": studentId,
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('my results ${result.data}');
      if (result.hasException) {
        if (result.exception?.graphqlErrors.isNotEmpty == true &&
            result.exception!.graphqlErrors.first.message
                .contains('Student already has an exam session')) {
          userUpdateExamSession(
              context: context,
              data: ExamSessionInput(
                id: examSessionId,
                examId: examId,
                examGroupId: examGroupId,
                spaceId: spaceId,
                studentId: studentId,
                status: 'inProgress',
              ));
          return Result(
              response: ResponseError(
            message: result.exception.toString(),
            errors: result.exception?.graphqlErrors,
          ));
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      //log('timedd ${result.data}');
      return Result(
          response: ResponseSuccess<ExamSession>.fromJson(result.data!,
              (data) => ExamSession.fromJson(data), "createExamSession"));
    } catch (e) {
      log('timedderrs ${e}');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> userUpdateExamSession(
      {required BuildContext context, required ExamSessionInput data}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('my deta ${data.toJson()} removed ${data.toJson()
          // ..remove('status')
          // ..remove('score')
          // ..remove('isCorrect')
          }');
      log('message ${data.toJson()}');
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(updateSessionQuery),
        variables: {
          "input": data.toJson()
          // ..remove('score')
          // ..remove('isCorrect'),
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await userUpdateExamSession(context: context, data: data);
          }
        }
        log("my error ${result.exception?.graphqlErrors} ${result.exception.toString()}");
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      log("user space ${result.data}");

      return Result(
          response: ResponseSuccess<ExamSession>.fromJson(result.data!,
              (data) => ExamSession.fromJson(data), "updateExamSession"));
    } catch (e) {
      log('updateexamerr $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> writtenExamSession(
      {required BuildContext context,
      required String spaceId,
      required String examGroupId,
      required List<String> examId,
      required String? classId,
      required int pageSize}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('Fetching $spaceId $examGroupId $examId $classId');
      final input = {
        "examGroupId": examGroupId,
        "spaceId": spaceId,
        "examId": examId,
        "pageSize": pageSize,
        if (classId != null && classId.isNotEmpty) "classId": [classId],
      };
      QueryResult result = await client.query(QueryOptions(
        document: gql(getExamSessionsQuery),
        variables: {
          "input": input,
          // "input": {
          //   "examGroupId": examGroupId,
          //   "spaceId": spaceId,
          //   "examId": examId,
          //   "classId": [classId],
          //   "pageSize": pageSize
          // }
          // "input": data.toJson(),
          // "input": {
          //   "classId": [],
          //   // "cursor": cursor,
          //   "examGroupId": examGroupId,
          //   "examId": examId,
          //   "pageSize": pageSize,
          //   "spaceId": spaceId,
          // }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('scfff ${result}');
      if (result.hasException) {
        log('messagesss ${result.exception?.graphqlErrors.first.message}');
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await writtenExamSession(
                context: context,
                spaceId: spaceId,
                examGroupId: examGroupId,
                examId: examId,
                classId: classId,
                pageSize: pageSize);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final userTimeData =
          result.data?['getExamSessions']['data'] as List<dynamic>?;

      if (userTimeData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ExamSessionData> timetable = userTimeData
          .map((item) => ExamSessionData.fromJson(item as Map<String, dynamic>))
          .toList();
      log('schedules written ${timetable}');
      return Result(
        response: ResponseSuccess<List<ExamSessionData>>(
          data: timetable,
          message: "data",
          // message: "getExamSessions",
        ),
      );
    } catch (e) {
      print('this is an $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getHomeworks(
      {required BuildContext context,
      required String classGroupId,
      required String examGroupId,
      required String spaceId,
      required int pageSize}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(getExamsQuery),
        variables: {
          "input": {
            "classGroupId": classGroupId,
            "examGroupId": examGroupId,
            "pageSize": 100,
            "spaceId": spaceId,
            // "termId": termId
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getHomeworks(
                context: context,
                classGroupId: classGroupId,
                examGroupId: examGroupId,
                spaceId: spaceId,
                pageSize: pageSize);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userHomeworkData =
          result.data?['getExams']["data"] as List<dynamic>?;
      if (userHomeworkData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ExamDetailed> myExams = userHomeworkData
          .map((item) => ExamDetailed.fromMap(item as Map<String, dynamic>))
          .toList();
      log('schedules ${myExams}');
      return Result(
        response: ResponseSuccess<List<ExamDetailed>>(
          data: myExams,
          message: "data",
          // message: "getExams",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getExamGroup({
    required BuildContext context,
    required String classGroupId,
    required String sessionId,
    required String spaceId,
    required int pageSize,
    required String termId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(examGroupQuery),
        variables: {
          "input": {
            "classGroupId": classGroupId,
            "pageSize": pageSize,
            "sessionId": sessionId,
            "spaceId": spaceId,
            "termId": termId
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getExamGroup(
                context: context,
                classGroupId: classGroupId,
                sessionId: sessionId,
                spaceId: spaceId,
                termId: termId,
                pageSize: pageSize);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userHomeworkData =
          result.data?['getExamGroups']['data'] as List<dynamic>?;
      if (userHomeworkData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ExamGroupModel> myExams = userHomeworkData
          .map((item) => ExamGroupModel.fromJson(item as Map<String, dynamic>))
          .toList();
      log('schedules ${myExams}');
      return Result(
        response: ResponseSuccess<List<ExamGroupModel>>(
          data: myExams,
          message: "data",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getTeacherExamGroup(
      {required BuildContext context,
      required String sessionId,
      required String spaceId,
      required List<String> classGroupId,
      required String termid}) async {
    try {
      final token = localStore.get('token', defaultValue: '');

      log('my data sess $sessionId space $spaceId gropup $classGroupId term$termid ');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(examTeacherGroupQuery),
        variables: {
          "input": {
            "termId": termid,
            "spaceId": spaceId,
            "sessionId": sessionId,
            "pageSize": 100,
            "classGroupId": classGroupId,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('teacherExam ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getTeacherExamGroup(
              context: context,
              classGroupId: classGroupId,
              sessionId: sessionId,
              spaceId: spaceId,
              termid: termid,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userHomeworkData =
          result.data?['getExamGroups']['data'] as List<dynamic>?;
      if (userHomeworkData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ExamTeacherGroup> myExams = userHomeworkData
          .map(
              (item) => ExamTeacherGroup.fromJson(item as Map<String, dynamic>))
          .toList();
      // log('teacherexam ${myExams}');
      return Result(
        response: ResponseSuccess<List<ExamTeacherGroup>>(
          data: myExams,
          message: "data",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  // @override
  // Future<Result> getClassGroup() async{
  //   try{}catch(e){
  //       return Result(response: ResponseError(message: e.toString()));
  //   }
  // }
  @override
  Future<Result> filter(
      {required BuildContext context,
      required String classGroupId,
      required String examGroupId,
      required String spaceId,
      required int pageSize}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(filterExamQuery),
        variables: {
          "input": {
            "classGroupId": classGroupId,
            "examGroupId": examGroupId,
            "pageSize": 100,
            "spaceId": spaceId,
            // "termId": termId
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules written ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await filter(
                context: context,
                classGroupId: classGroupId,
                examGroupId: examGroupId,
                spaceId: spaceId,
                pageSize: pageSize);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userHomeworkData =
          result.data?['getExams']["data"] as List<dynamic>?;
      if (userHomeworkData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ExamSessionData> myExams = userHomeworkData
          .map((item) => ExamSessionData.fromJson(item as Map<String, dynamic>))
          .toList();
      log('scheduleseeee ${myExams}');
      return Result(
        response: ResponseSuccess<List<ExamSessionData>>(
          data: myExams,
          message: "data",
          // message: "getExams",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> deleteExams({
    required BuildContext context,
    required String examGroupId,
    required String id,
    required String spaceId,
    required String studentId,
    required String examId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('my deta {data.toJson()} removed {data.toJson()      }');
      log('message {data.toJson()}');
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(deleteExamMutation),
        variables: {
          "input": {
            "examGroupId": examGroupId,
            "examId": examId,
            "id": id,
            "spaceId": spaceId,
            "studentId": studentId
          }
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await deleteExams(
              context: context,
              examGroupId: examGroupId,
              id: id,
              spaceId: spaceId,
              studentId: studentId,
              examId: examId,
            );
          }
        }
        log("my error ${result.exception?.graphqlErrors} ${result.exception.toString()}");
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      log("userdeleted ${result.data}");
      final userHomeworkDelete =
          result.data?['deleteExamSession'] as List<dynamic>?;
      if (userHomeworkDelete == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<DeleteExamSessionData> myExams = userHomeworkDelete
          .map((item) =>
              DeleteExamSessionData.fromJson(item as Map<String, dynamic>))
          .toList();

      return Result(
          response: ResponseSuccess<List<DeleteExamSessionData>>(
        data: myExams,
        message: "deleteExamSession",
      ));
    } catch (e) {
      log('deleteexa $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> correctExams(
      {required BuildContext context,
      required String examGroupId,
      required String id,
      required String spaceId,
      required String studentId,
      required String examId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('dhfhfhd $examGroupId, $id, $spaceId $studentId, $examId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(studentCorrectionQuery),
        variables: {
          "input": {
            "examGroupId": examGroupId,
            "examId": examId,
            "id": id,
            "spaceId": spaceId,
            "studentId": studentId
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules written ${result.data}');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await correctExams(
              context: context,
              examGroupId: examGroupId,
              id: id,
              spaceId: spaceId,
              studentId: studentId,
              examId: examId,
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
        response: ResponseSuccess<StudentExamSessionData>.fromJson(
          result.data!,
          (data) => StudentExamSessionData.fromJson(data),
          "getStudentExamSession",
          // message: "getExams",
        ),
      );
      // return Result(
      //   response: ResponseSuccess<List<StudentExamSessionData>>(
      //     data: myExams,
      //     message: "getStudentExamSession",
      //     // message: "getExams",
      //   ),
      // );
    } catch (e) {
      log('tcorrectexamerr $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> markExams(
      {required BuildContext context,
      required String examGroupId,
      required String id,
      required String spaceId,
      required String questionId,
      required String examId,
      required String studentId,
      required int score}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(markeTheory),
        variables: {
          "input": {
            "examGroupId": examGroupId,
            "examId": examId,
            "id": id,
            "questionId": questionId,
            "score": score,
            "spaceId": spaceId,
            "studentId": studentId,
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('==wmarked ${result.data}');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await markExams(
              context: context,
              examGroupId: examGroupId,
              score: score,
              id: id,
              spaceId: spaceId,
              studentId: studentId,
              examId: examId,
              questionId: questionId,
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
        response: ResponseSuccess<ExamSession>.fromJson(
          result.data!,
          (data) => ExamSession.fromJson(data),
          "markTheoryExamSession",
          // message: "getExams",
        ),
      );
      // return Result(
      //   response: ResponseSuccess<List<StudentExamSessionData>>(
      //     data: myExams,
      //     message: "getStudentExamSession",
      //     // message: "getExams",
      //   ),
      // );
    } catch (e) {
      log('markexamerr $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getSubmission(
      {required BuildContext context,
      required String classGroupId,
      required String examGroupId,
      required String spaceId,
      required int pageSize}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(getSubmissionQuery),
        variables: {
          "input": {
            "classGroupId": classGroupId,
            "examGroupId": examGroupId,
            "pageSize": 100,
            "spaceId": spaceId,
            // "termId": termId
          },
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('schedules ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getHomeworks(
                context: context,
                classGroupId: classGroupId,
                examGroupId: examGroupId,
                spaceId: spaceId,
                pageSize: pageSize);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userHomeworkData =
          result.data?['getExams']["data"] as List<dynamic>?;
      if (userHomeworkData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ExamDataSubmission> myExams = userHomeworkData
          .map((item) =>
              ExamDataSubmission.fromJson(item as Map<String, dynamic>))
          .toList();
      log('schedules ${myExams}');
      return Result(
        response: ResponseSuccess<List<ExamDataSubmission>>(
          data: myExams,
          message: "data",
          // message: "getExams",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> examBreakDown({
    required BuildContext context,
    required String examId,
    required String examGroupId,
    required String studentId,
    required String spaceId,
    required String id,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      QueryResult result = await client.query(
        QueryOptions(
          document: gql(breakDownQuery),
          variables: {
            "input": {
              "examGroupId": examGroupId,
              "examId": examId,
              "id": id,
              "spaceId": spaceId,
              "studentId": studentId,
            }
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      log('bebebebebeb ${result.data} ${result.exception} token $token');

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await examBreakDown(
              context: context,
              id: id,
              examId: examId,
              examGroupId: examGroupId,
              spaceId: spaceId,
              studentId: studentId,
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

      final sessionData = result.data?['getStudentExamSession'];
      if (sessionData == null) {
        return Result(
          response: ResponseError(
              message: "getStudentExamSession key is null or missing"),
        );
      }

      final session =
          GetStudentExamSession.fromJson(sessionData as Map<String, dynamic>);

      return Result(
        response: ResponseSuccess<GetStudentExamSession>(
          data: session,
          message: "GetStudentExamSession fetched successfully",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> spaceExamBreakDown(
      {required BuildContext context,
      required String examId,
      required String examGroupId,
   
      required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      QueryResult result = await client.query(
        QueryOptions(
          document: gql(examSessionSummaryBreakdownQuery),
          variables: {
            "input": {
              "examGroupId": examGroupId,
              "examId": examId,
           
              "spaceId": spaceId,
           
            }
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );

      log('bebebebebeb ${result.data} ${result.exception} token $token');

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await spaceExamBreakDown(
              context: context,
              examId: examId,
              examGroupId: examGroupId,
              spaceId: spaceId,
            
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

      final sessionData = result.data?['getExamSessionsSummary'];
      if (sessionData == null) {
        return Result(
          response: ResponseError(
              message: "getStudentExamSession key is null or missing"),
        );
      }

      final session =
          GetExamSessionsSummaryResponse.fromJson(sessionData as Map<String, dynamic>);

      return Result(
        response: ResponseSuccess<GetExamSessionsSummaryResponse>(
          data: session,
          message: "GetStudentExamSession fetched successfully",
        ),
      );
    } catch (e) {
      log('hyhyhyhy $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> resetExamSession(
      {required BuildContext context, required ExamSessionInput data}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('my deta ${data.toJson()} removed ${data.toJson()
          // ..remove('status')
          // ..remove('score')
          // ..remove('isCorrect')
          }');
      log('message ${data.toJson()}');
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(resetExamMutation),
        variables: {
          "input": data.toJson()..remove('answer')
          // ..remove('score')
          // ..remove('isCorrect'),
        },
        fetchPolicy: FetchPolicy.noCache,
      ));

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await userUpdateExamSession(context: context, data: data);
          }
        }
        log("my error ${result.exception?.graphqlErrors} ${result.exception.toString()}");
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      log("user space ${result.data}");
  return Result(
    response: ResponseSuccess<ExamSession>.fromJson(result.data!,
        (data) => ExamSession.fromJson(data), "resetExamSession")); // ✅ Correct key
      // return Result(
      //     response: ResponseSuccess<ExamSession>.fromJson(result.data!,
      //         (data) => ExamSession.fromJson(data), "resetSession"));
    } catch (e) {
      log('updateexamerr $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

}
