import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/recording_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:cloudnottapp2/src/data/repositories/recording_repository.dart';
import 'package:flutter/material.dart';

class RecordingProvider extends ChangeNotifier {
  final RecordingRepository recordingRepository;
  RecordingProvider({required this.recordingRepository});

  ResponseError? errorResponse;

  bool _isError = false;
  bool _isSuccess = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  bool get isError => _isError;

  Future<void> saveRecording(String spaceId, CreateRecordingInput input) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();
    try {
      final result = await recordingRepository.saveRecording(
        spaceId: spaceId,
        input: input,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        log("ERROR:  ${errorResponse?.errors.toString()}");
        _isLoading = false;
        _isError = true;
        notifyListeners();
        return;
      }
      _isLoading = false;
      _isSuccess = true;
      notifyListeners();
    } catch (e) {
      _isError = true;
      errorResponse = ResponseError(message: e.toString());
      log("ERROR:  ${errorResponse?.errors.toString()}");
      _isLoading = false;
      notifyListeners();
    }
  }
}
