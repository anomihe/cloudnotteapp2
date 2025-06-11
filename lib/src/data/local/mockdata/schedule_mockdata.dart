import 'package:cloudnottapp2/src/data/models/class_schedules_model.dart';
import 'package:intl/intl.dart';

String formattedCountdown(DateTime date) {
  final countDown = DateFormat('h');
  final formattedTime = DateFormat('hh:mm a').format(date); // formats AM/PM
  return '$countDown / until $formattedTime';
}

final List<ClassSchedulesModel> mockSchedules = [
  ClassSchedulesModel(
    subject: 'Physics',
    teacherImage: 'assets/app/mock_person_image.jpg',
    teacherName: 'Ugo Matt',
  ),
  ClassSchedulesModel(
    subject: 'English Language',
    teacherImage: 'assets/app/mock_person_image.jpg',
    teacherName: 'Matt Ugo',
  ),
  ClassSchedulesModel(
    subject: 'Mathematics',
    teacherImage: 'assets/app/mock_person_image.jpg',
    teacherName: 'Cto Matt',
  ),
  ClassSchedulesModel(
    subject: 'Break Time',
    teacherImage: 'assets/app/mock_person_image.jpg',
    teacherName: 'Cto Ugo',
  ),
  ClassSchedulesModel(
    subject: 'Geography',
    teacherImage: 'assets/app/mock_person_image.jpg',
    teacherName: 'Matt Cto',
  ),
  ClassSchedulesModel(
    subject: 'Music',
    teacherImage: 'assets/app/mock_person_image.jpg',
    teacherName: 'Cto Ugo Matt',
  ),
];
