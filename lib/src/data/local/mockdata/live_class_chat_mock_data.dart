import 'package:cloudnottapp2/src/data/models/live_class_chat_model.dart';

final List<LiveClassChatModel> liveClassMockData = [
  LiveClassChatModel(
    text:
        'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation',
    teacherName: 'Chimeruze chidimdu',
    teacherImage: 'assets/app/mock_person_image.jpg',
    studentImage: 'assets/app/mock_person_image.jpg',
    dateTime: DateTime.now().subtract(
      const Duration(minutes: 15),
    ),
    isStudentMessage: false,
  ),
  LiveClassChatModel(
    text: 'You calculate the earth orbit by 2',
    teacherName: 'Chimeruze chidimdu',
    teacherImage: 'assets/app/mock_person_image.jpg',
    studentImage: 'assets/app/mock_person_image.jpg',
    dateTime: DateTime.now().subtract(
      const Duration(hours: 6),
    ),
    isStudentMessage: true,
  ),
  LiveClassChatModel(
    text:
        'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation',
    teacherName: 'Chimeruze chidimdu',
    teacherImage: 'assets/app/mock_person_image.jpg',
    studentImage: 'assets/app/mock_person_image.jpg',
    dateTime: DateTime.now().subtract(
      const Duration(minutes: 30),
    ),
    isStudentMessage: false,
  ),
  LiveClassChatModel(
    text:
        'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation',
    teacherName: 'Chimeruze chidimdu',
    teacherImage: 'assets/app/mock_person_image.jpg',
    studentImage: 'assets/app/mock_person_image.jpg',
    dateTime: DateTime.now().subtract(
      const Duration(minutes: 35),
    ),
    isStudentMessage: false,
  ),
  LiveClassChatModel(
    text: 'You calculate the earth orbit by 2',
    teacherName: 'Chimeruze chidimdu',
    teacherImage: 'assets/app/mock_person_image.jpg',
    studentImage: 'assets/app/mock_person_image.jpg',
    dateTime: DateTime.now().subtract(
      const Duration(minutes: 60),
    ),
    isStudentMessage: true,
  ),
];
