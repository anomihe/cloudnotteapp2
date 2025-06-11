String getStudentFeeQuery = r"""
query GetFeePayments($input: GetFeePaymentsInput!) {
  getFeePayments(input: $input) {
    data {
      id
      spaceId
      student {
        id
        user {
          id
          firstName
          lastName
          username
          gender
        }
      }
      amountPaid
      studentFeeId
      studentFee {
        id
        classFeeId
        studentTagId
        studentTagFeeId
        accountingComputationId
        paymentItem {
          id
          feeName
        }
        class {
          id
          name
          classGroup {
            id
            name
          }
        }
        spaceTerm {
          id
          name
        }
        spaceSession {
          id
          session
        }
        discount {
          id
          title
        }
        feeAmount
        amount
        amountPaid
        discountAmount
        status
        createdAt
        updatedAt
      }
      processedByAdminUserId
      paymentMethod
      status
      transactionId
      bankTransactionId
      createdAt
      updatedAt
    }
    meta {
      hasMore
      nextCursor
      pageSize
    }
  }
}
""";
String getStudentAccountingFeesQuery = r"""
query GetStudentAccountingFees($input: GetStudentAccountingFeesInput!) {
  getStudentAccountingFees(input: $input) {
    data {
      id
      classFeeId
      studentTagId
      studentTagFeeId
      accountingComputationId
      student {
        id
        firstName
        lastName
        middleName
        profilePicture
        user {
          id
          firstName
          lastName
        }
        spaceWallet {
          id
          balance
        }
      }
      paymentItem {
        id
        feeName
      }
      class {
        id
        name
        classGroup {
          id
          name
        }
      }
      spaceTerm {
        id
        name
      }
      spaceSession {
        id
        session
      }
      discount {
        id
        title
      }
      feeAmount
      amount
      amountPaid
      discountAmount
      status
      createdAt
      updatedAt
    }
    meta {
      pageSize
      nextCursor
      hasMore
    }
  }
}""";

String getSettlementAccountQuery =
    r"""query GetSettlementAccounts($input: GetSettlementAccountsInput!) {
  getSettlementAccounts(input: $input) {
    id
    accountName
    accountNumber
    bankName
    bankCode
    countryCode
    provider
    subAccount
    subAccountId
    deletedAt
    createdAt
  }
}""";

String getSummaryFeeQuery =
    r"""query GetSpaceAccountingSummary($input: GetSpaceAccountingSummaryInput!) {
  getSpaceAccountingSummary(input: $input) {
    totalAmountReceived
    totalDiscountsApplied
    totalExpectedAmount
    totalOutstandingAmount
    totalOriginalAmount
  }
}""";

String getPaymentItemSummary =
    r"""query GetPaymentItems($input: GetPaymentItemsInput!) {
  getPaymentItems(input: $input) {
    data {
      id
      feeName
      isCompulsory
      spaceId
      createdById
      createdAt
      updatedAt
    }
    meta {
      pageSize
      nextCursor
      hasMore
    }
  }
}""";

String getPaymentItemSummaryQuery =
    r"""query GetPaymentItemSummary($input: GetPaymentItemSummaryInput!) {
  getPaymentItemSummary(input: $input) {
    totalAmountReceived
    totalDiscountsApplied
    totalExpectedAmount
    totalOutstandingAmount
    totalOriginalAmount
  }
}""";

String getClassAccounting = r"""
query GetAccountingClassesFeeSummary($input: GetAccountingClassesFeeSummaryInput!) {
  getAccountingClassesFeeSummary(input: $input) {
    data {
      totalAmountReceived
      totalExpectedAmount
      totalOutstandingAmount
      classId
      class {
        id
        name
        classGroup {
          id
          name
        }
      }
    }
    meta {
      pageSize
      nextCursor
      hasMore
    }
  }
}""";

String getFeeHistoryQuery =
    r"""query GetFeePayments($input: GetFeePaymentsInput!) {
  getFeePayments(input: $input) {
    data {
      id
      spaceId
      student {
        id
        user {
          id
          firstName
          lastName
          username
          gender
        }
      }
      amountPaid
      studentFeeId
      studentFee {
        id
        classFeeId
        studentTagId
        studentTagFeeId
        accountingComputationId
        paymentItem {
          id
          feeName
        }
        class {
          id
          name
          classGroup {
            id
            name
          }
        }
        spaceTerm {
          id
          name
        }
        spaceSession {
          id
          session
        }
        discount {
          id
          title
        }
        feeAmount
        amount
        amountPaid
        discountAmount
        status
        createdAt
        updatedAt
      }
      processedByAdminUserId
      paymentMethod
      status
      transactionId
      bankTransactionId
      createdAt
      updatedAt
    }
    meta {
      hasMore
      nextCursor
      pageSize
    }
  }
}""";
