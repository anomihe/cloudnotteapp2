import 'dart:developer';
import 'package:cloudnottapp2/src/api_strings/api_quries/graphql_queries.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/free_ai_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

abstract class FreeAiRepo {
  Future<Result<dynamic>> submitUrl({
    required BuildContext context,
    required String url,
    required String fileType,
    required String name,
  });
  Future<Result<dynamic>> submitText({
    required BuildContext context,
    required String text,
    required String name,
  });
  Future<Result<dynamic>> deleteSession({
    required BuildContext context,
    required String sessionId,
    required String username,
  });
  Future<Result<dynamic>> getSession({
    required BuildContext context,
    required String sessionId,
  });
  Future<Result<dynamic>> chat({
    required BuildContext context,
    required String sessionId,
    required String question,
  });
  Future<Result<dynamic>> getSessions({required BuildContext context});
  Future<Result<dynamic>> getExploreTopics({required BuildContext context});
  Future<Result<dynamic>> addNoteToSession({
    required BuildContext context,
    required String sessionId,
    required String note,
  });
  Future<Result<dynamic>> regenerateChapters({
    required BuildContext context,
    required String sessionId,
  });
  Future<Result<dynamic>> regenerateSummary({
    required BuildContext context,
    required String sessionId,
  });
  Future<Result<dynamic>> regenerateQuestions({
    required BuildContext context,
    required String sessionId,
  });
  Future<Result<dynamic>> regenerateQuiz({
    required BuildContext context,
    required String sessionId,
  });
}

class FreeAiRepoImpl implements FreeAiRepo {
  static GraphQLConfig2 graphqlConfig = GraphQLConfig2();

