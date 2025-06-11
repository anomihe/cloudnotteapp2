import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/user_model.dart';
import 'package:intl/intl.dart';

class ExamData {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final int duration;
  final int totalMark;
  final int totalTheoryMark;
  final String? pin;
  final bool hasPin;
  final String instruction;

  final bool enabled;
  final bool isOffline;
  final bool showScoreOnSubmission;
  final bool showCorrections;
  final bool scoreNotification;
  final bool strictMode;
  final bool showCalculator;
  final bool shuffleCBTQuestions;
  final String subjectId;
  final String examGroupId;
  final List<String> questionIds;
  final List<String> classIds;
  final List<String> examSessionIds;
  final List<String> ineligibleStudentIds;
  final String createdById;
  final int questionCount;
  final ExamGroup examGroup;
  final CreatedBy? createdBy; //readded
  final Subject subject;

  ExamData({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.totalMark,
    required this.totalTheoryMark,
    this.pin,
    required this.hasPin,
    required this.instruction,
    required this.enabled,
    required this.isOffline,
    required this.showScoreOnSubmission,
    required this.showCorrections,
    required this.scoreNotification,
    required this.strictMode,
    required this.showCalculator,
    required this.shuffleCBTQuestions,
    required this.subjectId,
    required this.examGroupId,
    required this.questionIds,
    required this.classIds,
    required this.examSessionIds,
    required this.ineligibleStudentIds,
    required this.createdById,
    required this.questionCount,
    this.createdBy,
    required this.subject,
    required this.examGroup,
  });
factory ExamData.fromJson(Map<String, dynamic> json) {
  log('Processing exam JSON: ${json['id']}');
  
  try {
    // 1. Handle all String fields with extra caution
    final String id = json['id']?.toString() ?? '';
    final String name = json['name']?.toString() ?? '';
    final String startDate = json['startDate']?.toString() ?? '';
    final String endDate = json['endDate']?.toString() ?? '';
    final String instruction = json['instruction']?.toString() ?? '';
    final String subjectId = json['subjectId']?.toString() ?? '';
    final String examGroupId = json['examGroupId']?.toString() ?? '';
    final String createdById = json['createdById']?.toString() ?? '';
    final String? pin = json['pin']?.toString();
    
    // 2. Handle all boolean fields
    final bool hasPin = json['hasPin'] == true;
    final bool enabled = json['enabled'] == true;
    final bool isOffline = json['isOffline'] == true;
    final bool showScoreOnSubmission = json['showScoreOnSubmission'] == true;
    final bool showCorrections = json['showCorrections'] == true;
    final bool scoreNotification = json['scoreNotification'] == true;
    final bool strictMode = json['strictMode'] == true;
    final bool showCalculator = json['showCalculator'] == true;
    final bool shuffleCBTQuestions = json['shuffleCBTQuestions'] == true;
    
    // 3. Handle all int fields
    final int duration = int.tryParse(json['duration']?.toString() ?? '0') ?? 0;
    final int totalMark = int.tryParse(json['totalMark']?.toString() ?? '0') ?? 0;
    final int totalTheoryMark = int.tryParse(json['totalTheoryMark']?.toString() ?? '0') ?? 0;
    final int questionCount = int.tryParse(json['questionCount']?.toString() ?? '0') ?? 0;
    
    // 4. Handle list fields safely
    final List<String> questionIds = (json['questionIds'] as List<dynamic>?)
        ?.map((e) => e?.toString() ?? '')
        .toList() ?? [];
        
    final List<String> classIds = (json['classIds'] as List<dynamic>?)
        ?.map((e) => e?.toString() ?? '')
        .toList() ?? [];
        
    final List<String> examSessionIds = (json['examSessionIds'] as List<dynamic>?)
        ?.map((e) => e?.toString() ?? '')
        .toList() ?? [];
        
    final List<String> ineligibleStudentIds = (json['ineligibleStudentIds'] as List<dynamic>?)
        ?.map((e) => e?.toString() ?? '')
        .toList() ?? [];
    
    // 5. Handle complex objects with extra null checks
    
  CreatedBy? createdBy;
if (json['createdBy'] != null) {
  try {
    // Add more defensive coding to handle potential nulls in the createdBy object
    final createdByJson = json['createdBy'] as Map<String, dynamic>;
    // Ensure all required fields in createdByJson are non-null before passing to fromJson
    if (createdByJson.values.any((value) => value == null)) {
      print('Warning: createdBy contains null values, using null for createdBy');
      createdBy = null;
    } else {
      createdBy = CreatedBy.fromJson(createdByJson);
    }
  } catch (e) {
    print('Error parsing createdBy: $e');
    createdBy = null;
  }
}
    
    ExamGroup examGroup;
    try {
      if (json['examGroup'] != null) {
        examGroup = ExamGroup.fromJson(json['examGroup'] as Map<String, dynamic>);
      } else {
        print('Warning: examGroup is null, using empty examGroup');
        examGroup = ExamGroup.empty();
      }
    } catch (e) {
      print('Error parsing examGroup: $e');
      examGroup = ExamGroup.empty();
    }
    
    Subject subject;
    try {
      if (json['subject'] != null) {
        subject = Subject.fromMap(json['subject'] as Map<String, dynamic>);
      } else {
        // Make sure to implement Subject.empty() in your Subject class
        print('Warning: subject is null, using empty subject');
        throw Exception("Subject cannot be null");
      }
    } catch (e) {
      print('Error parsing subject: $e');
      throw Exception("Failed to parse subject: $e");
    }
    
    // 6. Construct the object with all safely processed fields
    return ExamData(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
      duration: duration,
      totalMark: totalMark,
      totalTheoryMark: totalTheoryMark,
      pin: pin,
      hasPin: hasPin,
      instruction: instruction,
      enabled: enabled,
      isOffline: isOffline,
      showScoreOnSubmission: showScoreOnSubmission,
      showCorrections: showCorrections,
      scoreNotification: scoreNotification,
      strictMode: strictMode,
      showCalculator: showCalculator,
      shuffleCBTQuestions: shuffleCBTQuestions,
      subjectId: subjectId,
      examGroupId: examGroupId,
      questionIds: questionIds,
      classIds: classIds,
      examSessionIds: examSessionIds,
      ineligibleStudentIds: ineligibleStudentIds,
      createdById: createdById,
      questionCount: questionCount,
      createdBy: createdBy,
      subject: subject,
      examGroup: examGroup,
    );
  } catch (e, stackTrace) {
    print('Error in ExamData.fromJson: $e');
    print('Stack trace: $stackTrace');
    
    // Extra debugging to find problematic field
    if (json['subject'] == null) print('subject is null');
    if (json['examGroup'] == null) print('examGroup is null');
    if (json['createdBy'] == null) print('createdBy is null');
    
    rethrow;
  }
}
  // factory ExamData.fromJson(Map<String, dynamic> json) {
  //   // Helper function to safely convert to bool
  //   bool safeBool(dynamic value) {
  //     if (value == null) return false;
  //     if (value is bool) return value;
  //     if (value is String) return value.toLowerCase() == 'true';
  //     return false;
  //   }

