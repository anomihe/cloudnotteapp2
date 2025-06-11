import 'dart:developer';


import 'package:cloudnottapp2/src/data/models/accounting_mode_second.dart' show SpaceWallet;
import 'package:cloudnottapp2/src/data/models/class_group.dart';
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    show FormTeacher;
import 'package:cloudnottapp2/src/data/models/exam_session_model.dart';

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? phoneNumber;
  final String? email;
  final String? profileImageUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final String? type;
  final bool? isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.phoneNumber,
    this.email,
    this.profileImageUrl,
    this.gender,
    this.dateOfBirth,
    this.country,
    this.state,
    this.city,
    this.address,
    this.type,
    this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] ??
            '', // Provide default if null (though this should rarely be null)
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        username: json['username'] as String? ?? '',
        phoneNumber: json['phoneNumber'] as String? ?? '',
        email: json['email'] ?? '', // Add default for required field
        profileImageUrl: json['profileImageUrl'] ?? '',
        gender: json['gender'] ?? '',
        dateOfBirth: DateTime.parse(
            json['dateOfBirth'] ?? '1970-01-01T00:00:00Z'), // Default date
        country: json['country'] ?? '',
        state: json['state'] ?? '',
        city: json['city'] ?? '',
        address: json['address'] ?? '',
        type: json['type'] ?? '',
        isEmailVerified: json['isEmailVerified'] ?? false, // Default for bool
        createdAt: DateTime.parse(json['createdAt'] ?? '1970-01-01T00:00:00Z'),
        updatedAt: DateTime.parse(json['updatedAt'] ?? '1970-01-01T00:00:00Z'),
      );
    } catch (e) {
      // Catch and rethrow with more context
      throw FormatException('Failed to parse User from JSON: $e\nJSON: $json');
    }
  }
  factory User.empty() => User(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        gender: '',
      );
  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     id: json['id'],
  //     firstName: json['firstName'],
  //     lastName: json['lastName'],
  //     username: json['username'],
  //     phoneNumber: json['phoneNumber'],
  //     email: json['email'],
  //     profileImageUrl: json['profileImageUrl'] ?? '',
  //     gender: json['gender'] ?? '',
  //     dateOfBirth: DateTime.parse(json['dateOfBirth']),
  //     country: json['country'] ?? '',
  //     state: json['state'] ?? '',
  //     city: json['city'] ?? '',
  //     address: json['address'] ?? '',
  //     type: json['type'] ?? '',
  //     isEmailVerified: json['isEmailVerified'],
  //     createdAt: DateTime.parse(json['createdAt']),
  //     updatedAt: DateTime.parse(json['updatedAt']),
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'phoneNumber': phoneNumber,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'type': type,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

//spaces model
class UserSpace {
  final String? id;
  final String? name;
  final String? description;
  final String? phoneNumber;
  final String? email;
  final String? logo;
  final String? currentSpaceSessionId;
  final String? currentSpaceTermId;
  final String? createdById;
  final List<String>? categories;
  final List<String>? curriculums;
  final String? type;
  final String? currency;
  final DateTime? createdAt;
  final bool? isPaid;
  final String? alias;
  final int? studentCount;
  final int? teacherCount;
  final int? classCount;
  final int? subjectCount;
  final List<SpaceTerm>? spaceTerms;
  final List<SpaceSession>? spaceSessions;

  UserSpace({
    this.id,
    this.name,
    this.description,
    this.phoneNumber,
    this.email,
    this.logo,
    this.currentSpaceSessionId,
    this.currentSpaceTermId,
    this.createdById,
    this.categories,
    this.curriculums,
    this.type,
    this.currency,
    this.createdAt,
    this.isPaid,
    this.alias,
    this.studentCount,
    this.teacherCount,
    this.classCount,
    this.subjectCount,
    this.spaceTerms,
    this.spaceSessions,
  });