  @override
  Future<Result<dynamic>> submitUrl({
    required BuildContext context,
    required String url,
    required String fileType,
    required String name,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final username = userProvider.user?.username;
      if (username == null) {
        return Result(response: ResponseError(message: "User not logged in"));
      }
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.submitURL),
          variables: {
            "input": {"url": url, "username": username, "fileType": fileType}
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        log("Submit URL error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final sessionData = result.data?['submitURL'] as Map<String, dynamic>?;
      log("Submit URL response: $sessionData");
      if (sessionData == null) {
        return Result(
            response:
                ResponseError(message: "submitURL data is null or missing"));
      }

      final sessionId = sessionData['id'] as String?;
      if (sessionId == null) {
        return Result(response: ResponseError(message: "Session ID is null"));
      }

      final sessionResult =
          await getSession(context: context, sessionId: sessionId);
      if (sessionResult.response is ResponseError) {
        return sessionResult;
      }

      final freeAiModel =
          (sessionResult.response as ResponseSuccess<FreeAiModel>).data!;
      final updatedModel = freeAiModel.copyWith(
        name: name,
        title: name,
        fileType: fileType,
        url: url,
      );

      return Result(
          response: ResponseSuccess<FreeAiModel>(
              data: updatedModel, message: "URL submitted successfully"));
    } catch (e) {
      log("Submit URL exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> submitText({
    required BuildContext context,
    required String text,
    required String name,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final username = userProvider.user?.username;
      if (username == null) {
        return Result(response: ResponseError(message: "User not logged in"));
      }
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.submitText),
          variables: {
            "text": text,
            "username": username,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        log("Submit Text error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final sessionData = result.data?['submitText'] as Map<String, dynamic>?;
      log("Submit Text response: $sessionData");
      if (sessionData == null) {
        return Result(
            response:
                ResponseError(message: "submitText data is null or missing"));
      }

      final sessionId = sessionData['id'] as String?;
      if (sessionId == null) {
        return Result(response: ResponseError(message: "Session ID is null"));
      }

      final sessionResult =
          await getSession(context: context, sessionId: sessionId);
      if (sessionResult.response is ResponseError) {
        return sessionResult;
      }

      final freeAiModel =
          (sessionResult.response as ResponseSuccess<FreeAiModel>).data!;
      final updatedModel = freeAiModel.copyWith(
        name: name,
        title: name,
        fileType: "text",
        url: "text://content",
      );

      return Result(
          response: ResponseSuccess<FreeAiModel>(
              data: updatedModel, message: "Text submitted successfully"));
    } catch (e) {
      log("Submit Text exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> deleteSession({
    required BuildContext context,
    required String sessionId,
    required String username,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.deleteSession),
          variables: {
            "id": sessionId,
            "username": username,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        log("Delete session error: ${result.exception.toString()}");
        return Result(
          response: ResponseError(
            message: result.exception.toString(),
            errors: result.exception?.graphqlErrors,
          ),
        );
      }

      final bool success = result.data?['deleteSession'] as bool? ?? false;
      if (!success) {
        return Result(
          response: ResponseError(message: "Failed to delete session"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: true,
          message: "Session deleted successfully",
        ),
      );
    } catch (e) {
      log("Delete session exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> addNoteToSession({
    required BuildContext context,
    required String sessionId,
    required String note,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(GraphQLQueries.addNoteToSession),
          variables: {
            "sessionId": sessionId,
            "note": note,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        log("Add note to session error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final noteData =
          result.data?['addNoteToSession'] as Map<String, dynamic>?;
      if (noteData == null) {
        return Result(
            response: ResponseError(
                message: "addNoteToSession data is null or missing"));
      }

      return Result(
          response: ResponseSuccess<String>(
              data: noteData['content'] as String? ?? note,
              message: "Note added successfully"));
    } catch (e) {
      log("Add note to session exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> getSession({
    required BuildContext context,
    required String sessionId,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.query(
        QueryOptions(
            document: gql(GraphQLQueries.getSession),
            variables: {"id": sessionId},
            fetchPolicy: FetchPolicy.networkOnly),
      );

      if (result.hasException) {
        log("Get session error for ID $sessionId: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final sessionData = result.data?['getSession'] as Map<String, dynamic>?;
      if (sessionData == null) {
        return Result(
            response:
                ResponseError(message: "getSession data is null or missing"));
      }

      final freeAiModel = FreeAiModel.fromJson(sessionData);
      log("Fetched session $sessionId: ${freeAiModel.title}");

      return Result(
          response: ResponseSuccess<FreeAiModel>(
              data: freeAiModel, message: "Session fetched successfully"));
    } catch (e) {
      log("Get session exception for ID $sessionId: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> getSessions({required BuildContext context}) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final username = userProvider.user?.username;
      if (username == null) {
        return Result(response: ResponseError(message: "User not logged in"));
      }
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(GraphQLQueries.getSessions),
          variables: {"username": username},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        log("Get sessions error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final sessionsData = result.data?['getSessions'] as List<dynamic>?;
      log("Get sessions response: ${sessionsData?.length} sessions");
      if (sessionsData == null || sessionsData.isEmpty) {
        return Result(
            response: ResponseSuccess<List<FreeAiModel>>(
                data: [], message: "No sessions found"));
      }

      final sessions = <FreeAiModel>[];
      final failedSessions = <String>[]; // Track failed sessions
      for (final session in sessionsData) {
        final sessionId = session['id'] as String?;
        if (sessionId != null) {
          try {
            final sessionResult =
                await getSession(context: context, sessionId: sessionId);
            if (sessionResult.response is ResponseSuccess) {
              final model =
                  (sessionResult.response as ResponseSuccess<FreeAiModel>)
                      .data!;
              sessions.add(model.copyWith(
                name: session['title'] as String? ?? model.name,
                chats: (session['chats'] as List<dynamic>?)
                    ?.cast<Map<String, dynamic>>(),
              ));
              log("Added session: $sessionId, title: ${model.title}");
            } else {
              log("Failed to fetch session $sessionId: ${(sessionResult.response as ResponseError).message}");
              failedSessions.add(sessionId);
            }
          } catch (e) {
            log("Error processing session $sessionId: $e");
            failedSessions.add(sessionId);
          }
        }
      }

      // Notify user of failed sessions
      if (failedSessions.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "${failedSessions.length} session(s) could not be loaded due to errors."),
          ),
        );
      }

      log("Fetched ${sessions.length} sessions, ${failedSessions.length} failed");
      return Result(
          response: ResponseSuccess<List<FreeAiModel>>(
              data: sessions, message: "Sessions fetched successfully"));
    } catch (e) {
      log("Get sessions exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> getExploreTopics(
      {required BuildContext context}) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.query(
        QueryOptions(
            document: gql(GraphQLQueries.getExploreTopics),
            fetchPolicy: FetchPolicy.networkOnly),
      );

      if (result.hasException) {
        log("Get explore topics error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final exploreTopicsData =
          result.data?['getExploreTopics'] as List<dynamic>?;
      log("Get explore topics response: ${exploreTopicsData?.length} topics");
      if (exploreTopicsData == null || exploreTopicsData.isEmpty) {
        return Result(
            response: ResponseSuccess<List<FreeAiModel>>(
                data: [], message: "No explore topics found"));
      }

      final exploreTopics = <FreeAiModel>[];
      final failedTopics = <String>[]; // Track failed topics
      for (final topic in exploreTopicsData) {
        final sessionId = topic['id'] as String?;
        if (sessionId != null) {
          try {
            final sessionResult =
                await getSession(context: context, sessionId: sessionId);
            if (sessionResult.response is ResponseSuccess) {
              final model =
                  (sessionResult.response as ResponseSuccess<FreeAiModel>)
                      .data!;
              exploreTopics.add(model.copyWith(
                name: topic['title'] as String? ?? model.name,
                chats: (topic['chats'] as List<dynamic>?)
                    ?.cast<Map<String, dynamic>>(),
              ));
              log("Added topic: $sessionId, title: ${model.title}");
            } else {
              log("Failed to fetch topic $sessionId: ${(sessionResult.response as ResponseError).message}");
              failedTopics.add(sessionId);
            }
          } catch (e) {
            log("Error processing topic $sessionId: $e");
            failedTopics.add(sessionId);
          }
        }
      }

      // Notify user of failed topics
      if (failedTopics.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "${failedTopics.length} explore topic(s) could not be loaded due to errors."),
          ),
        );
      }

      log("Fetched ${exploreTopics.length} explore topics, ${failedTopics.length} failed");
      return Result(
          response: ResponseSuccess<List<FreeAiModel>>(
              data: exploreTopics,
              message: "Explore topics fetched successfully"));
    } catch (e) {
      log("Get explore topics exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> chat({
    required BuildContext context,
    required String sessionId,
    required String question,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(GraphQLQueries.chat),
          variables: {"sessionId": sessionId, "question": question},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        log("Chat error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final chatData = result.data?['chat'] as Map<String, dynamic>?;
      if (chatData == null) {
        return Result(
            response: ResponseError(message: "chat data is null or missing"));
      }

      return Result(
          response: ResponseSuccess<Map<String, dynamic>>(
              data: chatData, message: "Chat response received"));
    } catch (e) {
      log("Chat exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> regenerateChapters({
    required BuildContext context,
    required String sessionId,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(GraphQLQueries.regenerateChapters),
            variables: {"sessionId": sessionId},
            fetchPolicy: FetchPolicy.networkOnly),
      );

      if (result.hasException) {
        log("Regenerate chapters error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final chaptersData = result.data?['regenerateChapters'] as List<dynamic>?;
      if (chaptersData == null) {
        return Result(
            response: ResponseError(
                message: "regenerateChapters data is null or missing"));
      }

      final chapters = chaptersData
          .map((c) => {
                'title': c['title'] as String?,
                'summary': c['summary'] as String?,
                'startTime': c['startTime'] as double?,
                'pageNumber': c['pageNumber'] as int?,
              })
          .toList();

      return Result(
          response: ResponseSuccess<List<Map<String, dynamic>>>(
              data: chapters, message: "Chapters regenerated successfully"));
    } catch (e) {
      log("Regenerate chapters exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> regenerateSummary({
    required BuildContext context,
    required String sessionId,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(GraphQLQueries.regenerateSummary),
            variables: {"sessionId": sessionId},
            fetchPolicy: FetchPolicy.networkOnly),
      );

      if (result.hasException) {
        log("Regenerate summary error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final summaryData =
          result.data?['regenerateSummary'] as Map<String, dynamic>?;
      if (summaryData == null) {
        return Result(
            response: ResponseError(
                message: "regenerateSummary data is null or missing"));
      }

      return Result(
          response: ResponseSuccess<String>(
              data: summaryData['content'] as String? ?? '',
              message: "Summary regenerated successfully"));
    } catch (e) {
      log("Regenerate summary exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> regenerateQuestions({
    required BuildContext context,
    required String sessionId,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(GraphQLQueries.regenerateQuestions),
            variables: {"sessionId": sessionId},
            fetchPolicy: FetchPolicy.networkOnly),
      );

      if (result.hasException) {
        log("Regenerate questions error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final questionsData =
          result.data?['regenerateQuestions'] as List<dynamic>;
      if (questionsData == null) {
        return Result(
            response: ResponseError(
                message: "regenerateQuestions data is null or missing"));
      }

      final questions = questionsData
          ?.map((q) => {
                'content': q['content'] as String?,
                'hint': q['hint'] as String?,
              })
          .toList();

      return Result(
          response: ResponseSuccess<List<Map<String, dynamic>>>(
              data: questions, message: "Questions regenerated successfully"));
    } catch (e) {
      log("Regenerate questions exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> regenerateQuiz({
    required BuildContext context,
    required String sessionId,
  }) async {
    try {
      final GraphQLClient client = await graphqlConfig.clientToQuery();
      final QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(GraphQLQueries.regenerateQuiz),
            variables: {"sessionId": sessionId},
            fetchPolicy: FetchPolicy.networkOnly),
      );

      if (result.hasException) {
        log("Regenerate quiz error: ${result.exception.toString()}");
        return Result(
            response: ResponseError(
                message: result.exception.toString(),
                errors: result.exception?.graphqlErrors));
      }

      final quizData = result.data?['regenerateQuiz'] as Map<String, dynamic>?;
      if (quizData == null) {
        return Result(
            response: ResponseError(
                message: "regenerateQuiz data is null or missing"));
      }

      return Result(
          response: ResponseSuccess<Map<String, dynamic>>(
              data: quizData, message: "Quiz regenerated successfully"));
    } catch (e) {
      log("Regenerate quiz exception: $e");
      return Result(response: ResponseError(message: e.toString()));
    }
  }
}
