class StudentResultModel {
  final String imageUrl;
  final String studentName;
  final String username;
  final List<ResultModel>? resultModel;

  StudentResultModel({
    required this.imageUrl,
    required this.studentName,
    required this.username,
    this.resultModel,
  });
}

class ResultModel {
  final String subjectName;
  final String grade;
  final int totalScore;
  final int ca1Score;
  final int ca2Score;
  final int examScore;
  final String position;
  final double averageScore;
  final int highestScore;
  final int lowestScore;
  final String teacherComment;

  const ResultModel({
    required this.subjectName,
    required this.grade,
    required this.totalScore,
    required this.ca1Score,
    required this.ca2Score,
    required this.examScore,
    required this.position,
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.teacherComment,
  });
}
