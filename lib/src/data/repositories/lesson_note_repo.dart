import 'dart:convert';
import 'dart:developer';

import 'package:cloudnottapp2/src/api_strings/api_quries/lesson_quries.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/class_group.dart';

import 'package:cloudnottapp2/src/data/models/lesson_note_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class LessonNotesRepository {
  Future<Result<dynamic>> getLessonNotes({
    required String spaceId,
    required GetLessonNotesInput input,
  });
  Future<List<LessonNoteModel>> getTecherLessonNotes({
    required String spaceId,
    required GetLessonNotesInput input,
  });
  Future<Result<dynamic>> getClassGroup({
    required BuildContext context,
    required String spaceId,
  });
  Future<Result<dynamic>> createLessonNote(
      {required BuildContext context, required CreateLessonNoteRequest input});
  Future<Result<dynamic>> updateLessonNote(
      {required BuildContext context,
      required String spaceId,
      required LessonNoteData input});
  Future<Result<dynamic>> getLessonNote(
      {required BuildContext context,
      required String lessonNoteId,
      required String spaceId});

  Future<Result<dynamic>> createClassNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String noteId,
      required String content});
  Future<Result<dynamic>> updateClassNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String noteId,
      required String contentId,
      required String content});
  Future<Result<dynamic>> createLessonPlanNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String lessonNoteId,
      required String lessonNotePlan});
  Future<Result<dynamic>> updateLessonPlanNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String lessonNoteId,
      required String id,
      required String lessonNotePlan});
  Future<Result<dynamic>> getLessonPlan({
    required BuildContext context,
    required String spaceId,
    required String lessonNoteId,
  });
}

class LessonNotesRepositoryImpl implements LessonNotesRepository {
  static GraphQLConfig graphqlConfig = GraphQLConfig();

