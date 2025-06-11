import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/user_model.dart' show User;

class GetStudentAccountingFeesResponse {
  final List<StudentFeeSecond> data;
  final PaginationMeta meta;

  GetStudentAccountingFeesResponse({required this.data, required this.meta});

  factory GetStudentAccountingFeesResponse.fromJson(Map<String, dynamic> json) {
    try {
      log('Parsing GetStudentAccountingFeesResponse');

      final responseData = json['getStudentAccountingFees'];
      if (responseData == null) {
        return GetStudentAccountingFeesResponse(
          data: [],
          meta: PaginationMeta.empty(),
        );
      }

      final dataList = responseData['data'] as List<dynamic>? ?? [];
      final List<StudentFeeSecond> fees = [];

      for (var item in dataList) {
        try {
          if (item is Map<String, dynamic>) {
            final fee = StudentFeeSecond.fromJson(item);
            fees.add(fee);
          }
        } catch (e) {
          log('Error parsing individual fee: $e');
          continue;
        }
      }

      return GetStudentAccountingFeesResponse(
        data: fees,
        meta: responseData['meta'] != null
            ? PaginationMeta.fromJson(
                responseData['meta'] as Map<String, dynamic>)
            : PaginationMeta.empty(),
      );
    } catch (e, stackTrace) {
      log('Error in GetStudentAccountingFeesResponse.fromJson: $e');
      log('Stack trace: $stackTrace');
      return GetStudentAccountingFeesResponse(
        data: [],
        meta: PaginationMeta.empty(),
      );
    }
  }
}

class PaginationMeta {
  final int? pageSize;
  final String? nextCursor;
  final bool? hasMore;

  PaginationMeta({this.pageSize, this.nextCursor, this.hasMore});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    try {
      return PaginationMeta(
        pageSize: json['pageSize'] as int?,
        nextCursor: json['nextCursor']?.toString(),
        hasMore: json['hasMore'] as bool?,
      );
    } catch (e) {
      log('Error parsing PaginationMeta: $e');
      return PaginationMeta.empty();
    }
  }

  factory PaginationMeta.empty() => PaginationMeta();
}

