import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;

class ChatService extends ChangeNotifier {
  late Io.Socket _socket;

  String? _callId;
  String? _username;
  String? _userId;

  String? get callId => _callId;
  String? get username => _username;
  String? get userId => _userId;
  final Map<String, List<ChatMessageModel>> _chatMessages = {};
  Map<String, List<ChatMessageModel>> get chatMessages => _chatMessages;

  void initialize({
    required String callId,
    required String username,
    required String userId,
  }) {
    _callId = callId;
    _username = username;
    _userId = userId;
    notifyListeners();
    _socket = Io.io(
      // "https://local.cloudnottapp2.com",
      "https://cloudnottapp2.ifeanyi.dev",
      Io.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .build(),
    );
    notifyListeners();
    _socket.onConnect((_) {
      _socket.emit('join-group-call', {
        "callID": callId,
        "username": username,
        "userId": userId,
      });
      log("WEBSOCKET CONNECTED");
    });
    _socket.on(
      "live-class-message",
      (data) {
        log("WEBSOCKET CONNECTED ${data.toString()}");
        final chatMessage = ChatMessageModel.fromJson(data);
        final chatId = data['chatId'];
        if (!_chatMessages.containsKey(chatId)) {
          _chatMessages[chatId] = [];
          notifyListeners();
        }
        final exists =
            _chatMessages[chatId]!.any((msg) => msg.id == chatMessage.id);

        if (!exists) {
          _chatMessages[chatId]!.add(chatMessage);
          notifyListeners();
        }
      },
    );
    _socket.on('joined-group-call', (data) async {
      log('join call ${data.toString()}');
    });
    _socket.onDisconnect((data) {
      log("DISCONNECTED DATA: ${data.toString()}");
      log("WEBSOCKET DISCONNECTED");
    });
  }

  // void sendMessage(String callId, String message, String username) {
  //   _socket.emit('live-class-message', {
  //     "callID": callId,
  //     'username': username,
  //     'message': message,
  //     'timestamp': DateTime.now().toIso8601String(),
  //   });
  //   print("DONE SENDING");
  // }

  void sendMessage(String callId, String message, String username) {
    if (_socket.connected) {
      final data = {
        "callID": callId,
        "username": username,
        "message": message,
        "timestamp": DateTime.now().toIso8601String(),
      };
      log('Sending message: $data');
      _socket.emit('live-class-message', data);

      // FIX LATTER WITH ACTUAL DATA
      if (!_chatMessages.containsKey(callId)) {
        _chatMessages[callId] = [];
      }
      final chatMessage = ChatMessageModel.fromJson({
        "chatId": callId,
        "user": {
          "id": DateTime.now().toIso8601String(),
          "name": username,
        },
        "message": message,
        "timestamp": DateTime.now().toIso8601String(),
      });
      _chatMessages[callId]!.add(chatMessage);
      notifyListeners();
    } else {
      log('Socket not connected. Cannot send message.');
    }
  }

  List<ChatMessageModel> getChatMessageById(String id) {
    return _chatMessages[id] ?? <ChatMessageModel>[];
  }

  void disconnect() {
    _socket.disconnect();
    _socket.close();
    super.dispose();
  }
}
