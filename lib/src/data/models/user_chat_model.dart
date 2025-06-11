import 'package:intl/intl.dart';

class UserChatModel {
  UserChatModel({
    required this.title,
    required this.image,
    required this.text,
    required this.dateTime,
    required this.notificationCount,
    required this.isVerified,
    required this.isOnline,
    required this.isGroupChat,
  });

  final String title;
  final String image;
  final String text;
  final DateTime dateTime;
  final int notificationCount;
  final bool isVerified;
  final bool isOnline;
  final bool isGroupChat;

  String get formatDateTime {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays > 1) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else {
      return DateFormat('HH:mm').format(dateTime);
    }
  }
}
