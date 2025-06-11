// import 'dart:developer';

import 'dart:convert';
import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/class_group.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart' show ExamGroup;
import 'package:cloudnottapp2/src/data/models/user_model.dart';

// class ExamSession {
//   final String id;
//   final String studentId;
//   final String examId;
//   final String timeStarted;
//   final int timeLeft;
//   final String expectedEndTime;
//   final String lastSavedAt;
//   final String status;
//   final int totalScore;
//   final List<Answer> answers;
//   final Exam exam;

//   ExamSession({
//     required this.id,
//     required this.studentId,
//     required this.examId,
//     required this.timeStarted,
//     required this.timeLeft,
//     required this.expectedEndTime,
//     required this.lastSavedAt,
//     required this.status,
//     required this.totalScore,
//     required this.answers,
//     required this.exam,
//   });

//   // factory ExamSession.fromJson(Map<String, dynamic> json) {
//   //   log('the json $json');
//   //   return ExamSession(
//   //     id: json['id'] ?? '',
//   //     studentId: json['studentId'] ?? '',
//   //     examId: json['examId'] ?? '',
//   //     timeStarted: json['timeStarted'] ?? '',
//   //     // timeLeft: json['timeLeft'] ?? 0,
//   //     timeLeft: (json['timeLeft'] as num?)?.toInt() ?? 0,
//   //     expectedEndTime: json['expectedEndTime'] ?? '',
//   //     lastSavedAt: json['lastSavedAt'] ?? '',
//   //     status: json['status'] ?? '',
//   //     totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
//   //     answers: (json['answers'] as List<dynamic>?)
//   //             ?.map((e) => Answer.fromJson(e))
//   //             .toList() ??
//   //         [],
//   //     exam: Exam.fromJson(json['exam'] ?? {}),
//   //   );
//   // }
//   factory ExamSession.fromJson(Map<String, dynamic> json) {
//     log('the json $json');
//     return ExamSession(
//       id: json['id'] ?? '',
//       studentId: json['studentId'] ?? '',
//       examId: json['examId'] ?? '',
//       timeStarted: json['timeStarted'] ?? '',
//       timeLeft: (json['timeLeft'] as num?)?.toInt() ?? 0,
//       expectedEndTime: json['expectedEndTime'] ?? '',
//       lastSavedAt: json['lastSavedAt'] ?? '',
//       status: json['status'] ?? '',
//       totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
//       answers: (json['answers'] as List<dynamic>?)
//               ?.map((e) => Answer.fromJson(e))
//               .toList() ??
//           [],
//       exam: Exam.fromJson(json['exam'] ?? {}),
//     );
//   }
// }

// class Exam {
//   final List<ExamQuestion> questions;
//   final bool showCalculator;
//   final bool showCorrections;
//   final bool showScoreOnSubmission;
//   final bool shuffleCBTQuestions;
//   final String startDate;
//   final bool strictMode;
//   final Subject subject;
//   final String endDate;
//   final int duration;
//   final String instruction;
//   final int totalMark;

//   Exam(
//       {required this.questions,
//       required this.showCalculator,
//       required this.showCorrections,
//       required this.showScoreOnSubmission,
//       required this.shuffleCBTQuestions,
//       required this.startDate,
//       required this.strictMode,
//       required this.subject,
//       required this.endDate,
//       required this.duration,
//       required this.instruction,
//       required this.totalMark});

//   factory Exam.fromJson(Map<String, dynamic> json) {
//     return Exam(
//         questions: (json['questions'] as List<dynamic>?)
//                 ?.map((q) => ExamQuestion.fromJson(q))
//                 .toList() ??
//             [],
//         showCalculator: json['showCalculator'] ?? false,
//         showCorrections: json['showCorrections'] ?? false,
//         showScoreOnSubmission: json['showScoreOnSubmission'] ?? false,
//         shuffleCBTQuestions: json['shuffleCBTQuestions'] ?? false,
//         startDate: json['startDate'] ?? '',
//         strictMode: json['strictMode'] ?? false,
//         subject: Subject.fromJson(json['subject'] ?? {}),
//         endDate: json['endDate'] ?? '',
//         duration: json['duration'] ?? 0,
//         instruction: json['instruction'] ?? '',
//         totalMark: json['totalMark'] ?? 0);
//   }
// }

// class ExamQuestion {
//   final String? lessonNote;
//   final String? questionSection;
//   final String id;
//   final String question;
//   final List<Option> options;
//   final String questionImage;
//   final String? explanation;
//   final String type;

//   ExamQuestion({
//     this.lessonNote,
//     this.questionSection,
//     required this.id,
//     required this.question,
//     required this.options,
//     required this.questionImage,
//     this.explanation,
//     required this.type,
//   });

//   factory ExamQuestion.fromJson(Map<String, dynamic> json) {
//     return ExamQuestion(
//       id: json['id'] ?? '',
//       question: json['question'] ?? '',
//       options: (json['options'] as List<dynamic>?)
//               ?.map((e) => Option.fromJson(e))
//               .toList() ??
//           [],
//       questionImage: json['questionImage'] ?? '',
//       explanation: json['explanation'],
//       type: json['type'] ?? '',
//       lessonNote: json['lessonNote'],
//       questionSection: json['questionSection'],
//     );
//   }
// }

// class Option {
//   final String? image;
//   final String label;

//   Option({
//     this.image,
//     required this.label,
//   });

//   factory Option.fromJson(Map<String, dynamic> json) {
//     return Option(
//       image: json['image'],
//       label: json['label'] ?? '',
//     );
//   }
// }

// class Subject {
//   final String id;
//   final String name;

//   Subject({
//     required this.id,
//     required this.name,
//   });

