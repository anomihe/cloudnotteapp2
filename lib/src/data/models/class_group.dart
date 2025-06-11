import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/exam_session_model.dart';

class ClassGroup {
  final String id;
  final String name;
  final String? description;
  final String spaceId;
  final List<ClassModel> classes;

  ClassGroup({
    required this.id,
    required this.name,
    this.description,
    required this.spaceId,
    required this.classes,
  });

  factory ClassGroup.fromJson(Map<String, dynamic> json) {
    log('grouted $json');
    return ClassGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      spaceId: json['spaceId'] ?? '',
      classes: (json['classes'] as List?)
              ?.map((e) => ClassModel.fromJson(e))
              .toList() ??
          [],
    );
  }
  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'spaceId': spaceId,
      'classes': classes.map((e) => e.toJson()).toList(),
    };
  }

  factory ClassGroup.empty() =>
      ClassGroup(id: '', name: '', spaceId: '', classes: []);
@override
bool operator ==(Object other) =>
    identical(this, other) ||
    other is ClassGroup &&
        runtimeType == other.runtimeType &&
        id == other.id;

@override
int get hashCode => id.hashCode;

  
  ClassGroup copyWith({
    String? id,
    String? name,
    String? description,
    String? spaceId,
    List<ClassModel>? classes,
  }) {
    return ClassGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      spaceId: spaceId ?? this.spaceId,
      classes: classes ?? this.classes,
    );
  }
}

class ClassModel {
  final String id;
  final String name;
  final int? studentCount;
  final int? subjectCount;
  final List<SubjectDetail> subjectDetails;
  final Teacher? formTeacher; // Added

  ClassModel({
    required this.id,
    required this.name,
    this.studentCount,
    this.subjectCount,
    required this.subjectDetails,
    this.formTeacher, // Added
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      studentCount: json['studentCount'],
      subjectCount: json['subjectCount'],
      subjectDetails: (json['subjectDetails'] as List?)
              ?.map((e) => SubjectDetail.fromJson(e)).toSet()
              .toList() ??
          [],
      formTeacher: json['formTeacher'] != null
          ? Teacher.fromJson(json['formTeacher'])
          : null, // Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'studentCount': studentCount,
      'subjectCount': subjectCount,
      'subjectDetails': subjectDetails.map((e) => e.toJson()).toList(),
    };
  }
    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

    ClassModel copyWith({
    String? id,
    String? name,
    int? studentCount,
    int? subjectCount,
    List<SubjectDetail>? subjectDetails,
    Teacher? formTeacher,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      studentCount: studentCount ?? this.studentCount,
      subjectCount: subjectCount ?? this.subjectCount,
      subjectDetails: subjectDetails ?? this.subjectDetails,
      formTeacher: formTeacher ?? this.formTeacher,
    );
  }
}

// class SubjectDetail {
//   final String id;
//   final String name;
//   final Teacher teacher;

//   SubjectDetail({
//     required this.id,
//     required this.name,
//     required this.teacher,
//   });

//   factory SubjectDetail.fromJson(Map<String, dynamic> json) {
//     return SubjectDetail(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       teacher: Teacher.fromJson(json['teacher'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'teacher': teacher.toJson(),
//     };
//   }
// }

// class Teacher {
//   final String id;
//   final String firstName;
//   final String lastName;
//   final String? profileImageUrl;
//   final String? email;

//   Teacher({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     this.profileImageUrl,
//     this.email,
//   });

//   factory Teacher.fromJson(Map<String, dynamic> json) {
//     return Teacher(
//       id: json['id'] ?? '',
//       firstName: json['firstName'] ?? '',
//       lastName: json['lastName'] ?? '',
//       profileImageUrl: json['profileImageUrl'],
//       email: json['email'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'profileImageUrl': profileImageUrl,
//       'email': email,
//     };
//   }
// }