  //   log('examjson $json');

  //   try {
  //     return ExamData(
  //       id: json['id']?.toString() ?? '',
  //       name: json['name']?.toString() ?? '',
  //       startDate: json['startDate']?.toString() ?? '',
  //       endDate: json['endDate']?.toString() ?? '',
  //       duration: int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
  //       totalMark: int.tryParse(json['totalMark']?.toString() ?? '0') ?? 0,
  //       totalTheoryMark:
  //           int.tryParse(json['totalTheoryMark']?.toString() ?? '0') ?? 0,
  //       pin: json['pin']?.toString(),
  //       hasPin: safeBool(json['hasPin']),
  //       instruction: json['instruction']?.toString() ?? '',
  //       createdBy: json['createdBy'] != null
  //           ? CreatedBy.fromJson(json['createdBy'])
  //           : null,
  //       enabled: safeBool(json['enabled']),
  //       isOffline: safeBool(json['isOffline']),
  //       showScoreOnSubmission: safeBool(json['showScoreOnSubmission']),
  //       showCorrections: safeBool(json['showCorrections']),
  //       scoreNotification: safeBool(json['scoreNotification']),
  //       strictMode: safeBool(json['strictMode']),
  //       showCalculator: safeBool(json['showCalculator']),
  //       shuffleCBTQuestions: safeBool(json['shuffleCBTQuestions']),
  //       subjectId: json['subjectId']?.toString() ?? '',
  //       examGroupId: json['examGroupId']?.toString() ?? '',
  //       questionIds: (json['questionIds'] as List<dynamic>?)
  //               ?.map((e) => e.toString())
  //               .toList() ??
  //           [],
  //       classIds: (json['classIds'] as List<dynamic>?)
  //               ?.map((e) => e.toString())
  //               .toList() ??
  //           [],
  //       examSessionIds: (json['examSessionIds'] as List<dynamic>?)
  //               ?.map((e) => e.toString())
  //               .toList() ??
  //           [],
  //       ineligibleStudentIds: (json['ineligibleStudentIds'] as List<dynamic>?)
  //               ?.map((e) => e.toString())
  //               .toList() ??
  //           [],
  //       createdById: json['createdById']?.toString() ?? '',
  //       questionCount:
  //           int.tryParse(json['questionCount']?.toString() ?? '0') ?? 0,
  //       examGroup: json['examGroup'] is Map<String, dynamic>
  //           ? ExamGroup.fromJson(json['examGroup'])
  //           : ExamGroup.empty(),
  //       subject: json['subject'] != null
  //           ? Subject.fromMap(json['subject'])
  //           : throw Exception("Subject cannot be null"),
  //     );
  //   } catch (e, stackTrace) {
  //     print('Error in ExamData.fromJson: $e');
  //     print('Stack trace: $stackTrace');
  //     print('Problematic JSON: $json');
  //     rethrow;
  //   }
  // }

