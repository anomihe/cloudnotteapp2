import 'package:cloudnottapp2/src/data/models/recorded_class_model.dart';
import 'package:intl/intl.dart';

final date = DateTime.now();

String formatDateWithSuffix(DateTime date) {
  final day = date.day;
  final suffix = _getDaySuffix(day);
  final formattedDate = DateFormat("d'$suffix' MMM yyyy").format(date);
  final formattedTime = DateFormat('hh:mm a').format(date); // formats AM/PM
  return '$formattedDate - $formattedTime';
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return 'th';
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

List<RecordedClassModel> recordedMockdata = [
  RecordedClassModel(
      question: 'What is the human body?',
      teacherImage: 'assets/app/teacher_image.png',
      teacherName: 'Mrs Afudoza',
      dateTime: formatDateWithSuffix(date),
      duration: '30 mins'),
  RecordedClassModel(
      question: 'What body is the human?',
      teacherImage: 'assets/app/teacher_image.png',
      teacherName: 'Mr Afudoza',
      dateTime: formatDateWithSuffix(date),
      duration: '40 mins'),
  RecordedClassModel(
      question: 'What is the human body What is the human body?',
      teacherImage: 'assets/app/teacher_image.png',
      teacherName: 'Mrs Ekong',
      dateTime: formatDateWithSuffix(date),
      duration: '50 mins'),
  RecordedClassModel(
      question: 'What is the human body?',
      teacherImage: 'assets/app/teacher_image.png',
      teacherName: 'Mrs Afudoza',
      dateTime: formatDateWithSuffix(date),
      duration: '30 mins'),
  RecordedClassModel(
      question: 'What is the human body?',
      teacherImage: 'assets/app/teacher_image.png',
      teacherName: 'Mrs Afudoza',
      dateTime: formatDateWithSuffix(date),
      duration: '30 mins'),
];
