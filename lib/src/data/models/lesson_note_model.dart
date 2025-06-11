// import 'package:cloudnottapp2/src/data/models/lesson_class_model.dart';

// class LessonNoteModel {
//   LessonNoteModel({
//     required this.noteTopic,
//     required this.teacherImage,
//     required this.lessonClassModel,
//   });

//   final String noteTopic;
//   final String teacherImage;

//   final LessonClassModel lessonClassModel;
// }

import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/class_group.dart' show ClassGroup;
import 'package:cloudnottapp2/src/data/models/exam_session_model.dart'
    show Subject;

sealed class LessonNoteModelEntity {
  final String classGroupId;
  final String subjectId;
  final String termId;

  LessonNoteModelEntity({
    required this.classGroupId,
    required this.subjectId,
    required this.termId,
  });
}

class LessonNoteModel extends LessonNoteModelEntity {
  final String? id;
  final String status;
  final String topic;
  final String? topicCover;
  final String? week;
  final String? date;
  final String? duration;
  final String? ageGroup;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  // final String? classNote;
  final ClassNote? classNote;
  @override
  final String classGroupId;
  @override
  final String termId;
  @override
  final String subjectId;

  final ClassGroup? classGroup;
  final Subject? subject;
  final Term? term;

  LessonNoteModel({
    required this.classGroupId,
    required this.termId,
    required this.subjectId,
    this.id,
    required this.status,
    required this.topic,
    this.topicCover,
    this.week,
    this.date,
    this.duration,
    this.ageGroup,
    this.updatedAt,
    this.createdAt,
    this.classGroup,
    this.subject,
    this.classNote,
    this.term,
  }) : super(
          classGroupId: classGroupId,
          subjectId: subjectId,
          termId: termId,
        );
  factory LessonNoteModel.fromJson(Map<String, dynamic> json) {
    log('LESSON_NOTE ${json['id']}');
    return LessonNoteModel(
      id: json['id'],
      status: json['status'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      topicCover: json['topicCover'] as String?,
      classGroupId: json['classGroupId'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      termId: json['termId'] as String? ?? '',
      week: json['week'] as String?,
      date: json['date'] as String?,
      duration: json['duration'] as String?,
      classNote: json['classNote'] != null
          ? ClassNote.fromJson(
              json['classNote']) // Error here if json['classNote'] is null
          : null,
      ageGroup: json['ageGroup'] as String?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      classGroup: json['classGroup'] != null
          ? ClassGroup.fromJson(
              json['classGroup']) // Error here if json['classGroup'] is null
          : null,
      subject: json['subject'] != null
          ? Subject.fromJson(
              json['subject']) // Error here if json['subject'] is null
          : null,
      term: json['term'] != null
          ? Term.fromJson(json['term']) // Error here if json['term'] is null
          : null,
    );
  }
  // factory LessonNoteModel.fromJson(Map<String, dynamic> json) {
  //   return LessonNoteModel(
  //     id: json['id'] as String?,
  //     status: json['status'] as String? ?? '',
  //     topic: json['topic'] as String? ?? '',
  //     topicCover: json['topicCover'] as String?,
  //     classGroupId: json['classGroupId'] as String? ?? '',
  //     subjectId: json['subjectId'] as String? ?? '',
  //     termId: json['termId'] as String? ?? '',
  //     week: json['week'] as String?,
  //     date: json['date'] as String?,
  //     duration: json['duration'] as String?,
  //     classNote: json['classNote'] != null
  //         ? ClassNote.fromJson(json['classNote'])
  //         : null,
  //     // classNote: json['classNote'] as String?,
  //     ageGroup: json['ageGroup'] as String?,
  //     updatedAt: json['updatedAt'] != null
  //         ? DateTime.tryParse(json['updatedAt'])
  //         : null,
  //     createdAt: json['createdAt'] != null
  //         ? DateTime.tryParse(json['createdAt'])
  //         : null,
  //     classGroup: json['classGroup'] != null
  //         ? ClassGroup.fromJson(json['classGroup'])
  //         : null,
  //     subject:
  //         json['subject'] != null ? Subject.fromJson(json['subject']) : null,
  //     term: json['term'] != null ? Term.fromJson(json['term']) : null,
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "topic": topic,
      "topicCover": topicCover,
      "week": week,
      "date": date,
      "duration": duration,
      "ageGroup": ageGroup,
      "updatedAt": updatedAt?.toIso8601String(),
      "createdAt": createdAt?.toIso8601String(),
      "classGroupId": classGroupId,
      "subjectId": subjectId,
      "termId": termId,
      "classGroup": classGroup?.toJson(),
      // "subject": subject?.toJson(),
      "term": term?.toJson(),
    };
  }
}

