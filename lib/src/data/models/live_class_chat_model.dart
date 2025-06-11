import 'package:intl/intl.dart';

class LiveClassChatModel {
  LiveClassChatModel({
    required this.text,
    required this.teacherName,
    required this.teacherImage,
    required this.studentImage,
    required this.dateTime,
    required this.isStudentMessage,
  });
  final String text;
  final String teacherName;
  final String teacherImage;
  final String studentImage;
  final DateTime dateTime;
  bool isStudentMessage = true;

  String get formatedDateTime {
    final time = DateTime.now();
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
