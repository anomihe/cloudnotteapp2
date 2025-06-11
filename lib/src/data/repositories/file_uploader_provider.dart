import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:image/image.dart' as img;

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../config/config.dart';

class FileUploadNotifier extends ChangeNotifier {
  String? _fileUrl;
  String? get fileUrl => _fileUrl;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  Future<void> uploadFile(
    File uploadedFile,
  ) async {
    _isUploading = true;
    notifyListeners();
    log('we are uploading');
    try {
      String token = localStore.get("token", defaultValue: "");
      var request = http.MultipartRequest(
        "POST",
        Uri.https('api.cloudnottapp2.com', 'api/rest/upload/file'),
      );
      request.headers['Authorization'] = "Bearer $token";
      var stream = http.ByteStream(uploadedFile.openRead());
      var length = await uploadedFile.length();
      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: uploadedFile.uri.pathSegments.last,
        contentType: MediaType.parse(
          lookupMimeType(uploadedFile.path) ?? 'application/octet-stream',
        ),
      );
      request.files.add(multipartFile);
      request.headers['Content-Type'] = 'multipart/form-data';
      var response = await request.send();
      //
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        log('message $responseBody');
        var responseJson = jsonDecode(responseBody);
        log("FILE_UPLOAD_RESPONSE :${responseJson.toString()}");
        _fileUrl = responseJson['url'] as String;
        if (responseJson != null && responseJson['url'] != null) {
          if (fileUrl != null &&
              fileUrl!.isNotEmpty &&
              Uri.tryParse(fileUrl!)?.hasAbsolutePath == true) {
            _fileUrl = fileUrl;
          } else {
            _fileUrl = '';
          }
        } else {
          _fileUrl = '';
        }
        notifyListeners();
      } else {
        _fileUrl = fileUrl;
        notifyListeners();
      }
    } catch (e) {
      log('eroor uploading file $e');
      _fileUrl = null;
      notifyListeners();
    } finally {
      //  _fileUrl = null;
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> fetchImageUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        var responseJson = jsonDecode(response.body);
        _fileUrl = responseJson['url'];
      } else {
        _fileUrl = null;
      }
    } catch (e) {
      _fileUrl = null;
    } finally {
      notifyListeners();
    }
  }

  void clearImageUrl() {
    _fileUrl = null;
    notifyListeners();
  }

  Future<void> uploadRecordingFile(String filePath) async {
    log(filePath);
    try {
      _isUploading = true;
      notifyListeners();
      File audioFile = File(filePath);

      if (!await audioFile.exists()) {
        _isUploading = false;
        notifyListeners();
        log('Audio file does not exist');
        return;
      }
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType('audio', 'm4a'),
        ),
      });
      String token = localStore.get("token", defaultValue: "");
      final dio = dioClient(baseUrl: "https://cloudnottapp2.ifeanyi.dev");
      var response = await dio.post(
        '/api/chat/file',
        data: formData,
        onSendProgress: (int sent, int total) {
          double progress = (sent / total) * 100;
          log('Upload progress: ${progress.toStringAsFixed(2)}%');
        },
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        _isUploading = false;
        notifyListeners();
        _fileUrl = response.data['data']['url'];
        notifyListeners();
      }
    } on DioException catch (e) {
      _isUploading = false;
      notifyListeners();
      log('Dio error: $e');
    } catch (e) {
      _isUploading = false;
      notifyListeners();
      log('Error uploading file: $e');
    }
  }
}
