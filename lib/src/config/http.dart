import 'package:dio/dio.dart';

Dio dioClient({String? baseUrl}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? "https://cloudnottapp2.ifeanyi.dev/api",
    // baseUrl: "https://local.cloudnottapp2.com/api",
  ));
  return dio;
}
