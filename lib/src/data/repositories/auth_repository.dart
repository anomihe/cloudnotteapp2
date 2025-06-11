import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/login_response_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';

abstract class AuthRepository {
  Future<Result<dynamic>> signIn(
      {required String email, required String password});
  Future<Result<dynamic>> changePassword(
      {required String token, required String password});
  Future<Result<dynamic>> resetPassword({
    required String email,
  });
  Future<Result<dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String activity,
  });
  Future<Result<dynamic>> resendOtp({
    required String email,
    required String activity,
  });
  Future<Result<dynamic>> googleSignin(String token, String deviceType);
}

class AuthRepositoryImpl implements AuthRepository {
  static GraphQLConfig graphqlConfig = GraphQLConfig();
  String? _authToken;

  String? get authToken => _authToken;

  @override
  Future<Result<dynamic>> googleSignin(String token, String deviceType) async {
    try {
      GraphQLClient client = await graphqlConfig.clientToQuery();
      const String request = r"""
          mutation GoogleAuth($token: String!, $platform: String!) {
              googleAuth(token: $token, platform: $platform) {
                token,
                isVerified
              }
          }
          """;

      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(request),
          fetchPolicy: FetchPolicy.noCache,
          variables: {"token": token, "platform": deviceType},
        ),
      );
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception?.graphqlErrors.first.message,
          errors: result.exception?.graphqlErrors,
        ));
      }
      final data = result.data!['googleAuth'];
      _authToken = data['token'];

      return Result(
        response: ResponseSuccess<LoginResponseModel>.fromJson(
          result.data!,
          (data) => LoginResponseModel.fromJson(data),
          "googleAuth",
        ),
      );
    } catch (e) {
      log(e.toString());
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result<dynamic>> signIn(
      {required String email, required String password}) async {
    try {
      GraphQLClient client = await graphqlConfig.clientToQuery();
      const String request = r"""
          mutation LoginUser($input:LoginUserInput!){
              loginUser(input: $input) {
                token,
                isVerified
              }
          }
          """;

      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(request),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            "input": {
              "identifier": email,
              "password": password,
            }
          },
        ),
      );
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception?.graphqlErrors.first.message,
          errors: result.exception?.graphqlErrors,
        ));
      }
      final data = result.data!['loginUser'];
      _authToken = data['token'];

      return Result(
        response: ResponseSuccess<LoginResponseModel>.fromJson(
          result.data!,
          (data) => LoginResponseModel.fromJson(data),
          "loginUser",
        ),
      );
    } catch (e) {
      print(e.toString());
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    _authToken = null;
  }

  @override
  Future<Result> changePassword(
      {required String token, required String password}) async {
    try {
      GraphQLClient client = await graphqlConfig.clientToQuery();
      const String request = r"""
        mutation ChangePassword($token: String!, $password: String!) {
          changePassword(token: $token, password: $password)
      }
          """;

      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(request),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            "token": token,
            "password": password,
          },
        ),
      );
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final data = result.data!['changePassword'];
      log('mtmtmtm $data');
      return Result(
        response: ResponseSuccess<bool>(
          data: data as bool,
        ),
      );
      // return Result(
      //   response: ResponseSuccess<bool>.fromJson(
      //     data!,
      //     (data) => data as bool,
      //     "changePassword",
      //   ),
      // );
    } catch (e) {
      print(e.toString());
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> resetPassword({required String email}) async {
    try {
      GraphQLClient client = await graphqlConfig.clientToQuery();
      const String request = r"""
        mutation ResetPassword($email: String!) {
             resetPassword(email: $email)
          }
          """;

      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(request),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            "email": email,
          },
        ),
      );
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final data = result.data!['resetPassword'] as bool;
      log('datasssss $data');
      return Result(
        response: ResponseSuccess(
          data: data,
        ),
      );
    } catch (e) {
      print(e.toString());
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> verifyOtp(
      {required String email,
      required String otp,
      required String activity}) async {
    try {
      GraphQLClient client = await graphqlConfig.clientToQuery();
      const String request = r"""
      mutation VerifyOtp($input: VerifyOtpInput!) {
           verifyOtp(input: $input) {
            token
        }
      }
          """;

      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(request),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            "input": {
              "activity": activity,
              "email": email,
              "otp": otp,
            }
          },
        ),
      );
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final data = result.data!['verifyOtp'];
      return Result(
        response: ResponseSuccess<String>(data: data['token'] as String),
      );
      // return Result(
      //   response: ResponseSuccess<String>.fromJson(
      //     data!,
      //     (data) {
      //       log('my; data ${data['token']}');
      //       return data['token'] as String;
      //     },
      //     "verifyOtp",
      //   ),
      // );
    } catch (e) {
      print(e.toString());
      return Result(response: ResponseError(message: e.toString()));
    }
  }

  @override
  Future<Result> resendOtp(
      {required String email, required String activity}) async {
    try {
      GraphQLClient client = await graphqlConfig.clientToQuery();
      const String request = r"""
        mutation ResendOtp($input: ResendOtp!) {
          resendOtp(input: $input)
      }
          """;

      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(request),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            "input": {
              "activity": activity,
              "email": email,
            }
          },
        ),
      );
      if (result.hasException) {
        return Result(
            response: ResponseError(
          message: result.exception.toString(),
          errors: result.exception?.graphqlErrors,
        ));
      }
      final data = result.data!['resendOtp'] as bool;
      log('datasssss $data');
      return Result(
        response: ResponseSuccess(
          data: data,
        ),
      );
    } catch (e) {
      print(e.toString());
      return Result(response: ResponseError(message: e.toString()));
    }
  }
}
