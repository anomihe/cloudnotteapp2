import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';

abstract class ChatRepository {
  Future<Result> startConversation({
    required String senderId,
    required String senderUsername,
    required String receiverId,
    required String receiverUsername,
  });
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Result> startConversation(
      {required String senderId,
      required String senderUsername,
      required String receiverId,
      required String receiverUsername}) async {
    try {
      final dio = dioClient();
      final response = await dio.post("/chat", data: {
        "senderId": senderId,
        "senderUsername": senderUsername,
        "receiverId": receiverId,
        "receiverUsername": receiverUsername,
      });
      final data = response.data;
      log("DATA ${data.toString()}");
      return Result(response: ResponseSuccess(message: data['message']));
    } catch (error) {
      log("conversation error ${error.toString()}");
      return Result(response: ResponseError(message: error.toString()));
    }
  }
}
