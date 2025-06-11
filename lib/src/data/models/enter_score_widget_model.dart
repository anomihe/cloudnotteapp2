import 'dart:convert';
import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/exam_session_model.dart';
import 'package:cloudnottapp2/src/data/models/lesson_note_model.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart' show Class, User;

class EnterScoreWidgetModel {
  final String imageUrl;
  final String studentName;
  final String username;
  final EnterScoreModel? scoreModel;

  final String score;
  EnterScoreWidgetModel({
    required this.imageUrl,
    required this.studentName,
    required this.username,
    required this.score,
    this.scoreModel,
  });
}

class EnterScoreModel {
  final String imageTxt;
  final String subject;
  final String totalScore;
  EnterScoreModel({
    required this.imageTxt,
    required this.subject,
    required this.totalScore,
  });
}

class BasicAssessment {
  final String? assessmentId;
  final String? name;
  final List<Term>? terms;
  final List<Component>? components;
  final List<Class>? classes;
  final String? type;

  BasicAssessment({
    this.assessmentId,
    this.name,
    this.terms,
    this.components,
    this.classes,
    this.type,
  });

  factory BasicAssessment.fromJson(Map<String, dynamic> json) {
    return BasicAssessment(
      assessmentId: json['assessmentId']?.toString(),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      terms: (json['terms'] as List<dynamic>?)
              ?.map((e) => Term.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      components: (json['components'] as List<dynamic>?)
              ?.map((e) => Component.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      classes: (json['classes'] as List<dynamic>?)
              ?.map((e) => Class.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'assessmentId': assessmentId,
        'name': name,
        'type': type,
        'terms': terms?.map((e) => e.toJson()).toList(),
        'components': components?.map((e) => e.toJson()).toList(),
        // 'classes': classes?.map((e) => e.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasicAssessment &&
          runtimeType == other.runtimeType &&
          assessmentId == other.assessmentId;

  @override
  int get hashCode => assessmentId.hashCode;
}

class Component {
  final int? percentage;
  final SubAssessment? subAssessment;

  Component({this.percentage, this.subAssessment});

  factory Component.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Component();
    }
    return Component(
      percentage: json['percentage'] as int?,
      subAssessment: json['subAssessment'] != null
          ? SubAssessment.fromJson(
              json['subAssessment'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'subAssessment': subAssessment?.toJson(),
      };
}

class SubAssessment {
  final String? name;
  final String? subAssessmentId;

  SubAssessment({this.name, this.subAssessmentId});

  factory SubAssessment.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SubAssessment();
    }
    return SubAssessment(
      name: json['name'] as String? ?? '',
      subAssessmentId: json['subAssessmentId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'subAssessmentId': subAssessmentId,
      };
}

class ScoreModel {
  final String? subAssessmentId;
  final double? score;
  final String? percentage;

  ScoreModel({
    this.subAssessmentId,
    this.score,
    this.percentage,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      subAssessmentId: json['subAssessmentId'] as String?,
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      percentage: json['percentage'] != null
          ? (json['percentage'] as String? ?? '')
          : null,
    );
  }
}

// Teacher model
class TeacherModel {
  final String? id;
  final String? firstName;
  final String? lastName;

  TeacherModel({
    this.id,
    this.firstName,
    this.lastName,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }
}

// Subject model
class SubjectModel {
  final String? id;
  final String? name;
  final TeacherModel? teacher;

  SubjectModel({
    this.id,
    this.name,
    this.teacher,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      teacher: json['teacher'] != null
          ? TeacherModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SubjectReportModel {
  final List<ScoreModel>? scores;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profileImageUrl;
  double? total;
  final SubjectModel? subject;

  SubjectReportModel({
    this.scores,
    this.userId,
    this.firstName,
    this.lastName,
    this.username,
    this.profileImageUrl,
    this.total,
    this.subject,
  });

  factory SubjectReportModel.fromJson(Map<String, dynamic> json) {
    return SubjectReportModel(
      scores: json['scores'] != null
          ? (json['scores'] as List)
              .map((e) => ScoreModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      userId: json['userId'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      username: json['username'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      total: json['total'] != null ? (json['total'] as num).toDouble() : null,
      subject: json['subject'] != null
          ? SubjectModel.fromJson(json['subject'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Main Space model class
class Space {
  final String id;
  final String name;
  final String? description;
  final String? phoneNumber;
  final String? email;
  final String? logo;
  final List<String>? categories;
  final List<String>? curriculums;
  final String? type;
  final String? currency;
  final DateTime? createdAt;
  final bool? isPaid;
  final String? currentSpaceSessionId;
  final String? currentSpaceTermId;
  final LocationInfo? locationInfo;
  final User? createdBy; // Only included if isAdmin = true
  final String alias;
  final int? classCount; // Only included if isAdmin = true
  final int? studentCount; // Only included if isAdmin = true
  final int? subjectCount; // Only included if isAdmin = true
  final int? teacherCount; // Only included if isAdmin = true
  final double? femaleTeacherPercentage; // Only included if isAdmin = true
  final int? femaleTeacherCount; // Only included if isAdmin = true
  final double? femaleStudentPercentage; // Only included if isAdmin = true
  final int? femaleStudentCount; // Only included if isAdmin = true
  final int? maleStudentCount; // Only included if isAdmin = true
  final double? maleStudentPercentage; // Only included if isAdmin = true
  final int? maleTeacherCount; // Only included if isAdmin = true
  final double? maleTeacherPercentage; // Only included if isAdmin = true
  final int? totalNumberSpaceParents; // Only included if isAdmin = true
  final List<SpaceSession>? spaceSessions;
  final SpaceSession? currentSpaceSession;
  final SpaceTerm? currentSpaceTerm;
  final List<SpaceTerm>? spaceTerms;
  final String? reportSheetType;
  final List<Social>? socials;
  final String? websiteUrl;
  final double? schoolFeesMax;
  final bool? isBoarding;
  final List<String>? facilities;
  final List<String>? languages;
  final int? contactPersonCount;
  final int? foundingYear;
  final String? colour;
  final List<String>? genders;
  final String? stamp;
  final bool? accountingPinIsSet;

  Space({
    required this.id,
    required this.name,
    this.description,
    this.phoneNumber,
    this.email,
    this.logo,
    this.categories,
    this.curriculums,
    this.type,
    this.currency,
    this.createdAt,
    this.isPaid,
    this.currentSpaceSessionId,
    this.currentSpaceTermId,
    this.locationInfo,
    this.createdBy,
    required this.alias,
    this.classCount,
    this.studentCount,
    this.subjectCount,
    this.teacherCount,
    this.femaleTeacherPercentage,
    this.femaleTeacherCount,
    this.femaleStudentPercentage,
    this.femaleStudentCount,
    this.maleStudentCount,
    this.maleStudentPercentage,
    this.maleTeacherCount,
    this.maleTeacherPercentage,
    this.totalNumberSpaceParents,
    this.spaceSessions,
    this.currentSpaceSession,
    this.currentSpaceTerm,
    this.spaceTerms,
    this.reportSheetType,
    this.socials,
    this.websiteUrl,
    this.schoolFeesMax,
    this.isBoarding,
    this.facilities,
    this.languages,
    this.contactPersonCount,
    this.foundingYear,
    this.colour,
    this.genders,
    this.stamp,
    this.accountingPinIsSet,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    log('space $json');
    return Space(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      logo: json['logo'],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      curriculums: json['curriculums'] != null
          ? List<String>.from(json['curriculums'])
          : null,
      type: json['type'],
      currency: json['currency'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      isPaid: json['isPaid'],
      currentSpaceSessionId: json['currentSpaceSessionId'],
      currentSpaceTermId: json['currentSpaceTermId'],
      locationInfo: json['locationInfo'] != null
          ? LocationInfo.fromJson(json['locationInfo'])
          : null,
      createdBy:
          json['createdBy'] != null ? User.fromJson(json['createdBy']) : null,
      alias: json['alias'],
      classCount: json['classCount'] != null
          ? int.tryParse(json['classCount'].toString())
          : null,
      studentCount: json['studentCount'] != null
          ? int.tryParse(json['studentCount'].toString())
          : null,
      subjectCount: json['subjectCount'] != null
          ? int.tryParse(json['subjectCount'].toString())
          : null,
      teacherCount: json['teacherCount'] != null
          ? int.tryParse(json['teacherCount'].toString())
          : null,
      femaleTeacherPercentage: json['femaleTeacherPercentage'] != null
          ? double.tryParse(json['femaleTeacherPercentage'].toString())
          : null,
      femaleTeacherCount: json['femaleTeacherCount'] != null
          ? int.tryParse(json['femaleTeacherCount'].toString())
          : null,
      femaleStudentPercentage: json['femaleStudentPercentage'] != null
          ? double.tryParse(json['femaleStudentPercentage'].toString())
          : null,
      femaleStudentCount: json['femaleStudentCount'] != null
          ? int.tryParse(json['femaleStudentCount'].toString())
          : null,
      maleStudentCount: json['maleStudentCount'] != null
          ? int.tryParse(json['maleStudentCount'].toString())
          : null,
      maleStudentPercentage: json['maleStudentPercentage'] != null
          ? double.tryParse(json['maleStudentPercentage'].toString())
          : null,
      maleTeacherCount: json['maleTeacherCount'] != null
          ? int.tryParse(json['maleTeacherCount'].toString())
          : null,
      maleTeacherPercentage: json['maleTeacherPercentage'] != null
          ? double.tryParse(json['maleTeacherPercentage'].toString())
          : null,
      totalNumberSpaceParents: json['totalNumberSpaceParents'] != null
          ? int.tryParse(json['totalNumberSpaceParents'].toString())
          : null,
      spaceSessions: json['spaceSessions'] != null
          ? (json['spaceSessions'] as List)
              .map((i) => SpaceSession.fromJson(i))
              .toList()
          : null,
      currentSpaceSession: json['currentSpaceSession'] != null
          ? SpaceSession.fromJson(json['currentSpaceSession'])
          : null,
      currentSpaceTerm: json['currentSpaceTerm'] != null
          ? SpaceTerm.fromJson(json['currentSpaceTerm'])
          : null,
      spaceTerms: json['spaceTerms'] != null
          ? (json['spaceTerms'] as List)
              .map((i) => SpaceTerm.fromJson(i))
              .toList()
          : null,
      reportSheetType: json['reportSheetType'],
      socials: json['socials'] != null
          ? (json['socials'] as List).map((i) => Social.fromJson(i)).toList()
          : null,
      websiteUrl: json['websiteUrl'],
      schoolFeesMax: json['schoolFeesMax'] != null
          ? double.tryParse(json['schoolFeesMax'].toString())
          : null,
      isBoarding: json['isBoarding'],
      facilities: json['facilities'] != null
          ? List<String>.from(json['facilities'])
          : null,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      contactPersonCount: json['contactPersonCount'] != null
          ? int.tryParse(json['contactPersonCount'].toString())
          : null,
      foundingYear: json['foundingYear'] != null
          ? int.tryParse(json['foundingYear'].toString())
          : null,
      colour: json['colour'],
      genders:
          json['genders'] != null ? List<String>.from(json['genders']) : null,
      stamp: json['stamp'],
      accountingPinIsSet: json['accountingPinIsSet'],
    );
  }
}

class LocationInfo {
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final double? longitude;
  final double? latitude;

  LocationInfo({
    this.country,
    this.state,
    this.city,
    this.address,
    this.longitude,
    this.latitude,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      country: json['country'],
      state: json['state'],
      city: json['city'],
      address: json['address'],
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
    );
  }
}

// class User {
//   final String firstName;
//   final String lastName;
//   final String id;

//   User({
//     required this.firstName,
//     required this.lastName,
//     required this.id,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       id: json['id'],
//     );
//   }
// }

// SpaceSession model
class SpaceSession {
  final String alias;
  final String id;
  final String session;

  SpaceSession({
    required this.alias,
    required this.id,
    required this.session,
  });

  factory SpaceSession.fromJson(Map<String, dynamic> json) {
    return SpaceSession(
      alias: json['alias'],
      id: json['id'],
      session: json['session'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
  SpaceSession.empty()
      : id = '',
        session = '',
        alias = '';
      
}

class SpaceTerm {
  final String alias;
  final String id;
  final String name;

  SpaceTerm({
    required this.alias,
    required this.id,
    required this.name,
  });

  factory SpaceTerm.fromJson(Map<String, dynamic> json) {
    return SpaceTerm(
      alias: json['alias'],
      id: json['id'],
      name: json['name'],
    );
  }

  static empty() {}
}

// Social model
class Social {
  final String name;
  final String url;

  Social({
    required this.name,
    required this.url,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      name: json['name'],
      url: json['url'],
    );
  }
}

class ClassData {
  final List<Student>? students;
  final int? studentCount;

  ClassData({this.students, this.studentCount});

  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      students: json['students'] != null
          ? (json['students'] as List).map((e) => Student.fromJson(e)).toList()
          : null,
      studentCount: json['studentCount'] != null
          ? int.tryParse(json['studentCount'].toString())
          : null,
    );
  }
}

// Student data
class Student {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final List<Parent>? parents;
  final User? user;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Student({
    required this.id,
    this.firstName,
    this.lastName,
    this.middleName,
    this.parents,
    this.user,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      parents: json['parents'] != null
          ? (json['parents'] as List).map((e) => Parent.fromJson(e)).toList()
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      role: json['role'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

class Parent {
  final String id;

  Parent({required this.id});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(id: json['id']);
  }
}

class GetResultResponse {
  final ResultData getResult;

  GetResultResponse({required this.getResult});

  factory GetResultResponse.fromJson(Map<String, dynamic> json) {
    return GetResultResponse(
      getResult: ResultData.fromJson(json['getResult']),
    );
  }
}

class ResultData {
  final String? resultId;
  final ClassInfo? classInfo;
  final double? totalScore;
  final Subject? bestSubject;
  final Subject? leastSubject;
  final double? averageScore;
  final String? formTeacherComment;
  final String? principalComment;
  final int? position;
  final int? positionOutOf;
  final List<SubjectGrade>? subjectGrades;
  final List<Subject>? subjects;
  final OverallGrading? overallGrading;
  final List<SubjectPosition>? subjectsPosition;
  final Session? session;
  final Term? term;
  final String? spaceId;
  final String? userId;
  final Map<String, dynamic>? metadata;
  final List<CognitiveKeyRating>? cognitiveKeyRatings;
  final Student? student;
  final List<Score>? scores;
  final DateTime? publishedAt;
  final DateTime? withheldAt;
  final String? withholdReason;
  final String? assessmentId; // Added
  final String? type; // Added
  final List<KeysToRating>? keysToRating; // Added
  final List<Rating>? ratings; // Added

  ResultData({
    this.resultId,
    this.classInfo,
    this.totalScore,
    this.bestSubject,
    this.leastSubject,
    this.averageScore,
    this.formTeacherComment,
    this.principalComment,
    this.position,
    this.positionOutOf,
    this.subjectGrades,
    this.subjects,
    this.overallGrading,
    this.subjectsPosition,
    this.session,
    this.term,
    this.spaceId,
    this.userId,
    this.metadata,
    this.cognitiveKeyRatings,
    this.student,
    this.scores,
    this.publishedAt,
    this.withheldAt,
    this.withholdReason,
    this.assessmentId, // Added
    this.type, // Added
    this.keysToRating, // Added
    this.ratings, // Added
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      resultId: json['resultId'] as String?,
      classInfo:
          json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      totalScore: json['totalScore'] != null
          ? double.tryParse(json['totalScore'].toString())
          : null,
      bestSubject: json['bestSubject'] != null
          ? Subject.fromJson(json['bestSubject'])
          : null,
      leastSubject: json['leastSubject'] != null
          ? Subject.fromJson(json['leastSubject'])
          : null,
      averageScore: json['averageScore'] != null
          ? double.tryParse(json['averageScore'].toString())
          : null,
      formTeacherComment: json['formTeacherComment'] as String?,
      principalComment: json['principalComment'] as String?,
      position: json['position'] != null
          ? int.tryParse(json['position'].toString())
          : null,
      positionOutOf: json['positionOutOf'] != null
          ? int.tryParse(json['positionOutOf'].toString())
          : null,
      subjectGrades: json['subjectGrades'] != null
          ? (json['subjectGrades'] as List)
              .map((e) => SubjectGrade.fromJson(e))
              .toList()
          : null,
      subjects: json['subjects'] != null
          ? (json['subjects'] as List).map((e) => Subject.fromJson(e)).toList()
          : null,
      overallGrading: json['overallGrading'] != null
          ? OverallGrading.fromJson(json['overallGrading'])
          : null,
      subjectsPosition: json['subjectsPosition'] != null
          ? (json['subjectsPosition'] as List)
              .map((e) => SubjectPosition.fromJson(e))
              .toList()
          : null,
      session:
          json['session'] != null ? Session.fromJson(json['session']) : null,
      term: json['term'] != null ? Term.fromJson(json['term']) : null,
      spaceId: json['spaceId'] as String?,
      userId: json['userId'] as String?,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      cognitiveKeyRatings: json['cognitiveKeyRatings'] != null
          ? (json['cognitiveKeyRatings'] as List)
              .map((e) => CognitiveKeyRating.fromJson(e))
              .toList()
          : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      scores: json['scores'] != null
          ? (json['scores'] as List).map((e) => Score.fromJson(e)).toList()
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'].toString())
          : null,
      withheldAt: json['withheldAt'] != null
          ? DateTime.tryParse(json['withheldAt'].toString())
          : null,
      withholdReason: json['withholdReason'] as String?,
      assessmentId: json['assessmentId'] as String?, // Added
      type: json['type'] as String?, // Added
      keysToRating: json['keysToRating'] != null
          ? (json['keysToRating'] as List)
              .map((e) => KeysToRating.fromJson(e))
              .toList()
          : null, // Added
      ratings: json['ratings'] != null
          ? (json['ratings'] as List).map((e) => Rating.fromJson(e)).toList()
          : null, // Added
    );
  }
}

class ClassInfo {
  final String? id;
  final String? name;
  final ClassGroup? classGroup;
  final int? studentCount;

  ClassInfo({this.id, this.name, this.classGroup, this.studentCount});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'],
      name: json['name'],
      classGroup: json['classGroup'] != null
          ? ClassGroup.fromJson(json['classGroup'])
          : null,
      studentCount: json['studentCount'] != null
          ? int.tryParse(json['studentCount'].toString())
          : null,
    );
  }
}

class ClassGroup {
  final String? id;
  final String? name;

  ClassGroup({this.id, this.name});

  // factory ClassGroup.fromJson(Map<String, dynamic> json) {
  //   return ClassGroup(
  //     id: json['id'],
  //     name: json['name'],
  //   );
  // }
  factory ClassGroup.fromJson(Map<String, dynamic> json) {
    return ClassGroup(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }
}

class Subject {
  final String? id;
  final String? name;

  Subject({this.id, this.name});

  // factory Subject.fromJson(Map<String, dynamic> json) {
  //   return Subject(
  //     id: json['id'],
  //     name: json['name'],
  //   );
  // }
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }
}

class Session {
  final String? session;
  final String? sessionId;

  Session({this.session, this.sessionId});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      session: json['session'],
      sessionId: json['sessionId'],
    );
  }
}

class CognitiveKeyRating {
  final CognitiveKey? cognitiveKey;
  // final String? rating;
  final int? rating;
  CognitiveKeyRating({this.cognitiveKey, this.rating});

  factory CognitiveKeyRating.fromJson(Map<String, dynamic> json) {
    return CognitiveKeyRating(
      cognitiveKey: json['cognitiveKey'] != null
          ? CognitiveKey.fromJson(json['cognitiveKey'])
          : null,
      rating: json['rating'] as int?,
    );
  }
}

class CognitiveKey {
  final String? cognitiveKeyId;
  final String? domain;
  final String? name;

  CognitiveKey({this.cognitiveKeyId, this.domain, this.name});

  factory CognitiveKey.fromJson(Map<String, dynamic> json) {
    return CognitiveKey(
      cognitiveKeyId: json['cognitiveKeyId'] as String?,
      domain: json['domain'] as String?,
      name: json['name'] as String?,
    );
  }
}

class Score {
  final Subject? subject;
  final List<SubjectResultScore>? subjectScores;

  Score({this.subject, this.subjectScores});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      subjectScores: json['subjectScores'] != null
          ? (json['subjectScores'] as List)
              .map((e) => SubjectResultScore.fromJson(e))
              .toList()
          : null,
    );
  }
}

class SubjectResultScore {
  final double? score;
  final SubAssessment? subAssessment;

  SubjectResultScore({this.score, this.subAssessment});

  factory SubjectResultScore.fromJson(Map<String, dynamic> json) {
    return SubjectResultScore(
      score: json['score'] != null
          ? double.tryParse(json['score'].toString())
          : null,
      subAssessment: json['subAssessment'] != null
          ? SubAssessment.fromJson(json['subAssessment'])
          : null,
    );
  }
}

class Metadata {
  final String? gender;
  final String? attendance;

  Metadata({this.gender, this.attendance});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      gender: json['gender'] as String?,
      attendance: json['attendance'] as String?,
    );
  }
}

// class SubjectGrade {
//   final String? grade;
//   final String? remark;

//   SubjectGrade({this.grade, this.remark});

//   factory SubjectGrade.fromJson(Map<String, dynamic> json) {
//     return SubjectGrade(
//       grade: json['grade'] as String?,
//       remark: json['remark'] as String?,
//     );
//   }
// }
class SubjectGrade {
  final Grade? grade;
  final Subject? subject;

  SubjectGrade({this.grade, this.subject});

  factory SubjectGrade.fromJson(Map<String, dynamic> json) {
    return SubjectGrade(
      grade: json['grade'] != null ? Grade.fromJson(json['grade']) : null,
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }
}

class Grade {
  final int? to;
  final int? from;
  final String? color;
  final String? grade;
  final String? remark;
  final String? principalComment;
  final String? formTeacherComment;

  Grade({
    this.to,
    this.from,
    this.color,
    this.grade,
    this.remark,
    this.principalComment,
    this.formTeacherComment,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      to: json['to'] as int?,
      from: json['from'] as int?,
      color: json['color'] as String?,
      grade: json['grade'] as String?,
      remark: json['remark'] as String?,
      principalComment: json['principalComment'] as String?,
      formTeacherComment: json['formTeacherComment'] as String?,
    );
  }
}

class OverallGrading {
  final int? to;
  final int? from;
  final String? color;
  final String? grade;
  final String? remark;
  final String? principalComment;
  final String? formTeacherComment;

  OverallGrading({
    this.to,
    this.from,
    this.color,
    this.grade,
    this.remark,
    this.principalComment,
    this.formTeacherComment,
  });

  factory OverallGrading.fromJson(Map<String, dynamic> json) {
    return OverallGrading(
      to: json['to'] as int?,
      from: json['from'] as int?,
      color: json['color'] as String?,
      grade: json['grade'] as String?,
      remark: json['remark'] as String?,
      principalComment: json['principalComment'] as String?,
      formTeacherComment: json['formTeacherComment'] as String?,
    );
  }
}

class SubjectPosition {
  final int? outOf;
  final int? total;
  final Subject? subject;
  final int? position;

  SubjectPosition({this.outOf, this.total, this.subject, this.position});

  factory SubjectPosition.fromJson(Map<String, dynamic> json) {
    return SubjectPosition(
      outOf: json['outOf'] as int?,
      total: json['total'] as int?,
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      position: json['position'] as int?,
    );
  }
}

// // Main response model
// class ClassBroadsheetResponse {
//   final GetClassBroadsheet? getClassBroadsheet;

//   ClassBroadsheetResponse({this.getClassBroadsheet});

//   factory ClassBroadsheetResponse.fromJson(Map<String, dynamic> json) {
//     return ClassBroadsheetResponse(
//       getClassBroadsheet: json['data'] != null && json['data']['getClassBroadsheet'] != null
//           ? GetClassBroadsheet.fromJson(json['data']['getClassBroadsheet'])
//           : null,
//     );
//   }
// }

// GetClassBroadsheet model
class GetClassBroadsheet {
  final List<BroadsheetResult>? results;
  final ClassInfo? classInfo;
  final Session? session;
  final Term? term;

  GetClassBroadsheet({
    this.results,
    this.classInfo,
    this.session,
    this.term,
  });

  factory GetClassBroadsheet.fromJson(Map<String, dynamic> json) {
    return GetClassBroadsheet(
      results: json['results'] != null
          ? (json['results'] as List)
              .map((e) => BroadsheetResult.fromJson(e))
              .toList()
          : null,
      classInfo:
          json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      session:
          json['session'] != null ? Session.fromJson(json['session']) : null,
      term: json['term'] != null ? Term.fromJson(json['term']) : null,
    );
  }
}

class BroadsheetResult {
  final String? resultId;
  final ClassInfo? classInfo;
  final String? totalScore;
  final Subject? bestSubject;
  final Subject? leastSubject;
  final String? averageScore;
  final String? formTeacherComment;
  final String? principalComment;
  final int? position;
  final int? positionOutOf;
  final List<SubjectGrade>? subjectGrades;
  final List<Subject>? subjects;
  final Grade? overallGrading;
  final List<SubjectPosition>? subjectsPosition;
  final Session? session;
  final Term? term;
  final String? spaceId;
  final String? userId;
  final Map<String, dynamic>? metadata;
  final List<CognitiveKeyRating>? cognitiveKeyRatings;
  final Student? student;
  final List<SubjectScore>? scores;
  final String? publishedAt;
  final String? withheldAt;
  final String? withholdReason;
  final String? assessmentId; // Added
  final String? type; // Added
  final List<KeysToRating>? keysToRating; // Added
  final List<Rating>? ratings; // Added

  BroadsheetResult({
    this.resultId,
    this.classInfo,
    this.totalScore,
    this.bestSubject,
    this.leastSubject,
    this.averageScore,
    this.formTeacherComment,
    this.principalComment,
    this.position,
    this.positionOutOf,
    this.subjectGrades,
    this.subjects,
    this.overallGrading,
    this.subjectsPosition,
    this.session,
    this.term,
    this.spaceId,
    this.userId,
    this.metadata,
    this.cognitiveKeyRatings,
    this.student,
    this.scores,
    this.publishedAt,
    this.withheldAt,
    this.withholdReason,
    this.assessmentId, // Added
    this.type, // Added
    this.keysToRating, // Added
    this.ratings, // Added
  });

  factory BroadsheetResult.fromJson(Map<String, dynamic> json) {
    return BroadsheetResult(
      resultId: json['resultId'],
      classInfo:
          json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      totalScore: json['totalScore'],
      bestSubject: json['bestSubject'] != null
          ? Subject.fromJson(json['bestSubject'])
          : null,
      leastSubject: json['leastSubject'] != null
          ? Subject.fromJson(json['leastSubject'])
          : null,
      averageScore: json['averageScore'],
      formTeacherComment: json['formTeacherComment'],
      principalComment: json['principalComment'],
      position: json['position'],
      positionOutOf: json['positionOutOf'],
      subjectGrades: json['subjectGrades'] != null
          ? (json['subjectGrades'] as List)
              .map((e) => SubjectGrade.fromJson(e))
              .toList()
          : null,
      subjects: json['subjects'] != null
          ? (json['subjects'] as List).map((e) => Subject.fromJson(e)).toList()
          : null,
      overallGrading: json['overallGrading'] != null
          ? Grade.fromJson(json['overallGrading'])
          : null,
      subjectsPosition: json['subjectsPosition'] != null
          ? (json['subjectsPosition'] as List)
              .map((e) => SubjectPosition.fromJson(e))
              .toList()
          : null,
      session:
          json['session'] != null ? Session.fromJson(json['session']) : null,
      term: json['term'] != null ? Term.fromJson(json['term']) : null,
      spaceId: json['spaceId'],
      userId: json['userId'],
      metadata: json['metadata'],
      cognitiveKeyRatings: json['cognitiveKeyRatings'] != null
          ? (json['cognitiveKeyRatings'] as List)
              .map((e) => CognitiveKeyRating.fromJson(e))
              .toList()
          : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      scores: json['scores'] != null
          ? (json['scores'] as List)
              .map((e) => SubjectScore.fromJson(e))
              .toList()
          : null,
      publishedAt: json['publishedAt'],
      withheldAt: json['withheldAt'],
      withholdReason: json['withholdReason'],
      assessmentId: json['assessmentId'], // Added
      type: json['type'], // Added
      keysToRating: json['keysToRating'] != null
          ? (json['keysToRating'] as List)
              .map((e) => KeysToRating.fromJson(e))
              .toList()
          : null, // Added
      ratings: json['ratings'] != null
          ? (json['ratings'] as List).map((e) => Rating.fromJson(e)).toList()
          : null, // Added
    );
  }
}

// New class for keysToRating
class KeysToRating {
  final String? id;
  final String? name;
  final String? remark;
  final List<ClassInfo>? classes;

  KeysToRating({
    this.id,
    this.name,
    this.remark,
    this.classes,
  });

  factory KeysToRating.fromJson(Map<String, dynamic> json) {
    return KeysToRating(
      id: json['id'],
      name: json['name'],
      remark: json['remark'],
      classes: json['classes'] != null
          ? (json['classes'] as List).map((e) => ClassInfo.fromJson(e)).toList()
          : null,
    );
  }
}

// New class for ratings
class Rating {
  final Subject? subject;
  final RatingKey? ratingKey;
  final SubAssessment? subAssessment;

  Rating({
    this.subject,
    this.ratingKey,
    this.subAssessment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      ratingKey: json['ratingKey'] != null
          ? RatingKey.fromJson(json['ratingKey'])
          : null,
      subAssessment: json['subAssessment'] != null
          ? SubAssessment.fromJson(json['subAssessment'])
          : null,
    );
  }
}

// New class for RatingKey (nested in ratings)
class RatingKey {
  final String? id;
  final String? name;
  final String? remark;

  RatingKey({
    this.id,
    this.name,
    this.remark,
  });

  factory RatingKey.fromJson(Map<String, dynamic> json) {
    return RatingKey(
      id: json['id'],
      name: json['name'],
      remark: json['remark'],
    );
  }
}

// New class for SubAssessment (nested in ratings and scores)
// class SubAssessment {
//   final String? name;
//   final String? subAssessmentId;

//   SubAssessment({
//     this.name,
//     this.subAssessmentId,
//   });

//   factory SubAssessment.fromJson(Map<String, dynamic> json) {
//     return SubAssessment(
//       name: json['name'],
//       subAssessmentId: json['subAssessmentId'],
//     );
//   }
// }
class SubjectScore {
  final Subject? subject;
  final List<SubAssessmentScore>? subjectScores;

  SubjectScore({this.subject, this.subjectScores});

  factory SubjectScore.fromJson(Map<String, dynamic> json) {
    return SubjectScore(
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      subjectScores: json['subjectScores'] != null
          ? (json['subjectScores'] as List)
              .map((e) => SubAssessmentScore.fromJson(e))
              .toList()
          : null,
    );
  }
}

// SubAssessmentScore model
class SubAssessmentScore {
  final String? score;
  final SubAssessment? subAssessment;

  SubAssessmentScore({this.score, this.subAssessment});

  factory SubAssessmentScore.fromJson(Map<String, dynamic> json) {
    return SubAssessmentScore(
      score: json['score'],
      subAssessment: json['subAssessment'] != null
          ? SubAssessment.fromJson(json['subAssessment'])
          : null,
    );
  }
}

class GetSpaceTermDate {
  final int? daysOpen;
  final DateTime? nextTermBeginsOn;
  final DateTime? currentTermClosesOn;
  final DateTime? boardingResumesOn;

  GetSpaceTermDate({
    this.daysOpen,
    this.nextTermBeginsOn,
    this.currentTermClosesOn,
    this.boardingResumesOn,
  });

  factory GetSpaceTermDate.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return GetSpaceTermDate();
    }
    return GetSpaceTermDate(
      daysOpen: json['daysOpen'] as int?,
      nextTermBeginsOn: json['nextTermBeginsOn'] != null
          ? DateTime.parse(json['nextTermBeginsOn'])
          : null,
      currentTermClosesOn: json['currentTermClosesOn'] != null
          ? DateTime.parse(json['currentTermClosesOn'])
          : null,
      boardingResumesOn: json['boardingResumesOn'] != null
          ? DateTime.parse(json['boardingResumesOn'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daysOpen': daysOpen,
      'nextTermBeginsOn': nextTermBeginsOn?.toIso8601String(),
      'currentTermClosesOn': currentTermClosesOn?.toIso8601String(),
      'boardingResumesOn': boardingResumesOn?.toIso8601String(),
    };
  }
}

class ClassModelForm {
  final String name;
  final String spaceId;
  final int? studentCount;
  final FormTeacher? formTeacher; // Changed from User? to FormTeacher?

  ClassModelForm({
    required this.name,
    required this.spaceId,
    this.studentCount,
    this.formTeacher,
  });

  factory ClassModelForm.fromJson(Map<String, dynamic> json) {
    log('incoming formteacher ${json}');
    return ClassModelForm(
      name: json['name'] as String,
      spaceId: json['spaceId'] as String,
      studentCount: json['studentCount'] as int?,
      formTeacher: json['formTeacher'] != null
          ? FormTeacher.fromJson(json['formTeacher'])
          : null,
    );
  }
}

class FormTeacher {
  final String? id;
  final String? firstName;
  final String? lastName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final String? status;
  final String? staffType;
  final String? staffStatus;
  final String? staffNumber;
  final SpaceWallet? spaceWallet;
  final DateTime? retirementDate;
  final String? role;
  final String? salaryGradeLevel;
  final String? schoolHouse;
  final String? middleName;
  final DateTime? archivedAt;
  final bool? archived;
  final String? admissionNumber;
  final ClassInfo? classInfo; // Renamed from 'class' to avoid keyword conflict
 final List<String>? additionalRole;


  FormTeacher({
    this.id,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.status,
    this.staffType,
    this.staffStatus,
    this.staffNumber,
    this.spaceWallet,
    this.retirementDate,
    this.role,
    this.salaryGradeLevel,
    this.schoolHouse,
    this.middleName,
    this.archivedAt,
    this.archived,
    this.admissionNumber,
    this.classInfo,
    this.additionalRole,
  });

  factory FormTeacher.fromJson(Map<String, dynamic> json) {
    return FormTeacher(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      status: json['status'] as String?,
      staffType: json['staffType'] as String?,
      staffStatus: json['staffStatus'] as String?,
      staffNumber: json['staffNumber'] as String?,
      spaceWallet: json['spaceWallet'] != null
          ? SpaceWallet.fromJson(json['spaceWallet'])
          : null,
      retirementDate: json['retirementDate'] != null
          ? DateTime.tryParse(json['retirementDate'].toString())
          : null,
      role: json['role'] as String?,
      salaryGradeLevel: json['salaryGradeLevel'] as String?,
      schoolHouse: json['schoolHouse'] as String?,
      middleName: json['middleName'] as String?,
      archivedAt: json['archivedAt'] != null
          ? DateTime.tryParse(json['archivedAt'].toString())
          : null,
      archived: json['archived'] as bool?,
      admissionNumber: json['admissionNumber'] as String?,
      classInfo:
          json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      additionalRole: (json['additionalRole'] as List<dynamic>?)
    ?.map((e) => e.toString())
    .toList(),

    );
  }
}

class SpaceWallet {
  final String? id;
  final DateTime? createdAt;
  final double? balance;

  SpaceWallet({
    this.id,
    this.createdAt,
    this.balance,
  });

  factory SpaceWallet.fromJson(Map<String, dynamic> json) {
    return SpaceWallet(
      id: json['id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      balance: json['balance'] != null
          ? double.tryParse(json['balance'].toString())
          : null,
    );
  }
}

class SpaceTermDate {
  final DateTime? boardingResumesOn;
  final int daysOpen;
  final DateTime? nextTermBeginsOn;
  final DateTime? currentTermClosesOn;

  SpaceTermDate({
    this.boardingResumesOn,
    required this.daysOpen,
    this.nextTermBeginsOn,
    this.currentTermClosesOn,
  });

  factory SpaceTermDate.fromJson(Map<String, dynamic> json) {
    return SpaceTermDate(
      boardingResumesOn: json['boardingResumesOn'] != null
          ? DateTime.parse(json['boardingResumesOn'] as String)
          : null,
      daysOpen: (json['daysOpen'] as num?)?.toInt() ?? 0,
      nextTermBeginsOn: json['nextTermBeginsOn'] != null
          ? DateTime.parse(json['nextTermBeginsOn'] as String)
          : null,
      currentTermClosesOn: json['currentTermClosesOn'] != null
          ? DateTime.parse(json['currentTermClosesOn'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boardingResumesOn': boardingResumesOn?.toIso8601String(),
      'daysOpen': daysOpen,
      'nextTermBeginsOn': nextTermBeginsOn?.toIso8601String(),
      'currentTermClosesOn': currentTermClosesOn?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SpaceTermDate(boardingResumesOn: $boardingResumesOn, daysOpen: $daysOpen, '
        'nextTermBeginsOn: $nextTermBeginsOn, currentTermClosesOn: $currentTermClosesOn)';
  }
}

class BasicAssessmentSecond {
  final String assessmentId;
  final String name;
  final List<Component> components;
  final List<Term> terms;
  final List<ClassInfo> classes;
  final Config config;
 final String? spaceId;

  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  BasicAssessmentSecond({
    required this.assessmentId,
    required this.name,
    required this.components,
    required this.terms,
    required this.classes,
    required this.config,
    required this.type,
    required this.spaceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BasicAssessmentSecond.fromJson(Map<String, dynamic> json) {
    return BasicAssessmentSecond(
      assessmentId: json['assessmentId'],
      name: json['name'],
      components: (json['components'] as List?)?.map((e) => Component.fromJson(e)).toList() ?? [],

      // components: (json['components'] as List)
      //     .map((e) => Component.fromJson(e))
      //     .toList(),
      terms: (json['terms'] as List).map((e) => Term.fromJson(e)).toList(),
      classes:
          (json['classes'] as List).map((e) => ClassInfo.fromJson(e)).toList(),
      config: Config.fromJson(json['config']),
      type: json['type'],
      spaceId: json['spaceId'] as String?,

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Config {
  final bool showCognitiveKeys;
  final bool showPrincipalComment;
  final bool showFormTeacherComment;
  final bool showSubjectTeachers;
  final bool showResumptionDate;
  final bool showAttendance;
  final bool showClassPosition;
  final bool showSubjectPosition;
  final bool showFormTeacherSignature;
  final bool showClassStudentsCount;
  final bool showSubjectTeachersName;
  final bool showClassTeachersCount;

  Config({
    required this.showCognitiveKeys,
    required this.showPrincipalComment,
    required this.showFormTeacherComment,
    required this.showSubjectTeachers,
    required this.showResumptionDate,
    required this.showAttendance,
    required this.showClassPosition,
    required this.showSubjectPosition,
    required this.showFormTeacherSignature,
    required this.showClassStudentsCount,
    required this.showSubjectTeachersName,
    required this.showClassTeachersCount,
  });

factory Config.fromJson(Map<String, dynamic> json) {
  return Config(
    showCognitiveKeys: json['showCognitiveKeys'] ?? false,
    showPrincipalComment: json['showPrincipalComment'] ?? false,
    showFormTeacherComment: json['showFormTeacherComment'] ?? false,
    showSubjectTeachers: json['showSubjectTeachers'] ?? false,
    showResumptionDate: json['showResumptionDate'] ?? false,
    showAttendance: json['showAttendance'] ?? false,
    showClassPosition: json['showClassPosition'] ?? false,
    showSubjectPosition: json['showSubjectPosition'] ?? false,
    showFormTeacherSignature: json['showFormTeacherSignature'] ?? false,
    showClassStudentsCount: json['showClassStudentsCount'] ?? false,
    showSubjectTeachersName: json['showSubjectTeachersName'] ?? false,
    showClassTeachersCount: json['showClassTeachersCount'] ?? false,
  );
}

}

class GradingSystem {
  final String? gradingSystemId;
  final String? classId;
  final ClassInfo? classInfo;
  final int? from;
  final int? to;
  final String? remark;
  final String? grade;
  final String? color;
  final String? principalComment;
  final String? formTeacherComment;

  GradingSystem({
    this.gradingSystemId,
    this.classId,
    this.classInfo,
    this.from,
    this.to,
    this.remark,
    this.grade,
    this.color,
    this.principalComment,
    this.formTeacherComment,
  });

  factory GradingSystem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return GradingSystem();
    }
    
    return GradingSystem(
      gradingSystemId: json['gradingSystemId'] as String?,
      classId: json['classId'] as String?,
      classInfo: json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      from: json['from'] != null ? json['from'] as int : null,
      to: json['to'] != null ? json['to'] as int : null,
      remark: json['remark'] as String?,
      grade: json['grade'] as String?,
      color: json['color'] as String?,
      principalComment: json['principalComment'] as String?,
      formTeacherComment: json['formTeacherComment'] as String?,
    );
  }
}