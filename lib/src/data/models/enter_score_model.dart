import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart';

class ManySubjectReportInput {
  final String? classId;
  final String? assessmentId;
  final List<SubjectScore>? scores;

  ManySubjectReportInput({
    this.classId,
    this.assessmentId,
    this.scores,
  });

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'assessmentId': assessmentId,
      'subjectScores': scores?.map((e) => e.toJson()).toList(),
    };
  }
}

class SubjectScore {
  final String? subjectId;
  final List<UserScore>? scores;

  SubjectScore({
    this.subjectId,
    this.scores,
  });

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'scores': scores?.map((e) => e.toJson()).toList(),
    };
  }
}

class UserScore {
  final String? userId;
  final List<AssessmentScore>? assessmentScores;

  UserScore({
    this.userId,
    this.assessmentScores,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'assessmentScores': assessmentScores?.map((e) => e.toJson()).toList(),
    };
  }
}

class AssessmentScore {
  final String? subAssessmentId;
  final int? score;

  AssessmentScore({
    this.subAssessmentId,
    this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'subAssessmentId': subAssessmentId,
      'score': score,
    };
  }
}