  // factory ExamData.fromJson(Map<String, dynamic> json) {
  //   return ExamData(
  //     id: json['id'] ?? '',
  //     name: json['name'] ?? '',
  //     startDate: json['startDate'] ?? '',
  //     endDate: json['endDate'] ?? '',
  //     duration: json['duration']?.toInt() ?? 0,
  //     totalMark: json['totalMark']?.toInt() ?? 0,
  //     totalTheoryMark: json['totalTheoryMark']?.toInt() ?? 0,
  //     pin: json['pin'],
  //     hasPin: json['hasPin'] ?? false, // Removed the explicit cast
  //     instruction: json['instruction'] ?? '',
  //     enabled: json['enabled'] ?? false, // Removed the explicit cast
  //     isOffline: json['isOffline'] ?? false, // Removed the explicit cast
  //     showScoreOnSubmission:
  //         json['showScoreOnSubmission'] ?? false, // Removed the explicit cast
  //     showCorrections:
  //         json['showCorrections'] ?? false, // Removed the explicit cast
  //     scoreNotification:
  //         json['scoreNotification'] ?? false, // Removed the explicit cast
  //     strictMode: json['strictMode'] ?? false, // Removed the explicit cast
  //     showCalculator:
  //         json['showCalculator'] ?? false, // Removed the explicit cast
  //     //  shuffleCBTQuestions: json['shuffleCBTQuestions'] ?? false,  // Added back the field
  //     subjectId: json['subjectId'] ?? '',
  //     examGroupId: json['examGroupId'] ?? '',
  //     questionIds: List<String>.from(json['questionIds'] ?? []),
  //     classIds: List<String>.from(json['classIds'] ?? []),
  //     examSessionIds: List<String>.from(json['examSessionIds'] ?? []),
  //     ineligibleStudentIds:
  //         List<String>.from(json['ineligibleStudentIds'] ?? []),
  //     createdById: json['createdById'] ?? '',
  //     questionCount: json['questionCount']?.toInt() ?? 0,
  //     createdBy: json['createdBy'] != null
  //         ? CreatedBy.fromJson(json['createdBy'])
  //         : throw Exception("CreatedBy cannot be null"),
  //     subject: json['subject'] != null
  //         ? Subject.fromMap(json['subject'])
  //         : throw Exception("Subject cannot be null"),
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'duration': duration,
      'totalMark': totalMark,
      'totalTheoryMark': totalTheoryMark,
      'pin': pin,
      'hasPin': hasPin,
      'instruction': instruction,
      'enabled': enabled,
      'isOffline': isOffline,
      'showScoreOnSubmission': showScoreOnSubmission,
      'showCorrections': showCorrections,
      'scoreNotification': scoreNotification,
      'strictMode': strictMode,
      'showCalculator': showCalculator,
      //'shuffleCBTQuestions': shuffleCBTQuestions,
      'subjectId': subjectId,
      'examGroupId': examGroupId,
      'questionIds': questionIds,
      'classIds': classIds,
      'examSessionIds': examSessionIds,
      'ineligibleStudentIds': ineligibleStudentIds,
      'createdById': createdById,
      'questionCount': questionCount,
      //'createdBy': createdBy.toJson(),
      // 'subject': subject.(),
    };
  }

  static String formatDateWithSuffix(DateTime date) {
    final day = date.day;
    final suffix = _getDaySuffix(day);
    final formattedDate = DateFormat("d'$suffix' MMM yyyy").format(date);
    final formattedTime =
        DateFormat('hh:mm a').format(date); // 12-hour format with AM/PM
    return '$formattedDate - $formattedTime';
  }

  static String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