//   factory Subject.fromJson(Map<String, dynamic> json) {
//     return Subject(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }

// class Answer {
//   final String questionId;
//   final String answer;
//   final List<String> resources;
//   final double score;
//   final bool isCorrect;

//   Answer({
//     required this.questionId,
//     required this.answer,
//     required this.resources,
//     required this.score,
//     required this.isCorrect,
//   });

//   factory Answer.fromJson(Map<String, dynamic> json) {
//     return Answer(
//       questionId: json['questionId'] ?? '',
//       answer: json['answer'] ?? '',
//       resources: (json['resources'] as List<dynamic>?)
//               ?.map((e) => e.toString())
//               .toList() ??
//           [],
//       score: (json['score'] as num?)?.toDouble() ?? 0.0,
//       isCorrect: json['isCorrect'] ?? false,
//     );
//   }
// }
class ExamSession {
  final String id;
  final String studentId;
  final Map<String, dynamic> student; // Added
  final String examId;
  final String timeStarted;
  final int timeLeft;
  final String expectedEndTime;
  final String lastSavedAt;
  final String status;
  final double totalScore;
  final List<Answer> answers;
  final Exam exam;

  ExamSession({
    required this.id,
    required this.studentId,
    required this.student,
    required this.examId,
    required this.timeStarted,
    required this.timeLeft,
    required this.expectedEndTime,
    required this.lastSavedAt,
    required this.status,
    required this.totalScore,
    required this.answers,
    required this.exam,
  });

