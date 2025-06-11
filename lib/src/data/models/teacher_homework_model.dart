// // import 'package:cloudnottapp2/src/data/models/homework_model.dart';

// // class TeacherHomeworkModel {
// //   TeacherHomeworkModel({
// //     required this.homeworkDetails,
// //     required this.submissions,
// //   });

// //   final HomeworkModel homeworkDetails; // Reuse the existing model
// //   final List<SubmittedHomework> submissions;
// // }
// import 'dart:developer';

// class GetExamGroupsResponse {
//   final List<ExamTeacherGroup> data;

//   GetExamGroupsResponse({required this.data});

//   factory GetExamGroupsResponse.fromJson(Map<String, dynamic> json) {
//     return GetExamGroupsResponse(
//       data: (json['data'] as List)
//           .map((e) => ExamTeacherGroup.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'data': data.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class ExamTeacherGroup {
//   final String id;
//   final String name;
//   final ExamSession session;
//   final String category;
//   final List<ClassInfo> classes;
//   final String sessionId;
//   final String termId;
//   final ExamTerm term;
//   final List<String> examIds;
//   final bool groupEnabled;
//   final int examCount;

//   ExamTeacherGroup({
//     required this.id,
//     required this.name,
//     required this.session,
//     required this.category,
//     required this.classes,
//     required this.sessionId,
//     required this.termId,
//     required this.term,
//     required this.examIds,
//     required this.groupEnabled,
//     required this.examCount,
//   });

//   factory ExamTeacherGroup.fromJson(Map<String, dynamic> json) {
//     log('examgropu $json');
//     return ExamTeacherGroup(
//       id: json['id'],
//       name: json['name'],
//       session: ExamSession.fromJson(json['session']),
//       category: json['category'],
//       classes:
//           (json['classes'] as List).map((e) => ClassInfo.fromJson(e)).toList(),
//       sessionId: json['sessionId'],
//       termId: json['termId'],
//       term: ExamTerm.fromJson(json['term']),
//       examIds: List<String>.from(json['examIds']),
//       groupEnabled: json['groupEnabled'],
//       examCount: json['examCount'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'session': session.toJson(),
//       'category': category,
//       'classes': classes.map((e) => e.toJson()).toList(),
//       'sessionId': sessionId,
//       'termId': termId,
//       'term': term.toJson(),
//       'examIds': examIds,
//       'groupEnabled': groupEnabled,
//       'examCount': examCount,
//     };
//   }
// }

// class ExamSession {
//   final String id;
//   final String session;
//   final String alias;
//   final String spaceId;

//   ExamSession({
//     required this.id,
//     required this.session,
//     required this.alias,
//     required this.spaceId,
//   });

//   factory ExamSession.fromJson(Map<String, dynamic> json) {
//     return ExamSession(
//       id: json['id'],
//       session: json['session'],
//       alias: json['alias'],
//       spaceId: json['spaceId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'session': session,
//       'alias': alias,
//       'spaceId': spaceId,
//     };
//   }
// }

// class ClassInfo {
//   final String classGroupId;
//   final ClassGroup classGroup;
//   final String description;
//   final String name;
//   final List<SubjectDetail> subjectDetails;

//   ClassInfo({
//     required this.classGroupId,
//     required this.classGroup,
//     required this.description,
//     required this.name,
//     required this.subjectDetails,
//   });

//   factory ClassInfo.fromJson(Map<String, dynamic> json) {
//     return ClassInfo(
//       classGroupId: json['classGroupId'],
//       classGroup: ClassGroup.fromJson(json['classGroup']),
//       description: json['description'],
//       name: json['name'],
//       subjectDetails: (json['subjectDetails'] as List)
//           .map((e) => SubjectDetail.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'classGroupId': classGroupId,
//       'classGroup': classGroup.toJson(),
//       'description': description,
//       'name': name,
//       'subjectDetails': subjectDetails.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class ClassGroup {
//   final String id;
//   final String name;

//   ClassGroup({required this.id, required this.name});

//   factory ClassGroup.fromJson(Map<String, dynamic> json) {
//     return ClassGroup(
//       id: json['id'],
//       name: json['name'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }

// class SubjectDetail {
//   final String id;
//   final String description;
//   final String name;
//   final String spaceId;

//   SubjectDetail({
//     required this.id,
//     required this.description,
//     required this.name,
//     required this.spaceId,
//   });

//   factory SubjectDetail.fromJson(Map<String, dynamic> json) {
//     return SubjectDetail(
//       id: json['id'],
//       description: json['description'],
//       name: json['name'],
//       spaceId: json['spaceId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'description': description,
//       'name': name,
//       'spaceId': spaceId,
//     };
//   }
// }

