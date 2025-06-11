// Top-level response model
import 'dart:developer';

import 'package:cloudnottapp2/src/data/models/user_model.dart' show User;

class FeePayment {
  final String? id;
  final String? spaceId;
  final Student student;
  final String? amountPaid;
  final String? studentFeeId;
  final StudentFee studentFee;
  final String? processedByAdminUserId;
  final String? paymentMethod;
  final String? status;
  final String? transactionId;
  final String? bankTransactionId;
  final String? createdAt;
  final String? updatedAt;

  FeePayment({
    this.id,
    this.spaceId,
    required this.student,
    this.amountPaid,
    this.studentFeeId,
    required this.studentFee,
    this.processedByAdminUserId,
    this.paymentMethod,
    this.status,
    this.transactionId,
    this.bankTransactionId,
    this.createdAt,
    this.updatedAt,
  });

  factory FeePayment.fromJson(Map<String, dynamic> json) {
    try {
      log('Parsing FeePayment: ${json.toString()}');

      // Handle student object
      final studentJson = json['student'] as Map<String, dynamic>?;
      final Student student =
          studentJson != null ? Student.fromJson(studentJson) : Student.empty();

      // Handle studentFee object
      final studentFeeJson = json['studentFee'] as Map<String, dynamic>?;
      final StudentFee studentFee = studentFeeJson != null
          ? StudentFee.fromJson(studentFeeJson)
          : StudentFee.empty();

      return FeePayment(
        id: json['id']?.toString(),
        spaceId: json['spaceId']?.toString(),
        student: student,
        amountPaid: json['amountPaid']?.toString(),
        studentFeeId: json['studentFeeId']?.toString(),
        studentFee: studentFee,
        processedByAdminUserId: json['processedByAdminUserId']?.toString(),
        paymentMethod: json['paymentMethod']?.toString(),
        status: json['status']?.toString(),
        transactionId: json['transactionId']?.toString(),
        bankTransactionId: json['bankTransactionId']?.toString(),
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
      );
    } catch (e, stackTrace) {
      log('Error in FeePayment.fromJson: $e');
      log('Stack trace: $stackTrace');
      return FeePayment.empty();
    }
  }

  factory FeePayment.empty() => FeePayment(
        student: Student.empty(),
        studentFee: StudentFee.empty(),
      );
}

class Student {
  final String? id;
  final User? user;

  Student({this.id, this.user});

  factory Student.fromJson(Map<String, dynamic> json) {
    try {
      log('Parsing Student: ${json.toString()}');

      // Remove GraphQL typename
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

      // Parse user data
      User? user;
      if (cleanJson['user'] != null) {
        user = User.fromJson(cleanJson['user'] as Map<String, dynamic>);
      }

      return Student(
        id: cleanJson['id']?.toString(),
        user: user,
      );
    } catch (e) {
      log('Error parsing Student: $e');
      return Student.empty();
    }
  }

  factory Student.empty() => Student(id: '', user: null);
}

// class User {
//   final String? id;
//   final String? firstName;
//   final String? lastName;
//   final String? email;

//   User({this.id, this.firstName, this.lastName, this.email});

//   factory User.fromJson(Map<String, dynamic> json) {
//     try {
//       // Remove GraphQL typename
//       final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
//       cleanJson.remove('__typename');

//       return User(
//         id: cleanJson['id']?.toString(),
//         firstName: cleanJson['firstName']?.toString(),
//         lastName: cleanJson['lastName']?.toString(),
//         email: cleanJson['email']?.toString(),
//       );
//     } catch (e) {
//       log('Error parsing User: $e');
//       return User.empty();
//     }
//   }

//   factory User.empty() => User();
// }

