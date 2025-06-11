import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:cloudnottapp2/src/data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository chatRepository;
  ChatProvider({required this.chatRepository});

  ResponseSuccess? successResponse;
  ResponseError? errorResponse;

  bool _isError = false;
  bool _isSuccess = false;

  bool get isError => _isError;
  bool get isSuccess => _isSuccess;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(bool value) {
    _isError = value;
    notifyListeners();
  }

  void setSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  Future startConversation({
    required String senderId,
    required String senderUsername,
    required String receiverId,
    required String receiverUsername,
  }) async {
    try {
      setLoading(true);
      Result<dynamic> result = await chatRepository.startConversation(
          receiverId: receiverId,
          receiverUsername: receiverUsername,
          senderId: senderId,
          senderUsername: senderUsername);
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        log("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      setSuccess(true);
      setLoading(false);
      notifyListeners();
      return;
    } catch (error) {
      log("ERROR: ${error.toString()}");
      errorResponse = ResponseError(message: error.toString());
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }
}