class StudentFeeSecond {
  final String? id;
  final String? classFeeId;
  final String? studentTagId;
  final String? studentTagFeeId;
  final String? accountingComputationId;
  final StudentData? student;
  final PaymentItem paymentItem;
  final Class classData;
  final SpaceTerm spaceTerm;
  final SpaceSession spaceSession;
  final Discount? discount;
  final String? feeAmount;
  final String? amount;
  final String? amountPaid;
  final String? discountAmount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  StudentFeeSecond({
    this.id,
    this.classFeeId,
    this.studentTagId,
    this.studentTagFeeId,
    this.accountingComputationId,
    this.student,
    required this.paymentItem,
    required this.classData,
    required this.spaceTerm,
    required this.spaceSession,
    this.discount,
    this.feeAmount,
    this.amount,
    this.amountPaid,
    this.discountAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentFeeSecond.fromJson(Map<String, dynamic>? json) {
    try {
      log('Parsing StudentFee');

      if (json == null) {
        log('StudentFee json is null');
        return StudentFeeSecond.empty();
      }

      // Create a clean copy without __typename
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      // Parse Student
      StudentData? student;
      if (cleanJson['student'] != null) {
        try {
          student = StudentData.fromJson(
              cleanJson['student'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing Student: $e');
        }
      }

      // Parse PaymentItem
      PaymentItem paymentItem = PaymentItem.empty();
      if (cleanJson['paymentItem'] != null) {
        try {
          paymentItem = PaymentItem.fromJson(
              cleanJson['paymentItem'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing PaymentItem: $e');
        }
      }

      // Parse Class
      Class classData = Class.empty();
      if (cleanJson['class'] != null) {
        try {
          classData =
              Class.fromJson(cleanJson['class'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing Class: $e');
        }
      }

      // Parse SpaceTerm
      SpaceTerm spaceTerm = SpaceTerm.empty();
      if (cleanJson['spaceTerm'] != null) {
        try {
          spaceTerm = SpaceTerm.fromJson(
              cleanJson['spaceTerm'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing SpaceTerm: $e');
        }
      }

      // Parse SpaceSession
      SpaceSession spaceSession = SpaceSession.empty();
      if (cleanJson['spaceSession'] != null) {
        try {
          spaceSession = SpaceSession.fromJson(
              cleanJson['spaceSession'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing SpaceSession: $e');
        }
      }

      // Parse Discount
      Discount? discount;
      if (cleanJson['discount'] != null) {
        try {
          discount =
              Discount.fromJson(cleanJson['discount'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing Discount: $e');
        }
      }

      return StudentFeeSecond(
        id: cleanJson['id']?.toString(),
        classFeeId: cleanJson['classFeeId']?.toString(),
        studentTagId: cleanJson['studentTagId']?.toString(),
        studentTagFeeId: cleanJson['studentTagFeeId']?.toString(),
        accountingComputationId:
            cleanJson['accountingComputationId']?.toString(),
        student: student,
        paymentItem: paymentItem,
        classData: classData,
        spaceTerm: spaceTerm,
        spaceSession: spaceSession,
        discount: discount,
        feeAmount: cleanJson['feeAmount']?.toString(),
        amount: cleanJson['amount']?.toString(),
        amountPaid: cleanJson['amountPaid']?.toString(),
        discountAmount: cleanJson['discountAmount']?.toString(),
        status: cleanJson['status']?.toString(),
        createdAt: cleanJson['createdAt']?.toString(),
        updatedAt: cleanJson['updatedAt']?.toString(),
      );
    } catch (e, stackTrace) {
      log('Error parsing StudentFee: $e');
      log('Stack trace: $stackTrace');
      return StudentFeeSecond.empty();
    }
  }

  factory StudentFeeSecond.empty() => StudentFeeSecond(
        paymentItem: PaymentItem.empty(),
        classData: Class.empty(),
        spaceTerm: SpaceTerm.empty(),
        spaceSession: SpaceSession.empty(),
      );
}

class StudentData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? profilePicture;
  final User? user;
  final SpaceWallet? spaceWallet;

  StudentData({
    this.id,
    this.firstName,
    this.lastName,
    this.middleName,
    this.profilePicture,
    this.user,
    this.spaceWallet,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    try {
      log('Parsing StudentData');

      // Remove GraphQL typename
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      // Parse User
      User? user;
      if (cleanJson['user'] != null) {
        try {
          user = User.fromJson(cleanJson['user'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing User: $e');
        }
      }

      // Parse SpaceWallet
      SpaceWallet? spaceWallet;
      if (cleanJson['spaceWallet'] != null) {
        try {
          spaceWallet = SpaceWallet.fromJson(
              cleanJson['spaceWallet'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing SpaceWallet: $e');
        }
      }

      return StudentData(
        id: cleanJson['id']?.toString(),
        firstName: cleanJson['firstName']?.toString(),
        lastName: cleanJson['lastName']?.toString(),
        middleName: cleanJson['middleName']?.toString(),
        profilePicture: cleanJson['profilePicture']?.toString(),
        user: user,
        spaceWallet: spaceWallet,
      );
    } catch (e) {
      log('Error parsing StudentData: $e');
      return StudentData();
    }
  }
}

class SpaceWallet {
  final String? id;
  final String? balance;

  SpaceWallet({this.id, this.balance});

  factory SpaceWallet.fromJson(Map<String, dynamic> json) {
    try {
      // Remove GraphQL typename
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      return SpaceWallet(
        id: cleanJson['id']?.toString(),
        balance: cleanJson['balance']?.toString(),
      );
    } catch (e) {
      log('Error parsing SpaceWallet: $e');
      return SpaceWallet();
    }
  }
}

// class User {
//   final String? id;
//   final String? firstName;
//   final String? lastName;

//   User({this.id, this.firstName, this.lastName});

//   factory User.fromJson(Map<String, dynamic> json) {
//     try {
//       // Remove GraphQL typename
//       final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
//       cleanJson.remove('__typename');

//       return User(
//         id: cleanJson['id']?.toString(),
//         firstName: cleanJson['firstName']?.toString(),
//         lastName: cleanJson['lastName']?.toString(),
//       );
//     } catch (e) {
//       log('Error parsing User: $e');
//       return User();
//     }
//   }

//   factory User.empty() => User();
// }

class PaymentItem {
  final String? id;
  final String? feeName;

  PaymentItem({this.id, this.feeName});

  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename field if present
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      return PaymentItem(
        id: cleanJson['id']?.toString(),
        feeName: cleanJson['feeName']?.toString(),
      );
    } catch (e) {
      log('Error parsing PaymentItem: $e');
      return PaymentItem.empty();
    }
  }

  factory PaymentItem.empty() => PaymentItem(id: '', feeName: '');
}

class Class {
  final String? id;
  final String? name;
  final ClassGroup classGroup;

  Class({this.id, this.name, required this.classGroup});

  factory Class.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename field if present
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      ClassGroup classGroup = ClassGroup.empty();
      if (cleanJson['classGroup'] != null) {
        try {
          classGroup = ClassGroup.fromJson(
              cleanJson['classGroup'] as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing ClassGroup: $e');
        }
      }

      return Class(
        id: cleanJson['id']?.toString(),
        name: cleanJson['name']?.toString(),
        classGroup: classGroup,
      );
    } catch (e) {
      log('Error parsing Class: $e');
      return Class.empty();
    }
  }

  factory Class.empty() =>
      Class(id: '', name: '', classGroup: ClassGroup.empty());
}

class ClassGroup {
  final String? id;
  final String? name;

  ClassGroup({this.id, this.name});

  factory ClassGroup.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename field if present
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      return ClassGroup(
        id: cleanJson['id']?.toString(),
        name: cleanJson['name']?.toString(),
      );
    } catch (e) {
      log('Error parsing ClassGroup: $e');
      return ClassGroup.empty();
    }
  }

  factory ClassGroup.empty() => ClassGroup(id: '', name: '');
}

class SpaceTerm {
  final String? id;
  final String? name;

  SpaceTerm({this.id, this.name});

  factory SpaceTerm.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename field if present
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      return SpaceTerm(
        id: cleanJson['id']?.toString(),
        name: cleanJson['name']?.toString(),
      );
    } catch (e) {
      log('Error parsing SpaceTerm: $e');
      return SpaceTerm.empty();
    }
  }

  factory SpaceTerm.empty() => SpaceTerm(id: '', name: '');
}

class SpaceSession {
  final String? id;
  final String? session;

  SpaceSession({this.id, this.session});

  factory SpaceSession.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename field if present
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      return SpaceSession(
        id: cleanJson['id']?.toString(),
        session: cleanJson['session']?.toString(),
      );
    } catch (e) {
      log('Error parsing SpaceSession: $e');
      return SpaceSession.empty();
    }
  }

  factory SpaceSession.empty() => SpaceSession(id: '', session: '');
}

class Discount {
  final String? id;
  final String? title;

  Discount({this.id, this.title});

  factory Discount.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename field if present
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      return Discount(
        id: cleanJson['id']?.toString(),
        title: cleanJson['title']?.toString(),
      );
    } catch (e) {
      log('Error parsing Discount: $e');
      return Discount();
    }
  }
}
