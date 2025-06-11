import 'dart:developer';
import 'package:cloudnottapp2/src/data/models/class_group.dart';
import 'package:cloudnottapp2/src/data/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../../api_strings/api_quries/user_quries.dart';
import '../../config/config.dart';
import '../models/response_model.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  Future<Result<dynamic>> getUser({required BuildContext context});
  Future<Result<dynamic>> getUserByUsername({required String username});
  Future<Result<dynamic>> userSpaces({required BuildContext context});
  Future<Result<dynamic>> userPersonnelSpace(
      {required String alias, required String userId});
  Future<Result<dynamic>> userClassTimeTable(
      {required BuildContext context,
      required String classId,
      required String spaceId});
  Future<Result<dynamic>> teacherTimeTable(
      {required BuildContext context, required String spaceId});

  Future<Result<dynamic>> userJustSpace(
      {required String alias, required bool isAdmin});

  Future<Result<dynamic>> getUserClasses({
    required BuildContext context,
    required String spaceId,
    required String classGroupId,
  });
  Future<Result<dynamic>> getClassGroups({
    required BuildContext context,
    required String spaceId,
  });
  Future<Result<dynamic>> getSpaceInvite({
    required BuildContext context,
    required String spaceId,
  });
  Future<Result<dynamic>> getSpaceInviteAccept({
    required BuildContext context,
    required String spaceId,
    required String invitationId,
  });
  Future<Result<dynamic>> getSpaceInviteReject({
    required BuildContext context,
    required String spaceId,
    required String invitationId,
  });
  Future<Result<dynamic>> getSpaceInviteLink({
    required BuildContext context,
  });
  Future<Result> responseSpaceLinkRequest({
    required BuildContext context,
    required String spaceId,
    required String requesterId,
    required String status,
  });

    Future<Result> sendSpaceLinkRequest({
    required BuildContext context,
    required String requestedUserUsernames,
    required String contactPerson,
    required String spaceId,
  });
}

