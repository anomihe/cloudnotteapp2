import 'package:intl/intl.dart';

class StudentModel {
  StudentModel({
    required this.name,
    required this.image,
    required this.score,
    required this.dateTime,
    required this.scoreCount,
    required this.selectedAnswers,
    required this.chosenAnswer,
    required this.uploadFiles,
    required this.options,
  });

  final String name;
  final String image;
  final String score;
  final DateTime dateTime;
  final int scoreCount;
  final Map<int, int?> selectedAnswers;
  final List<String> chosenAnswer;
  final Map<int, String?> uploadFiles;
  final Map<int, List<String>> options;

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