class StudentFee {
  final String? id;
  final String? classFeeId;
  final String? studentTagId;
  final String? studentTagFeeId;
  final String? accountingComputationId;
  final PaymentItem paymentItem;
  final Class classData; // Changed from classInfo to classData to match JSON
  final SpaceTerm spaceTerm;
  final SpaceSession spaceSession;
  final String? discount;
  final String? feeAmount;
  final String? amount;
  final String? amountPaid;
  final String? discountAmount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  StudentFee({
    this.id,
    this.classFeeId,
    this.studentTagId,
    this.studentTagFeeId,
    this.accountingComputationId,
    required this.paymentItem,
    required this.classData, // Changed from classInfo to classData
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

  factory StudentFee.fromJson(Map<String, dynamic>? json) {
    try {
      log('Parsing StudentFee: ${json.toString()}');

      if (json == null) {
        log('StudentFee json is null');
        return StudentFee.empty();
      }

      // Create a clean copy without __typename
      final Map<String, dynamic> cleanJson = Map<String, dynamic>.from(json);
      cleanJson.remove('__typename');

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
        // Note: JSON field is 'class'
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

      return StudentFee(
        id: cleanJson['id']?.toString(),
        classFeeId: cleanJson['classFeeId']?.toString(),
        studentTagId: cleanJson['studentTagId']?.toString(),
        studentTagFeeId: cleanJson['studentTagFeeId']?.toString(),
        accountingComputationId:
            cleanJson['accountingComputationId']?.toString(),
        paymentItem: paymentItem,
        classData: classData, // Changed from classInfo to classData
        spaceTerm: spaceTerm,
        spaceSession: spaceSession,
        discount: cleanJson['discount']?.toString(),
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
      log('Raw JSON: ${json?.toString()}');
      return StudentFee.empty();
    }
  }

  factory StudentFee.empty() => StudentFee(
        paymentItem: PaymentItem.empty(),
        classData: Class.empty(), // Changed from classInfo to classData
        spaceTerm: SpaceTerm.empty(),
        spaceSession: SpaceSession.empty(),
      );
}

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

class GetFeePayments {
  final List<FeePayment> data;
  final Meta meta;

  GetFeePayments({required this.data, required this.meta});

  factory GetFeePayments.fromJson(Map<String, dynamic> json) {
    try {
      log('Parsing GetFeePayments: ${json.toString()}');

      final list = json['data'] as List<dynamic>? ?? [];
      final List<FeePayment> feePayments = [];

      for (var item in list) {
        try {
          if (item is Map<String, dynamic>) {
            final payment = FeePayment.fromJson(item);
            feePayments.add(payment);
          }
        } catch (e) {
          log('Error parsing individual payment: $e');
          continue; // Skip invalid items
        }
      }

      return GetFeePayments(
        data: feePayments,
        meta: json['meta'] != null
            ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
            : Meta.empty(),
      );
    } catch (e, stackTrace) {
      log('Error in GetFeePayments.fromJson: $e');
      log('Stack trace: $stackTrace');
      return GetFeePayments(data: [], meta: Meta.empty());
    }
  }
}

class Meta {
  final int? total;
  final int? currentPage;
  final int? pageCount;
  final int? perPage;

  Meta({this.total, this.currentPage, this.pageCount, this.perPage});

  factory Meta.fromJson(Map<String, dynamic> json) {
    try {
      return Meta(
        total: json['total'] as int?,
        currentPage: json['currentPage'] as int?,
        pageCount: json['pageCount'] as int?,
        perPage: json['perPage'] as int?,
      );
    } catch (e) {
      log('Error parsing Meta: $e');
      return Meta.empty();
    }
  }

  factory Meta.empty() => Meta();
}

class SettlementAccount {
  final String? id;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? bankCode;
  final String? countryCode;
  final String? provider;
  final String? subAccount;
  final String? subAccountId;
  final String? deletedAt;
  final String? createdAt;

  SettlementAccount({
    this.id,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.bankCode,
    this.countryCode,
    this.provider,
    this.subAccount,
    this.subAccountId,
    this.deletedAt,
    this.createdAt,
  });

  factory SettlementAccount.fromJson(Map<String, dynamic> json) {
    return SettlementAccount(
      id: json['id'] as String?,
      accountName: json['accountName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      bankName: json['bankName'] as String?,
      bankCode: json['bankCode'] as String?,
      countryCode: json['countryCode'] as String?,
      provider: json['provider'] as String?,
      subAccount: json['subAccount'] as String?,
      subAccountId: json['subAccountId'] as String?,
      deletedAt: json['deletedAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'bankCode': bankCode,
      'countryCode': countryCode,
      'provider': provider,
      'subAccount': subAccount,
      'subAccountId': subAccountId,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
    };
  }

  factory SettlementAccount.empty() => SettlementAccount();
}

class SpaceAccountingSummary {
  final String totalAmountReceived;
  final String totalDiscountsApplied;
  final String totalExpectedAmount;
  final String totalOutstandingAmount;
  final String totalOriginalAmount;

  SpaceAccountingSummary({
    required this.totalAmountReceived,
    required this.totalDiscountsApplied,
    required this.totalExpectedAmount,
    required this.totalOutstandingAmount,
    required this.totalOriginalAmount,
  });

  // factory SpaceAccountingSummary.fromJson(Map<String, dynamic> json) {
  //   return SpaceAccountingSummary(
  //     totalAmountReceived: json['totalAmountReceived'] ?? '0',
  //     totalDiscountsApplied: json['totalDiscountsApplied'] ?? '0',
  //     totalExpectedAmount: json['totalExpectedAmount'] ?? '0',
  //     totalOutstandingAmount: json['totalOutstandingAmount'] ?? '0',
  //     totalOriginalAmount: json['totalOriginalAmount'] ?? '0',
  //   );
  // }
  factory SpaceAccountingSummary.fromJson(Map<String, dynamic> json) {
    return SpaceAccountingSummary(
      totalAmountReceived: _parseToString(json['totalAmountReceived']),
      totalDiscountsApplied: _parseToString(json['totalDiscountsApplied']),
      totalExpectedAmount: _parseToString(json['totalExpectedAmount']),
      totalOutstandingAmount: _parseToString(json['totalOutstandingAmount']),
      totalOriginalAmount: _parseToString(json['totalOriginalAmount']),
    );
  }

  // static String _parseToString(dynamic value) {
  //   if (value == null) return '0';
  //   return value.toString();
  // }
  static String _parseToString(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '0';
    return value.toString();
  }
}

class PaymentItemsResponse {
  final List<PaymentItem> data;
  final PaymentItemsMeta meta;

  PaymentItemsResponse({required this.data, required this.meta});

  factory PaymentItemsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentItemsResponse(
      data: (json['data'] as List)
          .map((item) => PaymentItem.fromJson(item))
          .toList(),
      meta: PaymentItemsMeta.fromJson(json['meta']),
    );
  }
}

class PaymentItemSecond {
  final String id;
  final String feeName;
  final bool isCompulsory;
  final String spaceId;
  final String createdById;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentItemSecond({
    required this.id,
    required this.feeName,
    required this.isCompulsory,
    required this.spaceId,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentItemSecond.fromJson(Map<String, dynamic> json) {
    return PaymentItemSecond(
      id: json['id'],
      feeName: json['feeName'],
      isCompulsory: json['isCompulsory'],
      spaceId: json['spaceId'],
      createdById: json['createdById'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentItemSecond && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class PaymentItemsMeta {
  final int pageSize;
  final String? nextCursor;
  final bool hasMore;

  PaymentItemsMeta({
    required this.pageSize,
    this.nextCursor,
    required this.hasMore,
  });

  factory PaymentItemsMeta.fromJson(Map<String, dynamic> json) {
    return PaymentItemsMeta(
      pageSize: json['pageSize'],
      nextCursor: json['nextCursor'],
      hasMore: json['hasMore'],
    );
  }
}

class AccountingClassesFeeSummary {
  final List<ClassFeeData> data;
  final Meta meta;

  AccountingClassesFeeSummary({
    required this.data,
    required this.meta,
  });

  factory AccountingClassesFeeSummary.fromJson(Map<String, dynamic> json) {
    return AccountingClassesFeeSummary(
      data: (json['data'] as List)
          .map((item) => ClassFeeData.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class ClassFeeData {
  final String totalAmountReceived;
  final String totalExpectedAmount;
  final int totalOutstandingAmount;
  final String classId;
  final Class classInfo;

  ClassFeeData({
    required this.totalAmountReceived,
    required this.totalExpectedAmount,
    required this.totalOutstandingAmount,
    required this.classId,
    required this.classInfo,
  });

  factory ClassFeeData.fromJson(Map<String, dynamic> json) {
    return ClassFeeData(
      totalAmountReceived: json['totalAmountReceived'].toString(),
      totalExpectedAmount: json['totalExpectedAmount'].toString(),
      totalOutstandingAmount: json['totalOutstandingAmount'] ?? 0,
      classId: json['classId'],
      classInfo: Class.fromJson(json['class']),
    );
  }
}

// class Meta {
//   final int pageSize;
//   final String? nextCursor;
//   final bool hasMore;

//   Meta({
//     required this.pageSize,
//     required this.nextCursor,
//     required this.hasMore,
//   });

//   factory Meta.fromJson(Map<String, dynamic> json) {
//     return Meta(
//       pageSize: json['pageSize'],
//       nextCursor: json['nextCursor'],
//       hasMore: json['hasMore'],
//     );
//   }
// }