  factory UserSpace.fromJson(Map<String, dynamic> json) {
    return UserSpace(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'],
      currentSpaceSessionId: json['currentSpaceSessionId'] ?? '',
      currentSpaceTermId: json['currentSpaceTermId'] ?? '',
      createdById: json['createdById'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      curriculums: List<String>.from(json['curriculums'] ?? []),
      type: json['type'] ?? '',
      currency: json['currency'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isPaid: json['isPaid'] ?? false,
      alias: json['alias'] ?? '',
      studentCount: json['studentCount'],
      teacherCount: json['teacherCount'],
      classCount: json['classCount'],
      subjectCount: json['subjectCount'],
      spaceTerms: (json['spaceTerms'] as List<dynamic>?)
              ?.map((t) => SpaceTerm.fromJson(t))
              .toList() ??
          [],
      spaceSessions: (json['spaceSessions'] as List<dynamic>?)
              ?.map((s) => SpaceSession.fromJson(s))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'phoneNumber': phoneNumber,
      'email': email,
      'logo': logo,
      'currentSpaceSessionId': currentSpaceSessionId,
      'currentSpaceTermId': currentSpaceTermId,
      'createdById': createdById,
      'categories': categories,
      'curriculums': curriculums,
      'type': type,
      'currency': currency,
      'createdAt': createdAt?.toIso8601String(),
      'isPaid': isPaid,
      'alias': alias,
      'studentCount': studentCount,
      'teacherCount': teacherCount,
      'classCount': classCount,
      'subjectCount': subjectCount,
      'spaceTerms': spaceTerms?.map((t) => t.toJson()).toList(),
      'spaceSessions': spaceSessions?.map((s) => s.toJson()).toList(),
    };
  }
}

class SpaceTerm {
  final String id;
  final String name;
  final String alias;
  final String spaceId;

  SpaceTerm({
    required this.id,
    required this.name,
    required this.alias,
    required this.spaceId,
  });

  factory SpaceTerm.fromJson(Map<String, dynamic> json) {
    return SpaceTerm(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      alias: json['alias'] ?? '',
      spaceId: json['spaceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'spaceId': spaceId,
    };
  }
  SpaceTerm.empty()
      : id = '',
        name = '',
        alias = '',
        spaceId = '';
}

class SpaceSession {
  final String id;
  final String session;
  final String alias;
  final String spaceId;

  SpaceSession({
    required this.id,
    required this.session,
    required this.alias,
    required this.spaceId,
  });

  factory SpaceSession.fromJson(Map<String, dynamic> json) {
    return SpaceSession(
      id: json['id'] ?? '',
      session: json['session'] ?? '',
      alias: json['alias'] ?? '',
      spaceId: json['spaceId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session': session,
      'alias': alias,
      'spaceId': spaceId,
    };
  }
}

class UserSpacesResponse {
  final List<UserSpace> userSpaces;

  UserSpacesResponse({required this.userSpaces});

  factory UserSpacesResponse.fromJson(Map<String, dynamic> json) {
    return UserSpacesResponse(
      userSpaces: (json['getUserSpaces'] as List)
          .map((space) => UserSpace.fromJson(space))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'getUserSpaces': userSpaces.map((space) => space.toJson()).toList(),
    };
  }
}

//for the individual space model
class SpaceUser {
  final User? user;
  final String? memberId;
  final String? role;
  final ClassInfo? classInfo; // for students
  final List<ClassInfo>? assignedClass; // for teacher/admin
  final List<TeacherSubject>? subjects; // for teacher/admin
  final SpaceWallet? spaceWallet;

  // Newly added fields for dedicated accounts
  final String? dedicatedAccountBank;
  final String? dedicatedAccountName;
  final String? dedicatedAccountNumber;
  final String? dedicatedAccountProviderId;
  final String? dedicatedAccountReference;

  SpaceUser({
    this.user,
    this.role,
    this.memberId,
    this.classInfo,
    this.assignedClass,
    this.subjects,
    this.spaceWallet,
    this.dedicatedAccountBank,
    this.dedicatedAccountName,
    this.dedicatedAccountNumber,
    this.dedicatedAccountProviderId,
    this.dedicatedAccountReference,
  });

  factory SpaceUser.fromJson(Map<String, dynamic> json) {
    final role = json['role']?.toLowerCase();

    return SpaceUser(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      role: json['role'],
      memberId: json['memberId'],
      classInfo: json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      assignedClass: json['assignedClass'] != null
          ? List<ClassInfo>.from(json['assignedClass'].map((x) => ClassInfo.fromJson(x)))
          : null,
      subjects: json['subjects'] != null
          ? List<TeacherSubject>.from(json['subjects'].map((x) => TeacherSubject.fromJson(x)))
          : null,
      spaceWallet: json['spaceWallet'] != null ? SpaceWallet.fromJson(json['spaceWallet']) : null,

      // dedicated account fields
      dedicatedAccountBank: json['dedicatedAccountBank'],
      dedicatedAccountName: json['dedicatedAccountName'],
      dedicatedAccountNumber: json['dedicatedAccountNumber'],
      dedicatedAccountProviderId: json['dedicatedAccountProviderId'],
      dedicatedAccountReference: json['dedicatedAccountReference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'role': role,
      'memberId': memberId,
      'class': classInfo?.toJson(),
      'assignedClass': assignedClass?.map((e) => e.toJson()).toList(),


 
      'dedicatedAccountBank': dedicatedAccountBank,
      'dedicatedAccountName': dedicatedAccountName,
      'dedicatedAccountNumber': dedicatedAccountNumber,
      'dedicatedAccountProviderId': dedicatedAccountProviderId,
      'dedicatedAccountReference': dedicatedAccountReference,
    };
  }
}

// class SpaceUser {
//   final User? user;
//   final String? memberId;
//   final String? role;
//   final ClassInfo? classInfo;
//   final List<Class>? assignedClass; // For teachers
//   final List<TeacherSubject>? subjects;
//   final SpaceWallet? spaceWallet;
//   SpaceUser({
//     this.user,
//     this.role,
//     this.memberId,
//     // required this.classInfo,
//     this.classInfo,
//     this.assignedClass,
//     this.subjects,
//     this.spaceWallet,
//   });

//   factory SpaceUser.fromJson(Map<String, dynamic> json) {
//     // log('Incoming JSON: $json ${json['role']}');
//     // final data = json['getSpaceUser'];
//     final role = json['role'];
//     // final String? typename = json['__typename'];
//     // log('Incoming JSON: $json ${json['role']} ${typename}');
//     log('Incoming JSON: $json');
//     if (role == 'student') {
//       return SpaceUser(
//         memberId: json['memberId'],
//         user: User.fromJson(json['user']),
//         // role: role,
//         role: json['role'],
//         classInfo:
//             json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
//          spaceWallet:
//             json['spaceWallet'] != null ? SpaceWallet.fromJson(json['spaceWallet']) : null,
//       );
//     } else if (role == 'teacher' || role == 'admin') {
//       return SpaceUser(
//         user: User.fromJson(json['user']),
//         memberId: json['memberId'],
//         // role: role,
//         role: json['role'],
//         assignedClass: json['assignedClass'] != null
//             ? List<Class>.from(
//                 json['assignedClass'].map((x) => Class.fromJson(x)))
//             : null,
//         subjects: json['subjects'] != null
//             ? List<TeacherSubject>.from(
//                 json['subjects'].map((x) => TeacherSubject.fromJson(x)))
//             : null,
//       );
//     } else {
//       throw Exception('Unknown role type: $role');
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'user': user!.toJson(),
//       'role': role,
//       'class': classInfo!.toJson(),
//     };
//   }
// }

class ClassInfo {
  final String? id;
  final String? name;
  final String? description;
  final String classGroupId;
  final int? subjectCount;
  final int? studentCount;
  final dynamic subjectDetails;
  final dynamic students;
  final dynamic formTeacher;
  final ClassGroup? classGroup;

  ClassInfo({
    this.id,
    this.name,
    this.description,
    required this.classGroupId,
    this.subjectCount,
    this.studentCount,
    this.subjectDetails,
    this.students,
    this.formTeacher,
    required this.classGroup,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      classGroupId: json['classGroupId'],
      subjectCount: json['subjectCount'],
      studentCount: json['studentCount'],
      subjectDetails: json['subjectDetails'],
      students: json['students'],
      formTeacher: json['formTeacher'] ?? '',
      classGroup: json['classGroup'] != null
          ? ClassGroup.fromJson(json['classGroup'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'classGroupId': classGroupId,
      'subjectCount': subjectCount,
      'studentCount': studentCount,
      'subjectDetails': subjectDetails,
      'students': students,
      'formTeacher': formTeacher,
      'classGroup': classGroup!.toJson(),
    };
  }
}

//for the timetable
class ClassTimeTable {
  final String? id;
  final String? activity;
  final String? location;
  final bool? liveClassroom;
  final String? dayOfWeekId;
  final String? timeSlotId;
  final String? subjectId;
  final String? updatedAt;
  final String? createdAt;
  final String? classId;

  final DayOfWeek? dayOfWeek;
  final Subject? subject;
  final TimeSlot? timeSlot;
  final Class? classInfo;
  final List<ClassRecording>? classRecordings;

  ClassTimeTable({
    this.id,
    this.activity,
    this.location,
    this.liveClassroom,
    this.dayOfWeekId,
    this.timeSlotId,
    this.subjectId,
    this.updatedAt,
    this.createdAt,
    this.classId,
    this.dayOfWeek,
    this.subject,
    this.timeSlot,
    this.classInfo,
    this.classRecordings,
  });

  factory ClassTimeTable.fromMap(Map<String, dynamic> map) {
    log("DATA: ${map['classRecordings'].toString()}");
    return ClassTimeTable(
      id: map['id'],
      activity: map['activity'] as String?,
      location: map['location'] as String?,
      liveClassroom: map['liveClassroom'] as bool?,
      dayOfWeekId: map['dayOfWeekId'] as String?,
      timeSlotId: map['timeSlotId'] as String?,
      subjectId: map['subjectId'] as String?,
      classId: map['classId'] as String?,
      updatedAt: map['updatedAt'] as String?,
      createdAt: map['createdAt'] as String?,

      dayOfWeek: map['dayOfWeek'] != null
          ? DayOfWeek.fromMap(map['dayOfWeek'] as Map<String, dynamic>)
          : null,
      subject: map['subject'] != null
          ? Subject.fromMap(map['subject'] as Map<String, dynamic>)
          : null,
      timeSlot: map['timeSlot'] != null
          ? TimeSlot.fromMap(map['timeSlot'] as Map<String, dynamic>)
          : null,
      classInfo: map['class'] != null
          ? Class.fromJson(map['class'] as Map<String, dynamic>)
          : null,
      classRecordings: map['classRecordings'] != null
          ? List<ClassRecording>.from(
              map['classRecordings'].map((x) => ClassRecording.fromJson(x)))
          : null,
    );
  }
}

// class ClassTimeTable {
//   final String? id;
//   final String? activity;
//   final String? classId;
//   final String? location;
//   final bool? liveClassroom;
//   final DayOfWeek? dayOfWeek;
//   final Subject? subject;
//   final TimeSlot? timeSlot;
//   final String? updatedAt;
//   final String? createdAt;
//   final Class? classInfo;
//   final List<ClassRecording>? classRecordings;

//   ClassTimeTable({
//     this.id,
//     this.activity,
//     this.classId,
//     this.location,
//     this.liveClassroom,
//     this.dayOfWeek,
//     this.subject,
//     this.timeSlot,
//     this.updatedAt,
//     this.createdAt,
//     this.classInfo,
//     this.classRecordings,
//   });

//   factory ClassTimeTable.fromMap(Map<String, dynamic> map) {
//     log("DATA: ${map['classRecordings'].toString()}");
//     return ClassTimeTable(
//       id: map['id'],
//       activity: map['activity'] as String?,
//       classId: map['classId'] as String?,
//       location: map['location'] as String?,
//       liveClassroom: map['liveClassroom'] as bool?,
//       dayOfWeek: map['dayOfWeek'] != null
//           ? DayOfWeek.fromMap(map['dayOfWeek'] as Map<String, dynamic>)
//           : null,
//       classInfo: map['class'] != null
//           ? Class.fromJson(map['class'] as Map<String, dynamic>)
//           : null,
//       subject: map['subject'] != null
//           ? Subject.fromMap(map['subject'] as Map<String, dynamic>)
//           : null,
//       timeSlot: map['timeSlot'] != null
//           ? TimeSlot.fromMap(map['timeSlot'] as Map<String, dynamic>)
//           : null,
//       classRecordings: map['classRecordings'] != null
//           ? List<ClassRecording>.from(
//               map['classRecordings'].map((x) => ClassRecording.fromJson(x)))
//           : null,
//       updatedAt: map['updatedAt'] as String?,
//       createdAt: map['createdAt'] as String?,
//     );
//   }
// }

class ClassRecording {
  final String? id;
  final String? lessonNoteId;
  final String? recordUrl;
  final String? timeRecorded;

  ClassRecording({
    this.id,
    this.lessonNoteId,
    this.recordUrl,
    this.timeRecorded,
  });

  factory ClassRecording.fromJson(Map<String, dynamic> json) {
    return ClassRecording(
        id: json['id'],
        lessonNoteId: json['lessonNoteId'],
        recordUrl: json['recordUrl'],
        timeRecorded: json['timeRecorded']);
  }
}

class DayOfWeek {
  final String? id;
  final String? name;
  final bool? enabled;
  final String? spaceId;
  final String? createdAt;
  final String? updatedAt;

  DayOfWeek({
    this.id,
    this.name,
    this.enabled,
    this.spaceId,
    this.createdAt,
    this.updatedAt,
  });

  factory DayOfWeek.fromMap(Map<String, dynamic> map) {
    return DayOfWeek(
      id: map['id'] as String?,
      name: map['name'] as String?,
      enabled: map['enabled'] as bool?,
      spaceId: map['spaceId'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }
}

class Subject {
  final String? id;
  final String? name;
  final String? description;
  final String? spaceId;
  final String? teacherId;
  final Teacher? teacher;

  Subject({
    this.id,
    this.name,
    this.description,
    this.spaceId,
    this.teacherId,
    this.teacher,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      spaceId: map['spaceId'] as String?,
      teacherId: map['teacherId'] as String?,
      teacher: map['teacher'] != null ? Teacher.fromJson(map['teacher']) : null,
    );
  }
  factory Subject.empty() {
    return Subject(id: '', name: '');
  }
}

// class Teacher {
//   final String? id;
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? profileImageUrl;

//   Teacher({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.profileImageUrl,
//   });

//   factory Teacher.fromMap(Map<String, dynamic> map) {
//     return Teacher(
//       id: map['id'] as String?,
//       firstName: map['firstName'] as String?,
//       lastName: map['lastName'] as String?,
//       email: map['email'] as String?,
//       profileImageUrl: map['profileImageUrl'] as String?,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'profileImageUrl': profileImageUrl,
//     };
//   }
// }

class TimeSlot {
  final String? id;
  final String? time;
  final String? spaceId;
  final String? createdAt;
  final String? updatedAt;

  TimeSlot({
    this.id,
    this.time,
    this.spaceId,
    this.createdAt,
    this.updatedAt,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      id: map['id'] as String?,
      time: map['time'] as String?,
      spaceId: map['spaceId'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }
}

class TeacherSubject {
  final String id;
  final String? subjectId;
  final String? classId;
  final String? teacherId;
  final Class? class_;
  final Subject? subject;

  TeacherSubject({
    required this.id,
    this.subjectId,
    this.classId,
    this.teacherId,
    this.class_,
    this.subject,
  });

  factory TeacherSubject.fromJson(Map<String, dynamic> json) {
    return TeacherSubject(
      id: json['id'],
      subjectId: json['subjectId'],
      classId: json['classId'],
      teacherId: json['teacherId'],
      class_: json['class'] != null ? Class.fromJson(json['class']) : null,
      subject:
          json['subject'] != null ? Subject.fromMap(json['subject']) : null,
    );
  }
}

// class Class {
//   final String id;
//   final String name;
//   final String? description;
//   final String? classGroupId;
//   final int? subjectCount;
//   final int? studentCount;
//   final User? formTeacher;
//   final ClassGroup? classGroup;
//   final List<Subject>? subjectDetails;

//   Class({
//     required this.id,
//     required this.name,
//     this.description,
//     this.classGroupId,
//     this.subjectCount,
//     this.studentCount,
//     this.formTeacher,
//     this.classGroup,
//     this.subjectDetails,
//   });

//   factory Class.fromJson(Map<String, dynamic> json) {
//     return Class(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       classGroupId: json['classGroupId'],
//       subjectCount: json['subjectCount'],
//       studentCount: json['studentCount'],
//       formTeacher: json['formTeacher'] != null
//           ? User.fromJson(json['formTeacher'])
//           : null,
//       classGroup: json['classGroup'] != null
//           ? ClassGroup.fromJson(json['classGroup'])
//           : null,
//       subjectDetails: json['subjectDetails'] != null
//           ? List<Subject>.from(
//               json['subjectDetails'].map((x) => Subject.fromMap(x)))
//           : null,
//     );
//   }
// }
class Class {
  final String? id;
  final String? name;
  final String? description;
  final String? classGroupId;
  final int? subjectCount;
  final int? studentCount;
  final FormTeacher? formTeacher;
  final ClassGroup? classGroup;
  final List<Subject>? subjectDetails;

  Class({
    this.id,
    this.name,
    this.description,
    this.classGroupId,
    this.subjectCount,
    this.studentCount,
    this.formTeacher,
    this.classGroup,
    this.subjectDetails,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      classGroupId: json['classGroupId']?.toString(),
      subjectCount:
          json['subjectCount'] != null ? json['subjectCount'] as int : null,
      studentCount:
          json['studentCount'] != null ? json['studentCount'] as int : null,
      formTeacher: json['formTeacher'] != null
          ? FormTeacher.fromJson(json['formTeacher'])
          : null,
      classGroup: json['classGroup'] != null
          ? ClassGroup.fromJson(json['classGroup'])
          : null,
      subjectDetails: json['subjectDetails'] != null
          ? (json['subjectDetails'] as List<dynamic>)
              .map((x) => Subject.fromMap(x))
              .toList()
          : [],
    );
  }
}

class SpaceModel {
  final String? id;
  final String? name;
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
  final UserInfo? createdBy;

  final String? alias;
  final int? classCount;
  final int? studentCount;
  final int? subjectCount;
  final int? teacherCount;

  final double? femaleTeacherPercentage;
  final int? femaleTeacherCount;
  final double? femaleStudentPercentage;
  final int? femaleStudentCount;

  final int? maleStudentCount;
  final double? maleStudentPercentage;
  final int? maleTeacherCount;
  final double? maleTeacherPercentage;

  final int? totalNumberSpaceParents;

  final List<SpaceSession>? spaceSessions;
  final SpaceSession? currentSpaceSession;
  final SpaceTerm? currentSpaceTerm;
  final List<SpaceTerm>? spaceTerms;

  final String? reportSheetType;
  final List<SocialMedia>? socials;
  final String? websiteUrl;
  final int? schoolFeesMax;
  final bool? isBoarding;
  final List<String>? facilities;
  final List<String>? languages;

  final int? contactPersonCount;
  final String? foundingYear;
  final String? colour;
  final List<String>? genders;
  final String? stamp;
  final bool? accountingPinIsSet;
  final List<String>? features;

  SpaceModel({
    this.id,
    this.name,
    this.description,
    this.phoneNumber,
    this.email,
    this.logo,
    this.categories,
    this.curriculums,
    this.type,
    this.features,
    this.currency,
    this.createdAt,
    this.isPaid,
    this.currentSpaceSessionId,
    this.currentSpaceTermId,
    this.locationInfo,
    this.createdBy,
    this.alias,
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

  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
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
      createdBy: json['createdBy'] != null
          ? UserInfo.fromJson(json['createdBy'])
          : null,
      alias: json['alias'],
      classCount: json['classCount'],
      studentCount: json['studentCount'],
      subjectCount: json['subjectCount'],
      teacherCount: json['teacherCount'],
      features: json['features'] != null
        ? List<String>.from(json['features'])
        : null,
      femaleTeacherPercentage: json['femaleTeacherPercentage']?.toDouble(),
      femaleTeacherCount: json['femaleTeacherCount'],
      femaleStudentPercentage: json['femaleStudentPercentage']?.toDouble(),
      femaleStudentCount: json['femaleStudentCount'],
      maleStudentCount: json['maleStudentCount'],
      maleStudentPercentage: json['maleStudentPercentage']?.toDouble(),
      maleTeacherCount: json['maleTeacherCount'],
      maleTeacherPercentage: json['maleTeacherPercentage']?.toDouble(),
      totalNumberSpaceParents: json['totalNumberSpaceParents'],
      spaceSessions: json['spaceSessions'] != null
          ? (json['spaceSessions'] as List)
              .map((session) => SpaceSession.fromJson(session))
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
              .map((term) => SpaceTerm.fromJson(term))
              .toList()
          : null,
      reportSheetType: json['reportSheetType'],
      socials: json['socials'] != null
          ? (json['socials'] as List)
              .map((social) => SocialMedia.fromJson(social))
              .toList()
          : null,
      websiteUrl: json['websiteUrl'],
      schoolFeesMax: json['schoolFeesMax'],
      isBoarding: json['isBoarding'],
      facilities: json['facilities'] != null
          ? List<String>.from(json['facilities'])
          : null,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      contactPersonCount: json['contactPersonCount'],
      foundingYear: json['foundingYear'],
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
  final String? longitude;
  final String? latitude;

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
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class UserInfo {
  final String? firstName;
  final String? lastName;
  final String? id;

  UserInfo({
    this.firstName,
    this.lastName,
    this.id,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      firstName: json['firstName'],
      lastName: json['lastName'],
      id: json['id'],
    );
  }
}

class SocialMedia {
  final String? name;
  final String? url;

  SocialMedia({
    this.name,
    this.url,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      name: json['name'],
      url: json['url'],
    );
  }
}

class UserSpaceInvitation {
  final String id;
  final String? type;
  final String? status;
  final String? metadata;
  final String? inviteeId;
  final String? inviterId;
  final String? spaceId;
  final String? classId;
  final InvitationSpace? space;
  final InvitationClass? classInfo;

  UserSpaceInvitation({
    required this.id,
    this.type,
    this.status,
    this.metadata,
    this.inviteeId,
    this.inviterId,
    this.spaceId,
    this.classId,
    this.space,
    this.classInfo,
  });

  factory UserSpaceInvitation.fromJson(Map<String, dynamic> json) {
    return UserSpaceInvitation(
      id: json['id'] ?? '',
      type: json['type'],
      status: json['status'],
      metadata: json['metadata'],
      inviteeId: json['inviteeId'],
      inviterId: json['inviterId'],
      spaceId: json['spaceId'],
      classId: json['classId'],
      space: json['space'] != null
          ? InvitationSpace.fromJson(json['space'])
          : null,
      classInfo: json['class'] != null
          ? InvitationClass.fromJson(json['class'])
          : null,
    );
  }
}

class InvitationSpace {
  final String id;
  final String? name;
  final String? description;
  final String? phoneNumber;
  final String? email;
  final String? logo;
  final String? type;
  final String? currency;
  final String? createdAt;
  final bool? isPaid;
  final String? alias;

  InvitationSpace({
    required this.id,
    this.name,
    this.description,
    this.phoneNumber,
    this.email,
    this.logo,
    this.type,
    this.currency,
    this.createdAt,
    this.isPaid,
    this.alias,
  });

  factory InvitationSpace.fromJson(Map<String, dynamic> json) {
    return InvitationSpace(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      logo: json['logo'],
      type: json['type'],
      currency: json['currency'],
      createdAt: json['createdAt'],
      isPaid: json['isPaid'],
      alias: json['alias'],
    );
  }
}

class InvitationClass {
  final String id;
  final String? name;
  final String? description;
  final ClassGroup? classGroup;

  InvitationClass({
    required this.id,
    this.name,
    this.description,
    this.classGroup,
  });

  factory InvitationClass.fromJson(Map<String, dynamic> json) {
    return InvitationClass(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'],
      classGroup: json['classGroup'] != null
          ? ClassGroup.fromJson(json['classGroup'])
          : null,
    );
  }
}

class PendingSpaceLinkRequest {
  final String id;
  final String spaceId;
  final String requesterId;
  final String requestedUserId;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final Requester? requester;

  PendingSpaceLinkRequest({
    required this.id,
    required this.spaceId,
    required this.requesterId,
    required this.requestedUserId,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.requester,
  });

  factory PendingSpaceLinkRequest.fromJson(Map<String, dynamic> json) {
    return PendingSpaceLinkRequest(
      id: json['id'] ?? '',
      spaceId: json['spaceId'] ?? '',
      requesterId: json['requesterId'] ?? '',
      requestedUserId: json['requestedUserId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      requester: json['requester'] != null
          ? Requester.fromJson(json['requester'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceId': spaceId,
      'requesterId': requesterId,
      'requestedUserId': requestedUserId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'requester': requester?.toJson(),
    };
  }
}

class Requester {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  Requester({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  factory Requester.fromJson(Map<String, dynamic> json) {
    return Requester(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
    };
  }
}
