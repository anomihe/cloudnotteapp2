import 'dart:developer';

import 'package:cloudnottapp2/src/api_strings/api_quries/user_quries.dart';
import 'package:cloudnottapp2/src/config/graphql.dart';
import 'package:cloudnottapp2/src/config/storage.dart';
import 'package:cloudnottapp2/src/data/models/recording_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

abstract class RecordingRepository {
  Future<Result<dynamic>> saveRecording(
      {required String spaceId, required CreateRecordingInput input});
}

class RecordingRepositoryImpl extends RecordingRepository {
  static GraphQLConfig graphqlConfig = GraphQLConfig();

  @override
  Future<Result<dynamic>> saveRecording(
      {required String spaceId, required CreateRecordingInput input}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(saveRecordingQuery),
        variables: {
          'input': input.toJson(),
          "spaceId": spaceId,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception?.graphqlErrors.first.message,
          errors: result.exception?.graphqlErrors,
        ));
      }
      var responseData = result.data?['saveClassRecording'];
      log("DATA: ${responseData.toString()}");
      return Result(
        response: ResponseSuccess<bool>(
          data: true,
          message: "createLessonNote",
        ),
      );
    } catch (error) {
      return Result(response: ResponseError(message: error.toString()));
    }
  }
}