class ExamGroup {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool groupEnabled;
  final String sessionId;
  final String termId;
  final List<String> classIds;
  final List<String> examIds;
  final String spaceId;
  final String createdById;
  final String createdAt;
  final String updatedAt;
  final int examCount;

  ExamGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.groupEnabled,
    required this.sessionId,
    required this.termId,
    required this.classIds,
    required this.examIds,
    required this.spaceId,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    required this.examCount,
  });

  factory ExamGroup.fromJson(Map<String, dynamic> json) {
    return ExamGroup(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      groupEnabled: json['groupEnabled'] ?? false,
      sessionId: json['sessionId']?.toString() ?? '',
      termId: json['termId']?.toString() ?? '',
      classIds: (json['classIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      examIds: (json['examIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      spaceId: json['spaceId']?.toString() ?? '',
      createdById: json['createdById']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      examCount: int.tryParse(json['examCount']?.toString() ?? '0') ?? 0,
    );
  }

  factory ExamGroup.empty() {
    return ExamGroup(
      id: '',
      name: '',
      description: '',
      category: '',
      groupEnabled: false,
      sessionId: '',
      termId: '',
      classIds: [],
      examIds: [],
      spaceId: '',
      createdById: '',
      createdAt: '',
      updatedAt: '',
      examCount: 0,
    );
  }
}

class CreatedBy {
  final String id;
  final String spaceId;
  final String role;
  // final User? user;
  final Space? space;

  CreatedBy(
      {required this.id,
      required this.spaceId,
      required this.role,
      // this.user,
      this.space});

factory CreatedBy.fromJson(Map<String, dynamic> json) {
  Space? spaceObj;
  if (json['space'] != null) {
    try {
      spaceObj = Space.fromJson(json['space'] as Map<String, dynamic>);
    } catch (e) {
      print('Error parsing space in CreatedBy: $e');
      // Fall back to null
    }
  }

  return CreatedBy(
    id: json['id']?.toString() ?? '',
    spaceId: json['spaceId']?.toString() ?? '',
    role: json['role']?.toString() ?? '',
    // user: json['user'] != null ? User.fromJson(json['user']) : null,
    space: spaceObj, // This will be null if space couldn't be parsed
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceId': spaceId,
      'role': role,
      // 'user': user?.toJson(),
    };
  }

  factory CreatedBy.empty() {
    return CreatedBy(
      id: '',
      spaceId: '',
      role: '',
    );
  }
}

class Space {
  final String? id;
  final String? name;
  final String? description;
  final String? alias;
  final String? logo;

  Space({
    this.id,
    this.name,
    this.description,
    this.alias,
    this.logo,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      alias: json['alias'] as String?,
      logo: json['logo'] as String?,
    );
  }
}
// class User {
//   final String id;
//   final String firstName;
//   final String lastName;
//   final String username;
//   final String phoneNumber;
//   final String email;
//   final String? profileImageUrl;
//   final String gender;
//   final String dateOfBirth;
//   final String country;
//   final String state;
//   final String city;
//   final String address;
//   final String type;

//   User({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.username,
//     required this.phoneNumber,
//     required this.email,
//     this.profileImageUrl,
//     required this.gender,
//     required this.dateOfBirth,
//     required this.country,
//     required this.state,
//     required this.city,
//     required this.address,
//     required this.type,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       username: json['username'],
//       phoneNumber: json['phoneNumber'],
//       email: json['email'],
//       profileImageUrl: json['profileImageUrl'],
//       gender: json['gender'],
//       dateOfBirth: json['dateOfBirth'],
//       country: json['country'],
//       state: json['state'],
//       city: json['city'],
//       address: json['address'],
//       type: json['type'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'username': username,
//       'phoneNumber': phoneNumber,
//       'email': email,
//       'profileImageUrl': profileImageUrl,
//       'gender': gender,
//       'dateOfBirth': dateOfBirth,
//       'country': country,
//       'state': state,
//       'city': city,
//       'address': address,
//       'type': type,
//     };
//   }
// }

// class Space {
//   final String id;
//   final String name;
//   final String description;
//   final String alias;
//   final String? logo;

//   Space({required this.id, required this.name, required this.description, required this.alias, this.logo});

//   factory Space.fromJson(Map<String, dynamic> json) {
//     return Space(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       alias: json['alias'],
//       logo: json['logo'],
//     );
//   }
// }

enum QuestionType { objective, theory }

class HomeworkModel {
  HomeworkModel(
      {required this.groupName,
      required this.subject,
      required this.task,
      required this.date,
      required this.questions,
      required this.duration,
      required this.mark
      //  this.submissions,
      });

  final String subject;
  final String task;
  final DateTime date;
  final List<HomeworkQuestion> questions;
  final Duration duration;
  //final List<SubmittedHomework>? submissions;
  final String groupName;
  final int mark;

  static String formatDateWithSuffix(DateTime date) {
    final day = date.day;
    final suffix = _getDaySuffix(day);
    final formattedDate = DateFormat("d'$suffix' MMM yyyy").format(date);
    final formattedTime =
        DateFormat('hh:mm a').format(date); // 12-hour format with AM/PM
    return '$formattedDate - $formattedTime';
  }

  static String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

class SubmittedHomework {
  SubmittedHomework({
    required this.studentName,
    required this.answers,
    required this.submissionDate,
    this.grade,
  });

  final String studentName;
  final Map<int, String> answers; // Question index -> Answer
  final DateTime submissionDate;
  final double? grade;
}

class HomeworkQuestion {
  HomeworkQuestion({
    required this.question,
    required this.type,
    required this.answer,
    required this.questionNumber,
    required this.explanation,
    this.questionImage, // Optional image for the question
    this.optionImages, // Optional images for each option
  });

  final String question;
  final QuestionType
      type; // "object" for options, "theory" for text input/upload
  final List<String> answer;
  final int questionNumber;
  final String explanation;
  final String? questionImage; // URL or path for the question image
  final List<String?>? optionImages; // List of URLs/paths for each option

  List<String>? _shuffledAnswers;

  List<String> get shuffledAnswers {
    _shuffledAnswers ??= List.of(answer)..shuffle();
    return _shuffledAnswers!;
  }
}

List<Map<String, dynamic>> generateSummaryInfo(
  Map<int, int?> selectedAnswers,
  List<String> chosenAnswer,
  HomeworkModel homeworkModel,
) {
  final List<Map<String, dynamic>> summary = [];

  for (var i = 0; i < selectedAnswers.length; i++) {
    if (i < chosenAnswer.length) {
      summary.add({
        'question_index': i,
        // 'question': homeworkModel.questions[i].question,
        // 'correct_answer': homeworkModel.questions[i].answer[0],
        'chosen_answer': chosenAnswer[i],
      });
    }
  }

  return summary;
}