  @override
  Future<Result<dynamic>> getLessonNotes({
    required String spaceId,
    required GetLessonNotesInput input,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('token $token tojson $spaceId ${input.toJson()}');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(teacherLessonQuery),
          variables: {
            // "input": {
            //   "classGroupId": "e595264a-a97b-483b-8a90-f47e17c6668c",
            //   "subjectId": "65304de3-fa42-4afe-a466-6253738ddb61",
            //   "termId": "a7111948-7ea9-4975-a3e7-61fa11f11b28"
            // },
            "input": input.toJson(),
            "spaceId": spaceId
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      print('result:sss $result');
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final List<dynamic> data = result.data!['getLessonNotes'];
      final notes = data.map((json) => LessonNoteModel.fromJson(json)).toList();
      return Result(
        response: ResponseSuccess<List<LessonNoteModel>>(
          data: notes,
          message: "getLessonNotes",
        ),
      );
    } catch (e) {
      log('errors from $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<List<LessonNoteModel>> getTecherLessonNotes(
      {required String spaceId, required GetLessonNotesInput input}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token tojson $spaceId ${input.toJson()}');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(teacherLessonQuery),
          variables: {"input": input.toJson(), "spaceId": spaceId},
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      print('result:sss $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      final List<dynamic> data = result.data!['getLessonNotes'];
      return data.map((json) => LessonNoteModel.fromJson(json)).toList();
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result> getClassGroup(
      {required BuildContext context, required String spaceId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('Token: $token'); // Log token for validation
      if (token.isEmpty) {
        log('Warning: Empty token detected, authentication may fail');
      }
      log('Space ID: $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('Client endpoint: ${client.link.toString()}'); // Log endpoint
      QueryResult result = await client.query(QueryOptions(
        document: gql(getClassGroupQueries),
        variables: {
          "spaceId": spaceId,
          "includeSubjectDetails": true,
          "includeFormTeacher": false,
          "includeClassFields": true,
          "includeClasses": true,
          "includeTeacherFields": true,
        },
        fetchPolicy: FetchPolicy.noCache,
      ));
      log('Complete response:dddd ${result.toString()}');
      log('Response headers: ${result.context.entry<HttpLinkResponseContext>()?.headers}');
      log('Query string: ${getClassGroupQueries}');
      log('Raw data: ${result.data} ${result.exception} token: $token');
      log('Raw API response: ${jsonEncode(result.data)}');
      log("GraphQL Errors: ${result.exception?.graphqlErrors}");
      log("Link Exception: ${result.exception?.linkException}");
      log("Has exception: ${result.hasException}");
      final raw = result.data?['getClassGroups']; // Updated key
      log("Raw GetClassGroups: ${jsonEncode(raw)}");

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getClassGroup(context: context, spaceId: spaceId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userHomeworkData = result.data?['getClassGroups'] as List<dynamic>?;
      if (userHomeworkData == null) {
        return Result(
          response:
              ResponseError(message: "GetClassGroups key is null or missing"),
        );
      }
      final List<ClassGroup> myExams = userHomeworkData
          .map((item) => ClassGroup.fromJson(item as Map<String, dynamic>))
          .toList();
      log('Schedules: ${myExams}');
      log('Parsed groups: ${jsonEncode(myExams)}');
      return Result(
        response: ResponseSuccess<List<ClassGroup>>(
          data: myExams,
          message: "getClassGroups",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }
//   @override
//   Future<Result> getClassGroup(
//       {required BuildContext context, required String spaceId}) async {
//     try {
//       final token = localStore.get('token', defaultValue: '');
//       log(' space $spaceId');
//       GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
//       QueryResult result = await client.query(QueryOptions(
//         document: gql(getClassGroupQueries),
//         variables: {
//           // "spaceId": spaceId,
//           // "includeSubjectDetails": true,
//           // "includeFormTeacher": false,
//           // "includeClassFields": true,
//           // "includeClasses": true,
//           // "includeTeacherFields": true

//   "spaceId": spaceId,
//   "includeSubjectDetails": true,
//   "includeFormTeacher": false,
//   "includeClassFields": true,
//   "includeClasses": true,
//   "includeTeacherFields": true

//         },
//         fetchPolicy: FetchPolicy.networkOnly,
//       ));
//       log('Complete response: ${result.toString()}');
// log('Response headers: ${result.context.entry<HttpLinkResponseContext>()?.headers}');
// log('Query string: ${getClassGroupQueries}');
//       log('raw data ${result.data} ${result.exception} token $token');
//       log('Raw API response: ${jsonEncode(result.data)}');
//       log("GraphQL Errors: ${result.exception?.graphqlErrors}");
// log("Link Exception: ${result.exception?.linkException}");
// log("Has exception: ${result.hasException}");
// final raw = result.data?['getClassGroups'];
// log("Raw getClassGroups: ${jsonEncode(raw)}");

//       if (result.hasException) {
//         if (result.exception?.linkException != null) {
//           bool shouldRetry =
//               await showRetryDialog(context, "Network error. Retry?");
//           if (shouldRetry) {
//             return await getClassGroup(
//               context: context,
//               spaceId: spaceId,
//             );
//           }
//         }
//         return Result(
//             response: ResponseError(
//           message: result.exception.toString(),
//           errors: result.exception?.graphqlErrors,
//         ));
//       }

//       final userHomeworkData = result.data?['getClassGroups'] as List<dynamic>?;
//       if (userHomeworkData == null) {
//         return Result(
//           response:
//               ResponseError(message: "getUserSpaces key is null or missing"),
//         );
//       }
//       final List<ClassGroup> myExams = userHomeworkData
//           .map((item) => ClassGroup.fromJson(item as Map<String, dynamic>))
//           .toList();
//       log('schedules ${myExams}');
//         log('Parsed groups: ${jsonEncode(myExams)}');
//       return Result(
//         response: ResponseSuccess<List<ClassGroup>>(
//           data: myExams,
//           message: "getClassGroups",
//         ),
//       );
//     } catch (e) {
//       return Result(response: ResponseError(message: e.toString()));
//     }
//   }

  @override
  Future<Result> createLessonNote(
      {required BuildContext context,
      required CreateLessonNoteRequest input}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${input.toJson()}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(createLessonNoteMutation),
        variables: {
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
            return await createLessonNote(context: context, input: input);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['createLessonNote'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "createLessonNote",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> updateLessonNote(
      {required BuildContext context,
      required String spaceId,
      required LessonNoteData input}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${input.toJson()}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(updateLessonNoteMainMutation),
        variables: {
          "input": input.toMap(),
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
            return await updateLessonNote(
                context: context, input: input, spaceId: spaceId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['updateLessonNote'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "updateLessonNote",
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
  Future<Result> getLessonNote(
      {required BuildContext context,
      required String lessonNoteId,
      required String spaceId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token tojson $spaceId ${lessonNoteId}');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getLessonQuery),
          variables: {
            // "input": {
            //   "classGroupId": "e595264a-a97b-483b-8a90-f47e17c6668c",
            //   "subjectId": "65304de3-fa42-4afe-a466-6253738ddb61",
            //   "termId": "a7111948-7ea9-4975-a3e7-61fa11f11b28"
            // },
            "lessonNoteId": lessonNoteId, "spaceId": spaceId
          },
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      print('result:sss $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final Map<String, dynamic> data = result.data!['getLessonNote'];
      final LessonNoteModel lessonNote = LessonNoteModel.fromJson(data);

      return Result(
          response: ResponseSuccess<LessonNoteModel>(
        data: lessonNote,
        message: "getLessonNote",
      ));
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<Result> createClassNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String noteId,
      required String content}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${noteId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(createClassNoteMutation),
        variables: {
          "input": {
            "noteId": noteId,
            "content": content,
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
            return await createClassNoteContent(
              context: context,
              spaceId: spaceId,
              noteId: noteId,
              content: content,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['createClassNote'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "createClassNote",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> updateClassNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String noteId,
      required String contentId,
      required String content}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${noteId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(updateClassNoteMutation),
        variables: {
          "input": {
            "content": content,
            "contentId": contentId,
            "noteId": noteId
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
            return await updateClassNoteContent(
              context: context,
              spaceId: spaceId,
              contentId: contentId,
              noteId: noteId,
              content: content,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['updateClassNoteMutation'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "updateClassNote",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> createLessonPlanNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String lessonNoteId,
      required String lessonNotePlan}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log(' space ${lessonNoteId}');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(createLessonPlanMutation),
        variables: {
          "input": {
            "lessonNoteId": lessonNoteId,
            "lessonNotePlan": lessonNotePlan
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
            return await createLessonPlanNoteContent(
                context: context,
                spaceId: spaceId,
                lessonNoteId: lessonNoteId,
                lessonNotePlan: lessonNotePlan);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate =
          result.data?['createLessonPlanNoteContent'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "createLessonPlanNoteContent",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> updateLessonPlanNoteContent(
      {required BuildContext context,
      required String spaceId,
      required String id,
      required String lessonNoteId,
      required String lessonNotePlan}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('updatelessonplan ${lessonNoteId} $id $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(updateLessonPlanMutation),
        variables: {
          "input": {
            "id": id,
            "lessonNoteId": lessonNoteId,
            "lessonNotePlan": lessonNotePlan
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
            return await createLessonPlanNoteContent(
                context: context,
                spaceId: spaceId,
                lessonNoteId: lessonNoteId,
                lessonNotePlan: lessonNotePlan);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['updateLessonNotePlan'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "updateLessonNotePlan",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getLessonPlan(
      {required BuildContext context,
      required String spaceId,
      required String lessonNoteId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('notedId $lessonNoteId space $spaceId token $token');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);

      log('token $token tojson  ${lessonNoteId}');
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(getLessonNotePlanQuery),
          variables: {"lessonNoteId": lessonNoteId, "spaceId": spaceId},
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      print('plan $result');
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final Map<String, dynamic> data =
          result.data!['getLessonNote']?['lessonNotePlan'];
      final LessonNotePlan lessonNote = LessonNotePlan.fromJson(data);

      return Result(
          response: ResponseSuccess<LessonNotePlan>(
        data: lessonNote,
        message: "getLessonNotePlan",
      ));
    } catch (e) {
      log('errors from $e');
      throw Exception(e.toString());
    }
  }
}