class UserRepositoryImpl implements UserRepository {
  static GraphQLConfig graphqlConfig = GraphQLConfig();
  @override
  Future<Result> getUser({required BuildContext context}) async {
    final token = localStore.get('token', defaultValue: '');
    log('message $token');
    GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
    QueryResult result = await client.query(QueryOptions(
      document: gql(user),
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (result.hasException) {
      if (result.exception?.linkException != null) {
        bool shouldRetry =
            await showRetryDialog(context, "Network error. Retry?");
        if (shouldRetry) {
          return await getUser(context: context);
        }
      }
      log("my error ${result.exception?.graphqlErrors} ${result.exception.toString()}");
      if (result.exception?.graphqlErrors.first.message == 'User not found') {
        await showLogOutDialog(context,
            result.exception?.graphqlErrors.first.message ?? 'Unknown error');
        return Result(
          response: ResponseError(
            message: result.exception.toString(),
            errors: result.exception?.graphqlErrors,
          ),
        );
      }
      return Result(
          response: ResponseError(
        message: result.exception.toString(),
        errors: result.exception?.graphqlErrors,
      ));
    }
    return Result(
        response: ResponseSuccess.fromJson(
            result.data!, (data) => User.fromJson(data), "getUser"));
  }

  @override
  Future<Result> getUserByUsername({required String username}) async {
    final token = localStore.get('token', defaultValue: '');
    GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
    QueryResult result = await client.query(QueryOptions(
      document: gql(getUserByUSernameQuery),
      variables: {"username": username},
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (result.hasException) {
      log("my error ${result.exception?.graphqlErrors} ${result.exception.toString()}");
      if (result.exception?.graphqlErrors.first.message == 'User not found') {
        return Result(
          response: ResponseError(
            message: result.exception?.graphqlErrors.first.message,
            errors: result.exception?.graphqlErrors,
          ),
        );
      }
      return Result(
          response: ResponseError(
        message: result.exception.toString(),
        errors: result.exception?.graphqlErrors,
      ));
    }
    return Result(
      response: ResponseSuccess.fromJson(
        result.data!,
        (data) => User.fromJson(data),
        "getUserByUsername",
      ),
    );
  }

  @override
  Future<Result> userClassTimeTable(
      {required context,
      required String classId,
      required String spaceId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(studentTimeTableQuery),
        variables: {
          "classId": classId,
          "spaceId": spaceId,
          // "filters": {"timetableId": null, "startDate": null, "endDate": null},
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException) {
        log('ERROR_TIMETABLE: ${result.exception.toString()}');
        return Result(
            response: ResponseError(
          message: result.exception?.graphqlErrors.first.message.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final userTimeData = result.data?['getClassTimeTable'] as List<dynamic>?;
      if (userTimeData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ClassTimeTable> timetable = userTimeData
          .map((item) => ClassTimeTable.fromMap(item as Map<String, dynamic>))
          .toList();
      return Result(
        response: ResponseSuccess<List<ClassTimeTable>>(
          data: timetable,
          message: "getClassTimeTable",
        ),
      );
    } catch (e) {
      log('this is an $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getUserClasses(
      {required context,
      required String classGroupId,
      required String spaceId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(getClassesQuery),
        variables: {
          "classGroupId": classGroupId,
          "spaceId": spaceId,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException) {
        log('message ${result.exception?.graphqlErrors.first.message}');
        return Result(
            response: ResponseError(
          message: result.exception?.graphqlErrors.first.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final classesData = result.data?['getClasses'] as List<dynamic>?;
      if (classesData == null) {
        return Result(
          response: ResponseError(message: "Internal Server Error"),
        );
      }
      final List<ClassInfo> classes = classesData
          .map((item) => ClassInfo.fromJson(item as Map<String, dynamic>))
          .toList();
      log('CLASSES: ${classes.toString()}');
      return Result(
        response: ResponseSuccess<List<ClassInfo>>(
          data: classes,
          message: "getClasses",
        ),
      );
    } catch (e) {
      log('this is an $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getClassGroups(
      {required context, required String spaceId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(getClassGroupQuery),
        variables: {
          "spaceId": spaceId,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException) {
        log('message ${result.exception?.graphqlErrors.first.message}');
        return Result(
            response: ResponseError(
          message: result.exception?.graphqlErrors.first.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final classesData = result.data?['getClassGroups'] as List<dynamic>?;
      if (classesData == null) {
        return Result(
          response: ResponseError(message: "Internal Server Error"),
        );
      }
      final List<ClassGroup> classes = classesData
          .map((item) => ClassGroup.fromJson(item as Map<String, dynamic>))
          .toList();
      log('CLASS_GROUP: ${classes.toString()}');
      return Result(
        response: ResponseSuccess<List<ClassGroup>>(
          data: classes,
          message: "getClassGroups",
        ),
      );
    } catch (e) {
      log('this is an $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> userPersonnelSpace(
      {required String alias, required String userId}) async {
    try {
      log('ssssssalias $alias userId $userId');
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result =   await client.query(QueryOptions(
        document: gql(spaceUserQuery),
        variables: {"alias": alias, "userId": userId},
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException) {
        log("ERROR MESSAGE: ${result.exception?.graphqlErrors.first}");
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      log('timedduser ${result.data}');

      return Result(
        response: ResponseSuccess<SpaceUser>.fromJson(
            result.data!, (data) => SpaceUser.fromJson(data), "getSpaceUser"),
      );
    } catch (e) {
      log('timedderrs ${e}');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> userJustSpace(
      {required String alias, required bool isAdmin}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('muygtffdf$isAdmin');
      QueryResult result = await client.query(QueryOptions(
        document: gql(justSpace),
        variables: {"alias": alias, "isAdmin": isAdmin},
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      log('frfrfrfrfrfrf ${result.data}');
      return Result(
          response: ResponseSuccess<SpaceModel>.fromJson(
              result.data!, (data) => SpaceModel.fromJson(data), "getSpace"));
    } catch (e) {
      log('timedderrs ${e}');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> userSpaces({required BuildContext context}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.query(QueryOptions(
        document: gql(userSpacesQuery),
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await userSpaces(context: context);
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
      final userSpacesData = result.data?['getUserSpaces'] as List<dynamic>?;
      if (userSpacesData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<UserSpace> spaces = userSpacesData
          .map((item) => UserSpace.fromJson(item as Map<String, dynamic>))
          .toList();
      return Result(
        response: ResponseSuccess<List<UserSpace>>(
          data: spaces,
          message: "getUserSpaces",
        ),
      );
      // return Result(
      //     response:
      //         ResponseSuccess<List<UserSpace>>.fromJson(result.data!, (data) {
      //   return (data as List).map((item) => UserSpace.fromJson(item)).toList();
      // }, "getUserSpaces"));
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> teacherTimeTable(
      {required BuildContext context, required String spaceId}) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      log('gata tracher $spaceId');
      QueryResult result = await client.query(QueryOptions(
        document: gql(teacherTimeTableQuery),
        variables: {
          "spaceId": spaceId,
          "teacherId":""
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      if (result.hasException) {
        log('message ${result.exception?.graphqlErrors.first.message}');
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await teacherTimeTable(context: context, spaceId: spaceId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final userTimeData =
          result.data?['getTeacherTimeTable'] as List<dynamic>?;
      if (userTimeData == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }
      final List<ClassTimeTable> timetable = userTimeData
          .map((item) => ClassTimeTable.fromMap(item as Map<String, dynamic>))
          .toList();
      log('ttmmtmttttt ${timetable}');
      return Result(
        response: ResponseSuccess<List<ClassTimeTable>>(
          data: timetable,
          message: "getClassTimeTable",
        ),
      );
    } catch (e) {
      print('this is an $e');
      return Result(response: ResponseError(message: e.toString()));
    }
  }

@override
Future<Result> getSpaceInvite({
  required BuildContext context,
  required String spaceId,
}) async {
  try {
    final token = localStore.get('token', defaultValue: '');
    final client = await graphqlConfig.clientToQuery(token: token);

    final stopwatch = Stopwatch()..start(); // time the entire process

    final result = await client.query(QueryOptions(
      document: gql(spaceInviteQuery),
      variables: {
        "input": {
          "pageSize": 50,
          "status": "invited",
        }
      },
   fetchPolicy: FetchPolicy.noCache,
    ));

    print("GraphQL fetch duration: ${stopwatch.elapsed}");

    if (result.hasException) {
      return Result(
        response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ),
      );
    }

    final data = result.data?['data'] as Map<String, dynamic>?;
    final inviteData = data?['getUserSpaceInvitations'] as List<dynamic>? ?? [];

    // Direct parsing on the main thread
    final parsedInvites = inviteData
        .map((item) => UserSpaceInvitation.fromJson(item))
        .toList();

    print("Total duration including parsing: ${stopwatch.elapsed}");

    return Result(
      response: ResponseSuccess<List<UserSpaceInvitation>>(
        data: parsedInvites,
        message: "getUserSpaceInvitations",
      ),
    );
  } catch (e) {
    return Result(
      response: ResponseError(message: e.toString()),
    );
  }
}

  // @override
  // Future<Result> getSpaceInvite({
  //   required BuildContext context,
  //   required String spaceId,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.query(QueryOptions(
  //       document: gql(spaceInviteQuery), // You need to define this query
  //       variables: {
  //         "input": {"pageSize": 5, "status": "invited"}
  //       },
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     if (result.hasException) {
  //       return Result(
  //         response: ResponseError(
  //           message: result.exception.toString(),
  //           errors: result.exception?.graphqlErrors,
  //         ),
  //       );
  //     }
  //     final data = result.data?['data'] as Map<String, dynamic>?;
  //     final inviteData = data?['getUserSpaceInvitations'] as List<dynamic>;
  //     // final invite =
  //     //     inviteData.map((item) => UserSpaceInvitation.fromJson(item)).toList();
  //     final parsedInvites = await compute((List<dynamic> data) {
  //       return data.map((item) => UserSpaceInvitation.fromJson(item)).toList();
  //     }, inviteData);

  //     return Result(
  //       response: ResponseSuccess<List<UserSpaceInvitation>>(
  //         data: parsedInvites,
  //         message: "getUserSpaceInvitations",
  //       ),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  @override
  Future<Result> getSpaceInviteAccept({
    required BuildContext context,
    required String spaceId,
    required String invitationId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('cognitive $invitationId $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(spaceInviteAcceptMutation),
        variables: {
          "input": {"spaceId": spaceId, "spaceInvitationId": invitationId}
        },
        // variables: input.toJson(),
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getSpaceInviteAccept(
              context: context,
              spaceId: spaceId,
              invitationId: invitationId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['acceptSpaceInvite'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "acceptSpaceInvite",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> getSpaceInviteReject({
    required BuildContext context,
    required String spaceId,
    required String invitationId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('cognitive $invitationId $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(spaceInviteRejectMutation),
        variables: {
          "input": {"spaceId": spaceId, "spaceInvitationId": invitationId}
        },
        // variables: input.toJson(),
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await getSpaceInviteReject(
                context: context, spaceId: spaceId, invitationId: invitationId);
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['declineSpaceInvite'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "declineSpaceInvite",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }
@override
Future<Result> getSpaceInviteLink({
  required BuildContext context,
}) async {
  try {
    final token = localStore.get('token', defaultValue: '');
    final client = await graphqlConfig.clientToQuery(token: token);

    final result = await client.query(QueryOptions(
      document: gql(spaceInviteLinkQuery),
      fetchPolicy: FetchPolicy.noCache,
    ));

    if (result.hasException) {
      return Result(
        response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ),
      );
    }

    final inviteData = result.data?['getPendingSpaceLinkRequests'] as List<dynamic>? ?? [];

    // Directly parse without compute
    final parsedInvites = inviteData
        .map((item) => PendingSpaceLinkRequest.fromJson(item))
        .toList();

    return Result(
      response: ResponseSuccess<List<PendingSpaceLinkRequest>>(
        data: parsedInvites,
        message: "getPendingSpaceLinkRequests",
      ),
    );
  } catch (e) {
    return Result(
      response: ResponseError(message: e.toString()),
    );
  }
}

  // @override
  // Future<Result> getSpaceInviteLink({
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final token = localStore.get('token', defaultValue: '');
  //     GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
  //     QueryResult result = await client.query(QueryOptions(
  //       document: gql(spaceInviteLinkQuery ), // You need to define this query
  //       // variables: {
  //       //   "input": {"pageSize": 50, "status": "invited"}
  //       // },
  //       fetchPolicy: FetchPolicy.networkOnly,
  //     ));
  //     if (result.hasException) {
  //       return Result(
  //         response: ResponseError(
  //           message: result.exception.toString(),
  //           errors: result.exception?.graphqlErrors,
  //         ),
  //       );
  //     }
  //     //final data = result.data?['data'] as Map<String, dynamic>?;
  //     final inviteData = result.data?['getPendingSpaceLinkRequests'] as List<dynamic>;
  //     // final invite =
  //     //     inviteData.map((item) => UserSpaceInvitation.fromJson(item)).toList();
  //     final parsedInvites = await compute((List<dynamic> data) {
  //       return data.map((item) => PendingSpaceLinkRequest.fromJson(item)).toList();
  //     }, inviteData);

  //     return Result(
  //       response: ResponseSuccess<List<PendingSpaceLinkRequest>>(
  //         data: parsedInvites,
  //         message: "getPendingSpaceLinkRequests",
  //       ),
  //     );
  //   } catch (e) {
  //     return Result(response: ResponseError(message: e.toString()));
  //   }
  // }

  @override
  Future<Result> responseSpaceLinkRequest({
    required BuildContext context,
    required String spaceId,
    required String requesterId,
    required String status,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('cognitive $status $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(spaceInviteLinkMutation ),
        variables: {
          "input": {
    "requestId": requesterId,
    "spaceId": spaceId,
    "status": status
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
            return await responseSpaceLinkRequest(
              context: context,
              spaceId: spaceId,
              status: status,
              requesterId: requesterId,
            );
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['responseToSpaceLinkRequest'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "responseToSpaceLinkRequest",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
  }

@override
  Future<Result> sendSpaceLinkRequest({
    required BuildContext context,
    required String requestedUserUsernames,
    required String contactPerson,
    required String spaceId,
  }) async {
    try {
      final token = localStore.get('token', defaultValue: '');
      log('cognitive $requestedUserUsernames $contactPerson $spaceId');
      GraphQLClient client = await graphqlConfig.clientToQuery(token: token);
      QueryResult result = await client.mutate(MutationOptions(
        document: gql(spaceInviteLinkAcceptMutation ),
        variables: {
          "input": {
    "requestedUserUsernames": [
      requestedUserUsernames,
    ],
    "contactPerson": contactPerson,
    "spaceId": spaceId
  }
        },
        // variables: input.toJson(),
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      log('schedules group ${result.data} ${result.exception} token $token');
      if (result.hasException) {
        if (result.exception?.linkException != null) {
          bool shouldRetry =
              await showRetryDialog(context, "Network error. Retry?");
          if (shouldRetry) {
            return await sendSpaceLinkRequest(
                context: context, spaceId: spaceId, requestedUserUsernames: requestedUserUsernames, contactPerson: contactPerson);  
          }
        }
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }

      final userLessonCreate = result.data?['sendLinkAccountRequest'] as bool?;
      if (userLessonCreate == null) {
        return Result(
          response:
              ResponseError(message: "getUserSpaces key is null or missing"),
        );
      }

      return Result(
        response: ResponseSuccess<bool>(
          data: userLessonCreate,
          message: "sendLinkAccountRequest",
        ),
      );
    } catch (e) {
      return Result(response: ResponseError(message: e.toString()));
    }
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

Future showLogOutDialog(BuildContext context, String message) async {
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
              Provider.of<AuthProvider>(context, listen: false).logOut(context);
            },
            child: Text("Log Out"),
          ),
        ],
      );
    },
  );
  
}