class GetLessonNotesInput extends LessonNoteModelEntity {
  // final String lessonNotesInput; // get lesson notes input

  GetLessonNotesInput(
      {required super.classGroupId,
      required super.subjectId,
      required super.termId});

  Map<String, dynamic> toJson() {
    return {
      "subjectId": subjectId,
      "classGroupId": classGroupId,
      "termId": termId
    };
  }
}

class CreateLessonNoteRequest {
  final String spaceId;
  final String classGroupId;
  final String subjectId;
  final String termId;
  final List<LessonNoteData> data;

  CreateLessonNoteRequest({
    required this.spaceId,
    required this.classGroupId,
    required this.subjectId,
    required this.termId,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "spaceId": spaceId,
      "classGroupId": classGroupId,
      "subjectId": subjectId,
      "termId": termId,
      "data": data.map((item) => item.toJson()).toList(),
    };
  }
}

class LessonNoteData {
  final String? topic;
  final String? topicCover;
  final String? week;
  final String? date;
  final String? duration;
  final String? id;
  final String? ageGroup;
  final String? status;

  LessonNoteData({
    this.topic,
    this.topicCover,
    this.week,
    this.date,
    this.duration,
    this.ageGroup,
    this.status,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "topic": topic,
      "topicCover": topicCover,
      "week": week,
      "date": date,
      "duration": duration,
      "ageGroup": ageGroup,
      "status": status,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "topic": topic,
      "topicCover": topicCover,
      "week": week,
      "date": date,
      "duration": duration,
      "ageGroup": ageGroup,
      "status": status
    };
  }
}

class Term {
  final String? termId;
  final String? name;
  final String? alias;

  Term({this.termId, this.name, this.alias});

  factory Term.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Term();
    return Term(
      termId: json['termId']?.toString(),
      name: json['name']?.toString(),
      alias: json['alias']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'termId': termId,
        'name': name,
        'alias': alias,
      };
}

class ClassNote {
  final String? id;
  final String? noteId;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClassNote({
    this.id,
    this.noteId,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassNote.fromJson(Map<String, dynamic> json) {
    return ClassNote(
      id: json['id'] as String?,
      noteId: json['noteId'] as String?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noteId': noteId,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class CreateLessonNotePlanInput {
  final String lessonNoteId;
  final String lessonNotePlan;

  CreateLessonNotePlanInput({
    required this.lessonNoteId,
    required this.lessonNotePlan,
  });

  Map<String, dynamic> toJson() {
    return {
      'lessonNoteId': lessonNoteId,
      'lessonNotePlan': lessonNotePlan,
    };
  }
}

class LessonNotePlan {
  final String id;
  final String lessonNoteId;
  final String lessonNotePlan;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonNotePlan({
    required this.id,
    required this.lessonNoteId,
    required this.lessonNotePlan,
    required this.createdAt,
    required this.updatedAt,
  });

  // factory LessonNotePlan.fromJson(Map<String, dynamic> json) {
  //   return LessonNotePlan(
  //     id: json['id'] as String,
  //     lessonNoteId: json['lessonNoteId'] as String,
  //     lessonNotePlan: json['lessonNotePlan'] as String,
  //     createdAt: DateTime.parse(json['createdAt'] as String),
  //     updatedAt: DateTime.parse(json['updatedAt'] as String),
  //   );
  // }
  factory LessonNotePlan.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception("LessonNotePlan JSON data is null");
    }
    return LessonNotePlan(
      id: json['id'] as String? ?? '',
      lessonNoteId: json['lessonNoteId'] as String? ?? '',
      lessonNotePlan: json['lessonNotePlan'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Convert the object to a JSON map (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonNoteId': lessonNoteId,
      'lessonNotePlan': lessonNotePlan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
