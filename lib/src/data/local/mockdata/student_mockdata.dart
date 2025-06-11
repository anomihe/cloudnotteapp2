import 'package:cloudnottapp2/src/data/local/mockdata/homework_mockdata.dart';
import 'package:cloudnottapp2/src/data/models/student_model.dart';

// Generate student data linked to biology homework questions
final List<StudentModel> dummyStudents = [
  StudentModel(
    name: 'Ugochukwu Matthew',
    image: 'assets/app/profile_image.png',
    score: '30/50',
    dateTime: DateTime.now().subtract(Duration(minutes: 15)),
    scoreCount: 30,
    selectedAnswers: {0: 1, 1: 2},
    chosenAnswer: ['B', 'C'],
    uploadFiles: {2: 'file1.txt'},
    options: {
      for (var q in biologyHomework.first.questions) q.questionNumber: q.answer,
    },
  ),
  StudentModel(
    name: 'Arnold Emmanuel',
    image: 'assets/app/profile_image.png',
    score: '20/50',
    dateTime: DateTime.now().subtract(Duration(days: 1)),
    scoreCount: 20,
    selectedAnswers: {0: 0, 1: 3},
    chosenAnswer: ['A', 'D'],
    uploadFiles: {2: 'file2.png'},
    options: {
      for (var q in biologyHomework.first.questions) q.questionNumber: q.answer,
    },
  ),
  StudentModel(
    name: 'Nmesoma Anomehi',
    image: 'assets/app/profile_image.png',
    score: '25/50',
    dateTime: DateTime.now().subtract(Duration(hours: 6)),
    scoreCount: 25,
    selectedAnswers: {0: 2, 1: 1},
    chosenAnswer: ['C', 'B'],
    uploadFiles: {},
    options: {
      for (var q in biologyHomework.first.questions) q.questionNumber: q.answer,
    },
  ),
  StudentModel(
    name: 'Tengeh Mary',
    image: 'assets/app/profile_image.png',
    score: '15/50',
    dateTime: DateTime.now().subtract(Duration(days: 1)),
    scoreCount: 15,
    selectedAnswers: {0: 1, 1: 2},
    chosenAnswer: ['B', 'C'],
    uploadFiles: {3: 'file3.pdf'},
    options: {
      for (var q in biologyHomework.first.questions) q.questionNumber: q.answer,
    },
  ),
];
