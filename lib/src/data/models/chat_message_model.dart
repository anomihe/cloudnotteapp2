import 'package:intl/intl.dart';

class ChatUser {
  String? id;
  String? name;
  String? fullName;
  String? image;
  String? role;
  ChatUser({this.id, this.image, this.name, this.role, this.fullName});

  factory ChatUser.fromJson(Map<String, dynamic> data) {
    return ChatUser(
      id: data['id'],
      name: data['name'],
      image: data['image'],
      role: data['role'],
      fullName: data['fullName'],
    );
  }
}

class ChatMessageModel {
  String? id;
  String? callId;
  ChatUser? user;
  String? message;
  String? fileUrl;
  bool? isFile;
  String? timeStamps;

  ChatMessageModel(
      {this.fileUrl,
      this.isFile,
      this.message,
      this.user,
      this.callId,
      this.timeStamps,
      this.id});

  factory ChatMessageModel.fromJson(Map<String, dynamic> data) {
    return ChatMessageModel(
      id: data['id'],
      callId: data['chatId'],
      message: data['message'],
      fileUrl: data['file'],
      isFile: data['isFile'],
      user: data['user'] != null ? ChatUser.fromJson(data['user']) : null,
      timeStamps: data['timestamp'],
    );
  }

  String get formattedDateTime {
    final time = DateTime.now();
    final dateTime =
        DateTime.parse(timeStamps ?? DateTime.now().toIso8601String());
    final difference = time.difference(dateTime);

    if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays > 1) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else {
      return DateFormat('HH:mm').format(dateTime);
    }
  }
}
