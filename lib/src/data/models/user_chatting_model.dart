import 'package:intl/intl.dart';

class UserChattingModel {
  UserChattingModel({
    required this.text,
    required this.dateTime,
    required this.isUserMessage,
  });

  final String text;
  final DateTime dateTime;
  final bool isUserMessage;

  String get formatDateTime {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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