  factory ExamSession.fromJson(Map<String, dynamic> json) {
    log('the json $json');
    return ExamSession(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      student: json['student'] as Map<String, dynamic>? ?? {},
      examId: json['examId'] ?? '',
      timeStarted: json['timeStarted'] ?? '',
      timeLeft: (json['timeLeft'] as num?)?.toInt() ?? 0,
      expectedEndTime: json['expectedEndTime'] ?? '',
      lastSavedAt: json['lastSavedAt'] ?? '',
      status: json['status'] ?? '',
      totalScore: (json['totalScore'] is int)
    ? (json['totalScore'] as int).toDouble()
    : (json['totalScore'] is double)
        ? json['totalScore'] as double
        : 0.0,

      // totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exam: Exam.fromJson(json['exam'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Answer {
  final String questionId;
  final String answer; // Will convert int to String
  final List<String> resources;
  final double score;
  final bool isCorrect;

  Answer({
    required this.questionId,
    required this.answer,
    required this.resources,
    required this.score,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['questionId'] ?? '',
      answer: _extractString(json['answer']),
      resources: (json['resources'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  static String _extractString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is int || value is double) return value.toString();
    return value.toString();
  }
}

class Exam {
  final List<ExamQuestion> questions;
  final bool showCalculator;
  final bool showCorrections;
  final bool showScoreOnSubmission;
  final bool shuffleCBTQuestions;
  final String startDate;
  final bool strictMode;
  final Subject subject;
  final String endDate;
  final int duration;
  final String instruction;
  final int totalMark;

  Exam({
    required this.questions,
    required this.showCalculator,
    required this.showCorrections,
    required this.showScoreOnSubmission,
    required this.shuffleCBTQuestions,
    required this.startDate,
    required this.strictMode,
    required this.subject,
    required this.endDate,
    required this.duration,
    required this.instruction,
    required this.totalMark,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => ExamQuestion.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
      showCalculator: json['showCalculator'] ?? false,
      showCorrections: json['showCorrections'] ?? false,
      showScoreOnSubmission: json['showScoreOnSubmission'] ?? false,
      shuffleCBTQuestions: json['shuffleCBTQuestions'] ?? false,
      startDate: json['startDate'] ?? '',
      strictMode: json['strictMode'] ?? false,
      subject: Subject.fromJson(json['subject'] as Map<String, dynamic>? ?? {}),
      endDate: json['endDate'] ?? '',
      // duration: json['duration'] ?? 0.0,
      duration: json['duration'] is int ? json['duration'] : 0,
      instruction: json['instruction'] ?? '',
      totalMark: json['totalMark'] is int ? json['totalMark'] : 0,
    );
  }
}

class ExamQuestion {
  final String? lessonNote;
  final Map<String, dynamic>? questionSection;
  final String id;
  final String question;
  final List<Option> options;
  final String questionImage;
  final String? explanation;
  final String type;
  final int mark;

  ExamQuestion({
    this.lessonNote,
    this.questionSection,
    required this.id,
    required this.question,
    required this.options,
    required this.questionImage,
    this.explanation,
    required this.type,
    required this.mark,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      questionImage: json['questionImage'] ?? '',
      explanation: json['explanation'],
      type: json['type'] ?? '',
      lessonNote: (json['lessonNote'] as List<dynamic>?)?.join(' ') ?? '',
      // lessonNote: json['lessonNote'],
      questionSection: json['questionSection'] as Map<String, dynamic>?,
      mark: json['mark'] is int ? json['mark'] : 0,
    );
  }
}

// class Option {
//   final String? image;
//   final String label;

//   Option({this.image, required this.label});

//   factory Option.fromJson(Map<String, dynamic> json) {
//     return Option(
//       image: json['image'],
//       label: json['label'] ?? '',
//     );
//   }
// }
class Option {
  final String? image;
  final String label;

  Option({this.image, required this.label});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      image: json['image'],
      label: _extractLabel(json['label']),
    );
  }

  static String _extractLabel(dynamic label) {
    if (label == null) return '';

    // If it's already a string, return it
    if (label is String) return label;

    // If it's a Map (like the HTML-like structure), try to get its content
    if (label is Map) {
      // If it has a 'content' key, use that
      if (label.containsKey('content')) return label['content'].toString();

      // If no 'content', convert the whole map to a string
      return label.toString();
    }

    // For any other type, convert to string
    return label.toString();
  }
}

class Subject {
  final String id;
  final String name;

  Subject({required this.id, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class AnswerInput {
  final String? questionId;
  final String? answer;
  final List<String>? resources;
  final double? score;
  final bool? isCorrect;

  AnswerInput({
    this.questionId,
    this.answer,
    this.resources,
    this.score,
    this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      "questionId": questionId,
      "answer": answer,
      "resources": resources ?? [],
      "score": score,
      "isCorrect": isCorrect,
    };
  }
}

class ExamSessionInput {
  final String? id;
  final String? studentId;
  final String? examId;
  final String? spaceId;
  final String? status;
  final String? examGroupId;
  final AnswerInput? answer;

  ExamSessionInput({
    this.id,
    this.studentId,
    this.examId,
    this.spaceId,
    this.status,
    this.examGroupId,
    this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "studentId": studentId,
      "examId": examId,
      "spaceId": spaceId,
      "status": status,
      "examGroupId": examGroupId,
      "answer": answer?.toJson(),
    };
  }
}

class GetExamSessionsInput {
  final String? classId;
  // final String? cursor;
  final String? examGroupId;
  final List<String>? examId;
  final int? pageSize;
  final String? spaceId;

  GetExamSessionsInput({
    this.classId,
    // this.cursor,
    this.examGroupId,
    this.examId,
    this.pageSize,
    this.spaceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "input": {
        "classId": classId,
        // "cursor": cursor,
        "examGroupId": examGroupId,
        "examId": examId,
        "pageSize": pageSize,
        "spaceId": spaceId,
      }
    };
  }
}

// class Exam {
//   final String? id;
//   final String? name;
//   final String? instruction;
//   final Subject? subject;
//   final ExamGroup? examGroup;
//   final List<String>? examSessionIds;
//   final String? startDate;
//   final String? endDate;
//   final bool? isOffline;
//   final List<ExamClass>? classes;
//   final bool? shuffleCBTQuestions;
//   final bool? showCalculator;
//   final int? questionCount;
//   final int? totalMark;
//   final int? totalTheoryMark;
//   final int? duration;
//   final List<String>? ineligibleStudentIds;
//   final List<ExamQuestion>? questions;
//   final String? pin;
//   final bool? enabled;
//   final bool? showScoreOnSubmission;
//   final bool? strictMode;
//   final bool? showCorrections;
//   final bool? scoreNotification;

//   Exam({
//     this.id,
//     this.name,
//     this.instruction,
//     this.subject,
//     this.examGroup,
//     this.examSessionIds,
//     this.startDate,
//     this.endDate,
//     this.isOffline,
//     this.classes,
//     this.shuffleCBTQuestions,
//     this.showCalculator,
//     this.questionCount,
//     this.totalMark,
//     this.totalTheoryMark,
//     this.duration,
//     this.ineligibleStudentIds,
//     this.questions,
//     this.pin,
//     this.enabled,
//     this.showScoreOnSubmission,
//     this.strictMode,
//     this.showCorrections,
//     this.scoreNotification,
//   });

//   /// ✅ Factory constructor for GraphQL-style JSON parsing
//   factory Exam.fromJson(Map<String, dynamic> json) {
//     return Exam(
//       id: json['id'],
//       name: json['name'],
//       instruction: json['instruction'],
//       subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
//       examGroup: json['examGroup'] != null ? ExamGroup.fromJson(json['examGroup']) : null,
//       examSessionIds: (json['examSessionIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
//       startDate: json['startDate'],
//       endDate: json['endDate'],
//       isOffline: json['isOffline'],
//       classes: (json['classes'] as List<dynamic>?)?.map((c) => ExamClass.fromJson(c)).toList(),
//       shuffleCBTQuestions: json['shuffleCBTQuestions'],
//       showCalculator: json['showCalculator'],
//       questionCount: json['questionCount'],
//       totalMark: json['totalMark'],
//       totalTheoryMark: json['totalTheoryMark'],
//       duration: json['duration'],
//       ineligibleStudentIds: (json['ineligibleStudentIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
//       questions: (json['questions'] as List<dynamic>?)?.map((q) => ExamQuestion.fromJson(q)).toList(),
//       pin: json['pin'],
//       enabled: json['enabled'],
//       showScoreOnSubmission: json['showScoreOnSubmission'],
//       strictMode: json['strictMode'],
//       showCorrections: json['showCorrections'],
//       scoreNotification: json['scoreNotification'],
//     );
//   }
// }

/// **📌 Separate Class for Map-based Parsing (with Default Values)**
class ExamDetailed {
  String id;
  final String name;
  final String instruction;
  final Subject subject;
  final ExamGroupModel examGroup;
  final List<String> examSessionIds;
  final String startDate;
  final String endDate;
  final bool isOffline;
  final List<ExamClass> classes;
  final bool shuffleCBTQuestions;
  final bool showCalculator;
  final int questionCount;
  // final int totalMark;
  // final int totalTheoryMark;
  final double totalMark;
  final double totalTheoryMark;
  final int duration;
  final List<String> ineligibleStudentIds;
  final List<ExamQuestion> questions;
  final String? pin;
  final bool enabled;
  final bool showScoreOnSubmission;
  final bool strictMode;
  final bool showCorrections;
  final bool scoreNotification;
  final List<ExamSessionModel> examSessions;

  ExamDetailed({
    required this.id,
    required this.name,
    required this.instruction,
    required this.subject,
    required this.examGroup,
    required this.examSessionIds,
    required this.startDate,
    required this.endDate,
    required this.isOffline,
    required this.classes,
    required this.shuffleCBTQuestions,
    required this.showCalculator,
    required this.questionCount,
    required this.totalMark,
    required this.totalTheoryMark,
    required this.duration,
    required this.ineligibleStudentIds,
    required this.questions,
    required this.pin,
    required this.enabled,
    required this.showScoreOnSubmission,
    required this.strictMode,
    required this.showCorrections,
    required this.scoreNotification,
    required this.examSessions,
  });

  factory ExamDetailed.fromMap(Map<String, dynamic> json) {
    try {
      log('my json details $json');
      return ExamDetailed(
        id: json['id'] ?? '',
        // The 'name' field is at the end of your JSON, not where you're expecting it
        name: json['name'] ?? '',
        instruction: json['instruction'] ?? '',
        subject: Subject.fromJson(json['subject'] ?? {}),
        examGroup: ExamGroupModel.fromJson(json['examGroup'] ?? {}),
        examSessionIds: List<String>.from(json['examSessionIds'] ?? []),
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        isOffline: json['isOffline'] ?? false,
        classes: (json['classes'] as List<dynamic>?)
                ?.map((c) => ExamClass.fromJson(c))
                .toList() ??
            [],
        shuffleCBTQuestions: json['shuffleCBTQuestions'] ?? false,
        showCalculator: json['showCalculator'] ?? false,
        questionCount: json['questionCount'] ?? 0,
        // Handle possible null values with conditional logic
        totalMark: json['totalMark'] != null
            ? (json['totalMark'] as num).toDouble()
            : 0.0,
        totalTheoryMark: json['totalTheoryMark'] != null
            ? (json['totalTheoryMark'] as num).toDouble()
            : 0.0,
        duration:
            json['duration'] != null ? (json['duration'] as num).toInt() : 0,
        ineligibleStudentIds:
            List<String>.from(json['ineligibleStudentIds'] ?? []),
        questions: (json['questions'] as List<dynamic>?)
                ?.map((q) => ExamQuestion.fromJson(q))
                .toList() ??
            [],
        // THIS IS THE CRITICAL FIX - allowing pin to be null
        pin: json['pin'], // This correctly handles null values
        enabled: json['enabled'] ?? false,
        showScoreOnSubmission: json['showScoreOnSubmission'] ?? false,
        strictMode: json['strictMode'] ?? false,
        showCorrections: json['showCorrections'] ?? false,
        scoreNotification: json['scoreNotification'] ?? false,
        examSessions: (json['examSessions'] as List?)
                ?.map((session) => ExamSessionModel.fromJson(session))
                .toList() ??
            [],
      );
    } catch (e, stackTrace) {
      log('Error parsing ExamDetailed: $e');
      log('Stack trace: $stackTrace'); // Adding stack trace to help debugging
      throw Exception('Failed to parse ExamDetailed: $e');
    }
  }

  // /// ✅ Factory constructor for Map-based parsing (with default values)
  // factory ExamDetailed.fromMap(Map<String, dynamic> json) {
  //   log('my json details $json');
  //   return ExamDetailed(
  //     id: json['id'] ?? '',
  //     name: json['name'] ?? '',
  //     instruction: json['instruction'] ?? '',
  //     subject: Subject.fromJson(json['subject'] ?? {}),
  //     examGroup: ExamGroupModel.fromJson(json['examGroup'] ?? {}),
  //     examSessionIds: List<String>.from(json['examSessionIds'] ?? []),
  //     startDate: json['startDate'] ?? '',
  //     endDate: json['endDate'] ?? '',
  //     isOffline: json['isOffline'] ?? false,
  //     classes: (json['classes'] as List<dynamic>?)
  //             ?.map((c) => ExamClass.fromJson(c))
  //             .toList() ??
  //         [],
  //     shuffleCBTQuestions: json['shuffleCBTQuestions'] ?? false,
  //     showCalculator: json['showCalculator'] ?? false,
  //     questionCount: json['questionCount'] ?? 0,
  //     // totalMark: json['totalMark'] ?? 0,
  //     // totalTheoryMark: json['totalTheoryMark'] ?? 0,
  //     totalMark: (json['totalMark'] as num).toDouble(), // Ensure conversion
  //     totalTheoryMark:
  //         (json['totalTheoryMark'] as num).toDouble(), // Ensure conversion
  //     // duration: json['duration'] ?? 0,
  //     duration: (json['duration'] as num).toInt(), // ✅ FIX HERE

  //     ineligibleStudentIds:
  //         List<String>.from(json['ineligibleStudentIds'] ?? []),
  //     questions: (json['questions'] as List<dynamic>?)
  //             ?.map((q) => ExamQuestion.fromJson(q))
  //             .toList() ??
  //         [],
  //     // pin: json['pin'] ?? '',
  //     pin: json['pin'] != null ? json['pin'] ?? '' : null,
  //     enabled: json['enabled'] ?? false,
  //     showScoreOnSubmission: json['showScoreOnSubmission'] ?? false,
  //     strictMode: json['strictMode'] ?? false,
  //     showCorrections: json['showCorrections'] ?? false,
  //     scoreNotification: json['scoreNotification'] ?? false,
  //     examSessions: (json['examSessions'] as List?)
  //             ?.map((session) => ExamSessionModel.fromJson(session))
  //             .toList() ??
  //         [],
  //     // examSessions: (json['examSessions'] as List<dynamic>?)
  //     //         ?.map((session) => ExamSessionModel.fromJson(session))
  //     //         .toList() ??
  //     //     [],
  //   );
  // }
}

// class ExamClass {
//   final SubjectDetails subjectDetails;

//   ExamClass({required this.subjectDetails});

//   factory ExamClass.fromJson(Map<String, dynamic> json) {
//     return ExamClass(
//       subjectDetails: SubjectDetails.fromJson(json['subjectDetails'] ?? {}),
//     );
//   }
// }

// class SubjectDetails {
//   final String id;
//   final String name;
//   final Teacher teacher;

//   SubjectDetails({required this.id, required this.name, required this.teacher});

//   factory SubjectDetails.fromJson(Map<String, dynamic> json) {
//     return SubjectDetails(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       teacher: Teacher.fromJson(json['teacher'] ?? {}),
//     );
//   }
// }

// class Teacher {
//   final String id;

//   Teacher({required this.id});

//   factory Teacher.fromJson(Map<String, dynamic> json) {
//     return Teacher(
//       id: json['id'] ?? '',
//     );
//   }
// }
class ExamSessionModel {
  final String id;
  final String timeStarted;
  final double totalScore;
  final int timeLeft;
  final String lastSavedAt;

  ExamSessionModel({
    required this.id,
    required this.timeStarted,
    required this.totalScore,
    required this.timeLeft,
    required this.lastSavedAt,
  });

  factory ExamSessionModel.fromJson(Map<String, dynamic> json) {
    return ExamSessionModel(
      id: json['id'] ?? '',
      timeStarted: json['timeStarted'] ?? '',
      totalScore: (json['totalScore'] is int)
          ? (json['totalScore'] as int).toDouble()
          : (json['totalScore'] as num?)?.toDouble() ?? 0.0,
      timeLeft: (json['timeLeft'] is double)
          ? (json['timeLeft'] as double).toInt()
          : (json['timeLeft'] as num?)?.toInt() ?? 0,
      // timeLeft: json['timeLeft'] ?? 0,
      lastSavedAt: json['lastSavedAt'] ?? '',
    );
  }
}

class ExamGroupModel {
  final String id;
  final String name;
  final String category;
  final String? description;
  final bool groupEnabled;
  final String sessionId;
  final String termId;
  final DateTime updatedAt;
  final List<String> examIds;
  final List<ExamClass> classes;
  final ExamTerm term;
  final ExamSession session;
  final int examCount;

  ExamGroupModel(
      {required this.id,
      required this.name,
      required this.category,
      this.description,
      required this.groupEnabled,
      required this.sessionId,
      required this.termId,
      required this.updatedAt,
      required this.examIds,
      required this.classes,
      required this.term,
      required this.session,
      required this.examCount});

  factory ExamGroupModel.fromJson(Map<String, dynamic> json) {
    log('my json $json');
    return ExamGroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'],
      groupEnabled: json['groupEnabled'] ?? false,
      sessionId: json['sessionId'] ?? '',
      termId: json['termId'] ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      examIds: List<String>.from(json['examIds'] ?? []),
      classes: (json['classes'] as List<dynamic>?)
              ?.map((c) => ExamClass.fromJson(c))
              .toList() ??
          [],
      term: ExamTerm.fromJson(json['term'] ?? {}),
      session: ExamSession.fromJson(json['session'] ?? {}),
      examCount: json['examCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'groupEnabled': groupEnabled,
      'sessionId': sessionId,
      'termId': termId,
      'updatedAt': updatedAt.toIso8601String(),
      'examIds': examIds,
      // 'classes': classes.map((c) => c.toJson()).toList(),
      // 'term': term.toJson(),
      // 'session': session.toJson(),
    };
  }
}

class ExamClass {
  final String id;
  final String name;
  final List<SubjectDetail> subjectDetails;
  final ClassGroup classGroup;

  ExamClass({
    required this.id,
    required this.name,
    required this.subjectDetails,
    required this.classGroup,
  });

  factory ExamClass.fromJson(Map<String, dynamic> json) {
    return ExamClass(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subjectDetails: (json['subjectDetails'] as List<dynamic>?)
              ?.map((s) => SubjectDetail.fromJson(s))
              .toList() ??
          [],
      classGroup: ClassGroup.fromJson(json['classGroup'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjectDetails': subjectDetails.map((s) => s.toJson()).toList(),
      'classGroup': classGroup.toJson(),
    };
  }
}

class SubjectDetail {
  final String id;
  final String name;
  final Teacher? teacher;
  // final User? teacher;
  SubjectDetail({
    required this.id,
    required this.name,
    this.teacher,
  });

  factory SubjectDetail.fromJson(Map<String, dynamic> json) {
    log('gggggg$json');
    return SubjectDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      teacher:
          json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // 'teacher': teacher?.toJson(),
    };
  }

 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectDetail &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Teacher {
  final String id;
  final String? firstName;
  final String? lastName;
  final User? user;

  Teacher({
    required this.id,
    this.firstName,
    this.lastName,
    this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

// class ClassGroup {
//   final String id;
//   final String name;

//   ClassGroup({required this.id, required this.name});

//   factory ClassGroup.fromJson(Map<String, dynamic> json) {
//     return ClassGroup(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }

class ExamTerm {
  final String id;
  final String name;

  ExamTerm({required this.id, required this.name});

  factory ExamTerm.fromJson(Map<String, dynamic> json) {
    return ExamTerm(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// class ExamSession {
//   final String id;
//   final String session;

//   ExamSession({required this.id, required this.session});

//   factory ExamSession.fromJson(Map<String, dynamic> json) {
//     return ExamSession(
//       id: json['id'] ?? '',
//       session: json['session'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'session': session,
//     };
//   }
// }

// class ExamSessionsResponse {
//   final List<ExamSessionData> data;
//   final Meta meta;

//   ExamSessionsResponse({required this.data, required this.meta});

//   factory ExamSessionsResponse.fromJson(Map<String, dynamic> json) {
//     return ExamSessionsResponse(
//       data: (json['data'] as List)
//           .map((e) => ExamSessionData.fromJson(e))
//           .toList(),
//       meta: Meta.fromJson(json['meta']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'data': data.map((e) => e.toJson()).toList(),
//       'meta': meta.toJson(),
//     };
//   }
// }

class ExamSessionData {
  final String id;
  final String studentId;
  final Student student;
  final String examId;
  final Exam exam;
  final String timeStarted;
  final String timeLeft;
  final String expectedEndTime;
  final String lastSavedAt;
  final String status;
  final double totalScore;
  final String createdAt;
  final String updatedAt;

  ExamSessionData({
    required this.id,
    required this.studentId,
    required this.student,
    required this.examId,
    required this.exam,
    required this.timeStarted,
    required this.timeLeft,
    required this.expectedEndTime,
    required this.lastSavedAt,
    required this.status,
    required this.totalScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExamSessionData.fromJson(Map<String, dynamic> json) {
    log('incomingsession $json');
    return ExamSessionData(
      id: json['id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      student: Student.fromJson(json['student'] ?? {}),
      examId: json['examId']?.toString() ?? '',
      exam: Exam.fromJson(json['exam'] ?? {}),
      timeStarted: json['timeStarted']?.toString() ?? '',
      // timeLeft: json['timeLeft']?.toString() ?? '',
      timeLeft: json['timeLeft'] != null ? json['timeLeft'].toString() : '',
      expectedEndTime: json['expectedEndTime']?.toString() ?? '',
      lastSavedAt: json['lastSavedAt']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalScore: _parseDouble(json['totalScore']),
      // totalScore: json['totalScore'] == null
      //     ? 0.0
      //     : (json['totalScore'] is int
      //         ? (json['totalScore'] as int).toDouble()
      //         : json['totalScore'] as double),
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'student': student.toJson(),
      'examId': examId,
      //'exam': exam.toJson(), // Added exam.toJson()
      'timeStarted': timeStarted,
      'timeLeft': timeLeft,
      'expectedEndTime': expectedEndTime,
      'lastSavedAt': lastSavedAt,
      'status': status,
      'totalScore': totalScore,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0; // Default value for unexpected types
  }
}

class Student {
  final String id;
  final String spaceId;
  final String role;
  final User user;

  Student({
    required this.id,
    required this.spaceId,
    required this.role,
    required this.user,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      spaceId: json['spaceId']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceId': spaceId,
      'role': role,
      'user': user.toJson(),
    };
  }

  static empty() {}
}

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       firstName: json['firstName']?.toString() ?? '',
//       lastName: json['lastName']?.toString() ?? '',
//       username: json['username']?.toString() ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'firstName': firstName,
//       'lastName': lastName,
//       'username': username,
//     };
//   }
// }

class ExamGroup {
  final String id;

  ExamGroup({required this.id});

  factory ExamGroup.fromJson(Map<String, dynamic> json) {
    return ExamGroup(
      id: json['id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class Meta {
  final bool hasMore;
  final String nextCursor;
  final int pageSize;

  Meta(
      {required this.hasMore,
      required this.nextCursor,
      required this.pageSize});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      hasMore: json['hasMore'],
      nextCursor: json['nextCursor'],
      pageSize: json['pageSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasMore': hasMore,
      'nextCursor': nextCursor,
      'pageSize': pageSize,
    };
  }
}

class DeleteExamSessionData {
  final String id;

  DeleteExamSessionData({required this.id});

  factory DeleteExamSessionData.fromJson(Map<String, dynamic> json) {
    log('my dara $json');
    return DeleteExamSessionData(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

// class GetStudentExamSessionResponse {
//   final StudentExamSessionData getStudentExamSession;

//   GetStudentExamSessionResponse({required this.getStudentExamSession});

//   factory GetStudentExamSessionResponse.fromJson(Map<String, dynamic> json) {
//     return GetStudentExamSessionResponse(
//       getStudentExamSession:
//           StudentExamSessionData.fromJson(json['getStudentExamSession']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'getStudentExamSession': getStudentExamSession.toJson(),
//     };
//   }
// }

class StudentExamSessionData {
  final List<Correction> corrections;
  final ExamSession examSession;

  StudentExamSessionData(
      {required this.corrections, required this.examSession});

  // factory StudentExamSessionData.fromJson(Map<String, dynamic> json) {
  //   return StudentExamSessionData(
  //     // corrections: (json['corrections'] as List)
  //     //     .map((e) => Correction.fromJson(e))
  //     //     .toList(),
  //     corrections: (json['corrections'] is List)
  //         ? (json['corrections'] as List)
  //             .map((e) => Correction.fromJson(e as Map<String, dynamic>))
  //             .toList()
  //         : [],

  //     examSession: ExamSession.fromJson(json['examSession']),
  //   );
  // }

  factory StudentExamSessionData.fromJson(Map<String, dynamic> json) {
    log('StudentExamSessionData JSON: $json');
    return StudentExamSessionData(
      corrections: (json['corrections'] is List)
          ? (json['corrections'] as List)
              .map((e) => Correction.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],

      // examSession: ExamSession.fromJson(json['examSession']),
      examSession: ExamSession.fromJson(
          json['examSession'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Correction {
  final String lessonNoteId;
  final String topic;
  final String questionId;
  final String question;
  final String chosenAnswer;
  final String correctAnswer;
  final bool? isCorrect;
  final int score;

  Correction({
    this.lessonNoteId = '',
    this.topic = '',
    required this.questionId,
    required this.question,
    this.chosenAnswer = '',
    this.correctAnswer = '',
    this.isCorrect,
    this.score = 0,
  });

  factory Correction.fromJson(Map<String, dynamic> json) {
    // Add extensive logging to understand the JSON structure
    print('Correction JSON Input: $json');

    return Correction(
      lessonNoteId: _safeExtractString(json, 'lessonNoteId'),
      topic: _safeExtractString(json, 'topic'),
      questionId: _safeExtractString(json, 'questionId'),
      question: _safeExtractString(json, 'question'),
      chosenAnswer: _safeExtractString(json, 'chosenAnswer'),
      correctAnswer: _safeExtractString(json, 'correctAnswer'),
      isCorrect: _parseIsCorrect(json['isCorrect']),
      score: _parseScore(json['score']),
    );
  }

  static String _safeExtractString(Map<String, dynamic> json, String key) {
    dynamic value = json[key];
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) return value['content']?.toString() ?? value.toString();
    if (value is List) return value.toString(); // This could be the issue
    if (value is num) return value.toString();
    return value.toString();
  }

  static bool? _parseIsCorrect(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;

    // Try to convert string to bool
    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return null;
  }

  static int _parseScore(dynamic value) {
    if (value == null) return 0;

    // Extensive logging
    print('Parsing score: $value (${value.runtimeType})');

    // Handle various possible types
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;

    return 0;
  }
}
// class Correction {
//   final String lessonNoteId;
//   final String topic;
//   final String questionId;
//   final String question;
//   final String chosenAnswer;
//   final String correctAnswer;
//   final bool isCorrect;
//   final int score;

//   Correction({
//     required this.lessonNoteId,
//     required this.topic,
//     required this.questionId,
//     required this.question,
//     required this.chosenAnswer,
//     required this.correctAnswer,
//     required this.isCorrect,
//     required this.score,
//   });

//   factory Correction.fromJson(Map<String, dynamic> json) {
//     log('mycorrection $json');

//     return Correction(
//       lessonNoteId: json['lessonNoteId'] as String? ?? '',
//       topic: json['topic'] as String? ?? '',
//       questionId: json['questionId'] as String? ?? '',
//       question: json['question'] as String? ?? '',
//       chosenAnswer: _extractString(json['chosenAnswer']),

//       correctAnswer: Correction._extractString(json['correctAnswer']),
//       isCorrect: json['isCorrect'] as bool? ?? false,

//       score: _parseScore(json['score']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'lessonNoteId': lessonNoteId,
//       'topic': topic,
//       'questionId': questionId,
//       'question': question,
//       'chosenAnswer': chosenAnswer,
//       'correctAnswer': correctAnswer,
//       'isCorrect': isCorrect,
//       'score': score,
//     };
//   }

//   static String _extractString(dynamic value) {
//     if (value == null) return '';
//     if (value is String) return value;
//     if (value is int || value is double) return value.toString();
//     if (value is Map<String, dynamic> && value.containsKey('content')) {
//       return _extractString(value['content']);
//     }
//     return value.toString();
//   }

//   static int _parseScore(dynamic value) {
//     if (value == null) return 0;
//     if (value is int) return value;
//     if (value is String) return int.tryParse(value) ?? 0;
//     if (value is double) return value.toInt();
//     return 0;
//   }
// }

class ExamDataSubmission {
  final String id;
  final String name;
  final Subject subject;
  final ExamGroup examGroup;
  final String startDate;
  final String endDate;
  final int questionCount;
  // final double totalMark;
  final int totalMark;
  final double totalTheoryMark;
  final int duration;
  final bool showCorrections;
  final bool showScoreOnSubmission;
  final List<ExamSession> examSessions;

  ExamDataSubmission({
    required this.id,
    required this.name,
    required this.subject,
    required this.examGroup,
    required this.startDate,
    required this.endDate,
    required this.questionCount,
    required this.totalMark,
    required this.totalTheoryMark,
    required this.duration,
    required this.showCorrections,
    required this.showScoreOnSubmission,
    required this.examSessions,
  });

  factory ExamDataSubmission.fromJson(Map<String, dynamic> json) {
    log('hhhyuhyhy $json');
    return ExamDataSubmission(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subject: Subject.fromJson(json['subject'] ?? {}),
      examGroup: ExamGroup.fromJson(json['examGroup'] ?? {}),
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      questionCount: json['questionCount'] ?? 0,
      totalMark: (json['totalMark'] as num?)?.toInt() ?? 0,
      // totalMark: (json['totalMark'] as num?)?.toDouble() ?? 0.0,
      totalTheoryMark: (json['totalTheoryMark'] as num?)?.toDouble() ?? 0.0,
      duration: json['duration'] ?? 0,
      showCorrections: json['showCorrections'] ?? false,
      showScoreOnSubmission: json['showScoreOnSubmission'] ?? false,
      examSessions: (json['examSessions'] as List?)
              ?.map((e) => ExamSession.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class GetStudentExamSession {
  final List<LessonNoteBreakdown>? examLessonNoteBreakdown;
  final ExamSessionTwo? examSession;

  GetStudentExamSession({this.examLessonNoteBreakdown, this.examSession});

  factory GetStudentExamSession.fromJson(Map<String, dynamic> json) {
    return GetStudentExamSession(
      examLessonNoteBreakdown: (json['examLessonNoteBreakdown'] as List?)
          ?.map((e) => LessonNoteBreakdown.fromJson(e))
          .toList(),
      examSession: json['examSession'] != null
          ? ExamSessionTwo.fromJson(json['examSession'])
          : null,
    );
  }
}

class LessonNoteBreakdown {
  final String? lessonNoteId;
  final String? topic;
  final int? totalQuestionForTopic;
  final int? totalAnsweredForTopic;
  final double? percentageBreakdown;

  LessonNoteBreakdown({
    this.lessonNoteId,
    this.topic,
    this.totalQuestionForTopic,
    this.totalAnsweredForTopic,
    this.percentageBreakdown,
  });

  factory LessonNoteBreakdown.fromJson(Map<String, dynamic> json) {
    double? safePercentage;

    final raw = json['percentageBreakdown'];

    if (raw is num) {
      final parsed = raw.toDouble();
      if (!parsed.isNaN && parsed.isFinite) {
        safePercentage = parsed;
      }
    }
    log('rerecfdddfdr $json');
    return LessonNoteBreakdown(
      lessonNoteId: json['lessonNoteId']?.toString(),
      topic: json['topic']?.toString(),
      totalQuestionForTopic: json['totalQuestionForTopic'] is int
          ? json['totalQuestionForTopic']
          : int.tryParse(json['totalQuestionForTopic']?.toString() ?? ''),
      totalAnsweredForTopic: json['totalAnsweredForTopic'] is int
          ? json['totalAnsweredForTopic']
          : int.tryParse(json['totalAnsweredForTopic']?.toString() ?? ''),
      percentageBreakdown: safePercentage,
    );
  }
}

class ExamSessionTwo {
  final double? timeLeft;
  final String? timeStarted;
  final String? lastSavedAt;
  final String? expectedEndTime; // <-- Add this
  final double? totalScore;
  final String? status;
  final Exam? exam;
  final Student? student;

  ExamSessionTwo({
    this.timeLeft,
    this.timeStarted,
    this.lastSavedAt,
    this.expectedEndTime, // <-- Add this
    this.totalScore,
    this.status,
    this.exam,
    this.student,
  });

  factory ExamSessionTwo.fromJson(Map<String, dynamic> json) {
    return ExamSessionTwo(
      timeLeft: (json['timeLeft'] as num?)?.toDouble(),
      timeStarted: json['timeStarted'],
      lastSavedAt: json['lastSavedAt'],
      expectedEndTime: json['expectedEndTime'], // <-- Add this
      totalScore: (json['totalScore'] as num?)?.toDouble(),
      status: json['status'],
      exam: json['exam'] != null ? Exam.fromJson(json['exam']) : null,
      student: json['student'] != null ? Student.fromJson(json['student']) : null,
    );
  }
}


class GetExamSessionsSummaryResponse {
  final ExamSessionBreakdown examSessionBreakdown;
  final List<ExamLessonNoteBreakdown> examLessonNoteBreakdown;

  GetExamSessionsSummaryResponse({
    required this.examSessionBreakdown,
    required this.examLessonNoteBreakdown,
  });

  factory GetExamSessionsSummaryResponse.fromJson(Map<String, dynamic> json) {
    return GetExamSessionsSummaryResponse(
      examSessionBreakdown:
          ExamSessionBreakdown.fromJson(json['examSessionBreakdown']),
      examLessonNoteBreakdown: (json['examLessonNoteBreakdown'] as List)
          .map((e) => ExamLessonNoteBreakdown.fromJson(e))
          .toList(),
    );
  }
}
class ExamSessionBreakdown {
  final double averageDuration;
  final double averageScore;
  final int totalSessions;
  final List<ExamSummarySession> highestSession;
  final List<ExamSummarySession> lowestSession;

  ExamSessionBreakdown({
    required this.averageDuration,
    required this.averageScore,
    required this.totalSessions,
    required this.highestSession,
    required this.lowestSession,
  });



factory ExamSessionBreakdown.fromJson(Map<String, dynamic> json) {
  return ExamSessionBreakdown(
    averageDuration: (json['averageDuration'] as num?)?.toDouble() ?? 0,
    averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0,
    totalSessions: json['totalSessions'] ?? 0,
    highestSession: (json['highestSession'] as List<dynamic>?)
            ?.map((e) => ExamSummarySession.fromJson(e))
            .toList() ??
        [],
    lowestSession: (json['lowestSession'] as List<dynamic>?)
            ?.map((e) => ExamSummarySession.fromJson(e))
            .toList() ??
        [],
  );
}
}

class ExamLessonNoteBreakdown {
  final double percentageBreakdown;
  final String topic;
  final int totalAnsweredForTopic;
  final int totalQuestionForTopic;

  ExamLessonNoteBreakdown({
    required this.percentageBreakdown,
    required this.topic,
    required this.totalAnsweredForTopic,
    required this.totalQuestionForTopic,
  });

  factory ExamLessonNoteBreakdown.fromJson(Map<String, dynamic> json) {
    return ExamLessonNoteBreakdown(
      percentageBreakdown: (json['percentageBreakdown'] as num).toDouble(),
      topic: json['topic'],
      totalAnsweredForTopic: json['totalAnsweredForTopic'],
      totalQuestionForTopic: json['totalQuestionForTopic'],
    );
  }
}

class ExamSummarySession {
  final ExamStudent student;
  final double? totalScore;
  final Exam? exam;

 ExamSummarySession({
    required this.student,
    this.totalScore,
    this.exam,
  });

  factory ExamSummarySession.fromJson(Map<String, dynamic> json) {
    return ExamSummarySession(
      student: ExamStudent.fromJson(json['student']),
      totalScore: json['totalScore'] != null
          ? (json['totalScore'] as num).toDouble()
          : null,
      exam: json['exam'] != null ? Exam.fromJson(json['exam']) : null,
    );
  }
}

class ExamStudent {
 final User user;
  final String id;
  final ClassModel? classInfo;

  ExamStudent({
     required this.user,
    required this.id,
    this.classInfo,
  });

  factory ExamStudent.fromJson(Map<String, dynamic> json) {
    return ExamStudent(
     user: User.fromJson(json['user']),
      id: json['id'],
      classInfo: json['class'] != null
          ? ClassModel.fromJson(json['class'])
          : null,
    );
  }
}