// class ExamTerm {
//   final String id;
//   final String name;
//   final String alias;
//   final String spaceId;

//   ExamTerm({
//     required this.id,
//     required this.name,
//     required this.alias,
//     required this.spaceId,
//   });

//   factory ExamTerm.fromJson(Map<String, dynamic> json) {
//     return ExamTerm(
//       id: json['id'],
//       name: json['name'],
//       alias: json['alias'],
//       spaceId: json['spaceId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'alias': alias,
//       'spaceId': spaceId,
//     };
//   }
// }
import 'dart:developer';

class ExamTeacherGroup {
  final String id;
  final String name;
  final ExamSession session;
  final String category;
  final List<ClassInfo> classes;
  final String sessionId;
  final String termId;
  final ExamTerm term;
  final List<String> examIds;
  final bool groupEnabled;
  final int examCount;

  ExamTeacherGroup({
    required this.id,
    required this.name,
    required this.session,
    required this.category,
    required this.classes,
    required this.sessionId,
    required this.termId,
    required this.term,
    required this.examIds,
    required this.groupEnabled,
    required this.examCount,
  });

  factory ExamTeacherGroup.fromJson(Map<String, dynamic> json) {
    log('Parsing ExamTeacherGroup: $json');
    return ExamTeacherGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      session: json['session'] != null
          ? ExamSession.fromJson(json['session'])
          : ExamSession.empty(),
      category: json['category'] ?? '',
      classes: (json['classes'] as List?)
              ?.map((e) => ClassInfo.fromJson(e))
              .toList() ??
          [],
      sessionId: json['sessionId'] ?? '',
      termId: json['termId'] ?? '',
      term: json['term'] != null
          ? ExamTerm.fromJson(json['term'])
          : ExamTerm.empty(),
      examIds:
          (json['examIds'] as List?)?.map((e) => e.toString()).toList() ?? [],
      groupEnabled: json['groupEnabled'] ?? false,
      examCount: json['examCount'] ?? 0,
    );
  }
}

class ExamSession {
  final String id;
  final String session;
  final String alias;
  final String spaceId;

  ExamSession({
    required this.id,
    required this.session,
    required this.alias,
    required this.spaceId,
  });

  factory ExamSession.fromJson(Map<String, dynamic> json) {
    return ExamSession(
      id: json['id'] ?? '',
      session: json['session'] ?? '',
      alias: json['alias'] ?? '',
      spaceId: json['spaceId'] ?? '',
    );
  }

  factory ExamSession.empty() =>
      ExamSession(id: '', session: '', alias: '', spaceId: '');
}

class ClassInfo {
  final String classGroupId;
  final ClassGroup classGroup;
  final String description;
  final String name;
  final List<SubjectDetail> subjectDetails;

  ClassInfo({
    required this.classGroupId,
    required this.classGroup,
    required this.description,
    required this.name,
    required this.subjectDetails,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      classGroupId: json['classGroupId'] ?? '',
      classGroup: json['classGroup'] != null
          ? ClassGroup.fromJson(json['classGroup'])
          : ClassGroup.empty(),
      description: json['description'] ?? '',
      name: json['name'] ?? '',
      subjectDetails: (json['subjectDetails'] as List?)
              ?.map((e) => SubjectDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ClassGroup {
  final String id;
  final String name;

  ClassGroup({required this.id, required this.name});

  factory ClassGroup.fromJson(Map<String, dynamic> json) {
    return ClassGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  factory ClassGroup.empty() => ClassGroup(id: '', name: '');
}

class SubjectDetail {
  final String id;
  final String description;
  final String name;
  final String spaceId;

  SubjectDetail({
    required this.id,
    required this.description,
    required this.name,
    required this.spaceId,
  });

  factory SubjectDetail.fromJson(Map<String, dynamic> json) {
    return SubjectDetail(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      name: json['name'] ?? '',
      spaceId: json['spaceId'] ?? '',
    );
  }
}

class ExamTerm {
  final String id;
  final String name;
  final String alias;
  final String spaceId;

  ExamTerm({
    required this.id,
    required this.name,
    required this.alias,
    required this.spaceId,
  });

  factory ExamTerm.fromJson(Map<String, dynamic> json) {
    return ExamTerm(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      alias: json['alias'] ?? '',
      spaceId: json['spaceId'] ?? '',
    );
  }

  factory ExamTerm.empty() =>
      ExamTerm(id: '', name: '', alias: '', spaceId: '');
}
