import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/accounting_models.dart'
    show FeePayment;
import 'package:cloudnottapp2/src/data/providers/accounting_providers.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/accounting/transaction_details_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum TransactionStatus {
  successful,
  failed,
}

enum PaymentType {
  cashInHand,
  wallet,
  bankTransfer,
  cardPayment,
}

enum SortOption {
  date,
  successful,
  failed,
  bankTransfer,
  cardPayment,
  wallet,
  cashInHand,
}

class TransactionHistoryScreen extends StatefulWidget {
  static const routeName = '/TransactionHistoryScreen';

  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, List<TransactionModel>> _groupedTransactions = {};

  final Map<PaymentType, Color> _paymentTypeColors = {
    PaymentType.cashInHand: Colors.green,
    PaymentType.wallet: Colors.deepPurpleAccent,
    PaymentType.bankTransfer: Colors.orange,
    PaymentType.cardPayment: blueShades[0],
  };

  final Map<PaymentType, IconData> _paymentTypeIcons = {
    PaymentType.cashInHand: Icons.money,
    PaymentType.wallet: Icons.account_balance_wallet,
    PaymentType.bankTransfer: Icons.account_balance,
    PaymentType.cardPayment: Icons.credit_card,
  };

  SortOption? _currentSort;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final provider = Provider.of<AccountingProvider>(context, listen: false);
      _filterTransactions(provider.accountStudentHistoryData);
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _groupTransactions(transactions);
  //   _searchController.addListener(_filterTransactions);
  // }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _groupTransactions(List<TransactionModel> transactionsList) {
    _groupedTransactions.clear();

    // Sort the full list by date first (newest to oldest)
    transactionsList.sort((a, b) => b.date.compareTo(a.date));

    // Group by month-year
    for (var transaction in transactionsList) {
      final monthYear = DateFormat('MMMM yyyy').format(transaction.date);
      if (!_groupedTransactions.containsKey(monthYear)) {
        _groupedTransactions[monthYear] = [];
      }
      _groupedTransactions[monthYear]!.add(transaction);
    }

    // Sort the map keys to ensure consistent order (newest to oldest)
    final sortedKeys = _groupedTransactions.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a);
        final dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA);
      });

    // Create a new map with sorted keys
    final sortedMap = Map<String, List<TransactionModel>>.fromEntries(
      sortedKeys.map((key) => MapEntry(key, _groupedTransactions[key]!)),
    );

    setState(() {
      _groupedTransactions.clear();
      _groupedTransactions.addAll(sortedMap);
    });
  }

  void _filterTransactions(List<FeePayment> feePayments) {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      // Show all transactions if search query is empty
      final transactions = _convertToTransactionModels(feePayments);
      _groupTransactions(transactions);
    } else {
      // Filter by fee name or transaction ID
      final filteredPayments = feePayments.where((payment) {
        final feeTitleMatch = payment.studentFee.paymentItem?.feeName
                ?.toLowerCase()
                .contains(query) ??
            false;
        final idMatch = (payment.transactionId ?? payment.id ?? '')
            .toLowerCase()
            .contains(query);
        return feeTitleMatch || idMatch;
      }).toList();

      final transactions = _convertToTransactionModels(filteredPayments);
      _groupTransactions(transactions);
    }
  }
  // void _filterTransactions() {
  //   final query = _searchController.text.toLowerCase();
  //   setState(() {
  //     if (query.isEmpty) {
  //       _groupTransactions(
  //           transactions); // Show all transactions if search query is empty
  //     } else {
  //       final filteredList = transactions.where((transaction) {
  //         final feeTitleMatch =
  //             transaction.feeTitle.toLowerCase().contains(query);
  //         final idMatch = transaction.id.toLowerCase().contains(query);
  //         return feeTitleMatch || idMatch;
  //       }).toList();
  //       _groupTransactions(filteredList);
  //     }
  //   });
  // }
bool _didGroupTransactions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: Consumer<AccountingProvider>(builder: (context, value, _) {
        if (value.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 10.h),
                Text(
                  'Loading transactions...',
                  style: setTextTheme(
                    fontSize: 14.sp,
                    color: whiteShades[3],
                  ),
                ),
              ],
            ),
          );
        }
        if (value.accountStudentHistoryData.isEmpty) {
          return Center(
            child: Text('No Trancsection History'),
          );
        }
        final transactions =
            _convertToTransactionModels(value.accountStudentHistoryData);

        // Group transactions for display
        // _groupTransactions(transactions);
        if (!_didGroupTransactions) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _groupTransactions(transactions);
        });
        _didGroupTransactions = true;
      }
        return Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _searchController,
                      hintText: 'Search by fee name or trx ID',
                      borderRadius: 100,
                      // height: 50,
                      lineHeight: 1,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 15.w,
                      ),
                    ),
                    // child: TextField(
                    //   controller: _searchController,
                    //   decoration: InputDecoration(
                    //     hintText: 'Search by fee name or trx ID',
                    //     prefixIcon: const Icon(Icons.search),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10.r),
                    //     ),
                    //   ),
                    // ),
                  ),
                  SizedBox(width: 10.w),
                  PopupMenuButton<SortOption>(
                    icon: SvgPicture.asset('assets/icons/sort_icon.svg'),
                    onSelected: (option) =>
                        _handleSort(option, value.accountStudentHistoryData),
                    itemBuilder: (BuildContext context) => [
                      _buildPopupItem(
                        SortOption.date,
                        'Sort by Date',
                        Icons.calendar_today,
                      ),
                      _buildPopupItem(
                        SortOption.successful,
                        'Successful',
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      _buildPopupItem(
                        SortOption.failed,
                        'Failed',
                        Icons.error,
                        color: Colors.red,
                      ),
                      _buildPopupItem(
                        SortOption.bankTransfer,
                        'Bank Transfer',
                        Icons.account_balance,
                        color: _paymentTypeColors[PaymentType.bankTransfer],
                      ),
                      _buildPopupItem(
                        SortOption.cardPayment,
                        'Card Payment',
                        Icons.credit_card,
                        color: _paymentTypeColors[PaymentType.cardPayment],
                      ),
                      _buildPopupItem(
                        SortOption.wallet,
                        'Wallet',
                        Icons.account_balance_wallet,
                        color: _paymentTypeColors[PaymentType.wallet],
                      ),
                      _buildPopupItem(
                        SortOption.cashInHand,
                        'Cash in Hand',
                        Icons.money,
                        color: _paymentTypeColors[PaymentType.cashInHand],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: _groupedTransactions.isEmpty
                    ? const Center(child: Text('No transactions found'))
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10.r),
                        itemCount: _groupedTransactions.length,
                        itemBuilder: (context, index) {
                          // Get sorted keys
                          final monthYear =
                              _groupedTransactions.keys.toList()[index];
                          final monthTransactions =
                              _groupedTransactions[monthYear]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index > 0) SizedBox(height: 10.h),
                              _buildMonthSection(monthYear, monthTransactions),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMonthSection(
      String monthYear, List<TransactionModel> transactions) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          monthYear,
          style: setTextTheme(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        initiallyExpanded: true,
        tilePadding: EdgeInsets.symmetric(horizontal: 10.w),
        childrenPadding: EdgeInsets.zero,
        children: transactions
            .map((transaction) => Padding(
                  padding: EdgeInsets.only(
                    bottom: 5.h,
                    left: 10.w,
                    right: 10.w,
                  ),
                  child: _buildTransactionCard(transaction),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    final statusColor = transaction.status == TransactionStatus.successful
        ? Colors.green
        : Colors.red;

    return GestureDetector(
      onTap: () => context.push(
        TransactionDetailsScreen.routeName,
        extra: transaction,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 5.h),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    color: _paymentTypeColors[transaction.paymentType]!,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    _paymentTypeIcons[transaction.paymentType]!,
                    color: Colors.white,
                    size: 15.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.feeTitle,
                        style: setTextTheme(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        DateFormat('dd MMM, yyyy - HH:mm')
                            .format(transaction.date),
                        style: setTextTheme(
                          fontSize: 12.sp,
                          color: whiteShades[3],
                        ),
                      ),
                      Text(
                        'TRX ID: ${transaction.id}  ',
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,  
                        style: setTextTheme(
                          fontSize: 12.sp,
                          color: whiteShades[3],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.watch<UserProvider>().model?.currency} ${NumberFormat("#,##0").format(transaction.amount)}',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      transaction.status.name.toUpperCase(),
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      transaction.paymentTypeName,
                      style: setTextTheme(
                        fontSize: 12.sp,
                        color: whiteShades[3],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // IconData _getCurrentSortIcon() {
  //   return switch (_currentSort) {
  //     null => Icons.sort,
  //     SortOption.date => Icons.calendar_today,
  //     SortOption.successful => Icons.check_circle,
  //     SortOption.failed => Icons.error,
  //     SortOption.bankTransfer => Icons.account_balance,
  //     SortOption.cardPayment => Icons.credit_card,
  //     SortOption.wallet => Icons.account_balance_wallet,
  //     SortOption.cashInHand => Icons.money,
  //   };
  // }

  // Color _getCurrentSortIconColor() {
  //   return switch (_currentSort) {
  //     null => Colors.white,
  //     SortOption.date => Colors.white,
  //     SortOption.successful => Colors.green,
  //     SortOption.failed => Colors.red,
  //     SortOption.bankTransfer => _paymentTypeColors[PaymentType.bankTransfer]!,
  //     SortOption.cardPayment => _paymentTypeColors[PaymentType.cardPayment]!,
  //     SortOption.wallet => _paymentTypeColors[PaymentType.wallet]!,
  //     SortOption.cashInHand => _paymentTypeColors[PaymentType.cashInHand]!,
  //   };
  // }

  PopupMenuItem<SortOption> _buildPopupItem(
    SortOption value,
    String text,
    IconData icon, {
    Color? color,
  }) {
    return PopupMenuItem<SortOption>(
      value: value,
      child: Row(
        children: [
          Icon(icon,
              size: 18.sp,
              color: _currentSort == value ? color : whiteShades[3]),
          SizedBox(width: 8.w),
          Text(
            text,
            style: setTextTheme(
              color: _currentSort == value ? color : null,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  // PopupMenuItem<SortOption> _buildPopupHeader(String text) {
  //   return PopupMenuItem<SortOption>(
  //     enabled: false,
  //     child: Text(
  //       text,
  //       style: setTextTheme(
  //         fontSize: 12.sp,
  //         color: whiteShades[3],
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }
  void _handleSort(SortOption option, List<FeePayment> feePayments) {
    setState(() {
      _currentSort = option;

      // First convert all to transaction models
      List<TransactionModel> allTransactions =
          _convertToTransactionModels(feePayments);

      // Then filter based on sort option
      List<TransactionModel> sortedList;

      switch (option) {
        case SortOption.date:
          sortedList = List.from(allTransactions)
            ..sort((a, b) => b.date.compareTo(a.date));
        case SortOption.cashInHand:
          sortedList = allTransactions
              .where((t) => t.paymentType == PaymentType.cashInHand)
              .toList();
        case SortOption.wallet:
          sortedList = allTransactions
              .where((t) => t.paymentType == PaymentType.wallet)
              .toList();
        case SortOption.bankTransfer:
          sortedList = allTransactions
              .where((t) => t.paymentType == PaymentType.bankTransfer)
              .toList();
        case SortOption.cardPayment:
          sortedList = allTransactions
              .where((t) => t.paymentType == PaymentType.cardPayment)
              .toList();
        case SortOption.successful:
          sortedList = allTransactions
              .where((t) => t.status == TransactionStatus.successful)
              .toList();
        case SortOption.failed:
          sortedList = allTransactions
              .where((t) => t.status == TransactionStatus.failed)
              .toList();
      }

      _groupTransactions(sortedList);
    });
  }
  // void _handleSort(SortOption option) {
  //   setState(() {
  //     _currentSort = option;
  //     List<TransactionModel> sortedList = List.from(transactions);

  //     switch (option) {
  //       case SortOption.date:
  //         sortedList.sort((a, b) => b.date.compareTo(a.date));
  //       case SortOption.cashInHand:
  //         sortedList = sortedList
  //             .where((t) => t.paymentType == PaymentType.cashInHand)
  //             .toList();
  //       case SortOption.wallet:
  //         sortedList = sortedList
  //             .where((t) => t.paymentType == PaymentType.wallet)
  //             .toList();
  //       case SortOption.bankTransfer:
  //         sortedList = sortedList
  //             .where((t) => t.paymentType == PaymentType.bankTransfer)
  //             .toList();
  //       case SortOption.cardPayment:
  //         sortedList = sortedList
  //             .where((t) => t.paymentType == PaymentType.cardPayment)
  //             .toList();
  //       case SortOption.successful:
  //         sortedList = sortedList
  //             .where((t) => t.status == TransactionStatus.successful)
  //             .toList();
  //       case SortOption.failed:
  //         sortedList = sortedList
  //             .where((t) => t.status == TransactionStatus.failed)
  //             .toList();
  //     }

  //     _groupTransactions(sortedList);
  //   });
  // }

  // Add this method to your _TransactionHistoryScreenState class
  List<TransactionModel> _convertToTransactionModels(
      List<FeePayment> feePayments) {
    return feePayments.map((payment) {
      // Map payment method to PaymentType enum
      PaymentType paymentType;
      switch ((payment.paymentMethod ?? '').toUpperCase()) {
        case 'CASH':
          paymentType = PaymentType.cashInHand;
          break;
        case 'WALLET':
          paymentType = PaymentType.wallet;
          break;
        case 'BANK_TRANSFER':
          paymentType = PaymentType.bankTransfer;
          break;
        case 'CARD':
        case 'CARD_PAYMENT':
          paymentType = PaymentType.cardPayment;
          break;
        default:
          paymentType = PaymentType.cashInHand;
      }

      // Map status to TransactionStatus enum
      final status = (payment.status ?? '') == 'success'
          ? TransactionStatus.successful
          : TransactionStatus.failed;

      // Get the fee name from studentFee
      final feeTitle = payment.studentFee.paymentItem?.feeName ?? 'Fee Payment';

      // Parse amount to double
      final amount = double.tryParse(payment.amountPaid ?? '0.0') ?? 0.0;

      // Parse date from createdAt
      DateTime date;
      try {
        date = DateTime.parse(
            payment.createdAt ?? DateTime.now().toIso8601String());
      } catch (e) {
        date = DateTime.now();
      }

      return TransactionModel(
        id: payment.transactionId ?? payment.id ?? '',
        studentName: payment.student.user?.firstName ?? 'Unknown Student',
        studentClass: payment.studentFee.classData.name ?? 'Unknown Class',
        session: payment.studentFee.spaceSession.session ?? 'Current Session',
        term: payment.studentFee.spaceTerm.name ?? 'Current Term',
        discountAmount:
            double.tryParse(payment.studentFee.discount ?? '0.0') ?? 0.0,
        feeTitle: feeTitle,
        amount: amount,
        status: status,
        paymentType: paymentType,
        date: date,
      );
    }).toList();
  }
}

class TransactionModel {
  final String id;
  final String studentClass;
  final String studentName;
  final String feeTitle;
  final String session;
  final String term;
  final double amount;
  final double discountAmount;
  final DateTime date;
  final TransactionStatus status;
  final PaymentType paymentType;
  final String? failureReason;
  final List<FeeItem>? fees;

  TransactionModel({
    required this.studentName,
    required this.studentClass,
    required this.session,
    required this.term,
    required this.discountAmount,
    required this.id,
    required this.feeTitle,
    required this.amount,
    required this.date,
    required this.status,
    required this.paymentType,
    this.failureReason,
    this.fees,
  });

  String get paymentTypeName {
    return switch (paymentType) {
      PaymentType.cashInHand => 'Cash',
      PaymentType.wallet => 'Wallet',
      PaymentType.bankTransfer => 'Bank Transfer',
      PaymentType.cardPayment => 'Card Payment',
    };
  }
}

class FeeItem {
  final String title;
  final String session;
  final String term;
  final double amount;

  const FeeItem({
    required this.title,
    required this.session,
    required this.term,
    required this.amount,
  });
}

// final List<TransactionModel> transactions = [
//   // January 2025
//   TransactionModel(
//     studentName: 'Elenwo Felix',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 10000,
//     id: 'TRX334455',
//     feeTitle: 'Multiple Fees Payment',
//     amount: 155000,
//     date: DateTime(2025, 3, 25, 10, 30),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.bankTransfer,
//     fees: [
//       FeeItem(
//         title: 'School Fees',
//         session: '2024/2025',
//         term: 'Second Term',
//         amount: 100000,
//       ),
//       FeeItem(
//         title: 'Technology Fee',
//         session: '2024/2025',
//         term: 'Second Term',
//         amount: 25000,
//       ),
//       FeeItem(
//         title: 'Library Fee',
//         session: '2024/2025',
//         term: 'Second Term',
//         amount: 15000,
//       ),
//       FeeItem(
//         title: 'Sports Fee',
//         session: '2024/2025',
//         term: 'Second Term',
//         amount: 15000,
//       ),
//     ],
//   ),
//   TransactionModel(
//     studentName: 'Felix Elenwo',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX112233',
//     feeTitle: 'Registration Fee',
//     amount: 35000,
//     date: DateTime(2025, 1, 5, 10, 15),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cashInHand,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 500,
//     id: 'TRX112244',
//     feeTitle: 'Book Purchase',
//     amount: 18000,
//     date: DateTime(2025, 1, 15, 14, 30),
//     status: TransactionStatus.failed,
//     paymentType: PaymentType.wallet,
//     failureReason: 'Network error',
//   ),

//   // February 2025
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 300,
//     id: 'TRX123457',
//     feeTitle: 'Technology Fee',
//     amount: 25000,
//     date: DateTime(2025, 2, 10, 9, 15),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.bankTransfer,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 600,
//     id: 'TRX223344',
//     feeTitle: 'Uniform Fee',
//     amount: 22000,
//     date: DateTime(2025, 2, 20, 13, 00),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cardPayment,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 6000,
//     id: 'TRX223355',
//     feeTitle: 'Transport Fee',
//     amount: 15000,
//     date: DateTime(2025, 2, 25, 16, 45),
//     status: TransactionStatus.failed,
//     paymentType: PaymentType.bankTransfer,
//     failureReason: 'Invalid account',
//   ),

//   // March 2025
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX123456',
//     feeTitle: 'School Fees',
//     amount: 50000,
//     date: DateTime(2025, 3, 15, 14, 30),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cardPayment,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX122456',
//     feeTitle: 'School Fees',
//     amount: 50000,
//     date: DateTime(2025, 3, 15, 10, 45),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cashInHand,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX223457',
//     feeTitle: 'Technology',
//     amount: 25000,
//     date: DateTime(2025, 3, 10, 16, 20),
//     status: TransactionStatus.failed,
//     paymentType: PaymentType.wallet,
//     failureReason: 'Insufficient funds',
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX334567',
//     feeTitle: 'Library Subscription',
//     amount: 15000,
//     date: DateTime(2025, 3, 18, 11, 30),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.wallet,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX445678',
//     feeTitle: 'Sports Fee',
//     amount: 30000,
//     date: DateTime(2025, 3, 19, 15, 00),
//     status: TransactionStatus.failed,
//     paymentType: PaymentType.cardPayment,
//     failureReason: 'Card declined',
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX556789',
//     feeTitle: 'Tuition Fee',
//     amount: 75000,
//     date: DateTime(2025, 3, 20, 13, 45),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.bankTransfer,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX667890',
//     feeTitle: 'Lab Equipment',
//     amount: 20000,
//     date: DateTime(2025, 3, 21, 9, 30),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cashInHand,
//   ),

//   // April 2025
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX778899',
//     feeTitle: 'Exam Fee',
//     amount: 40000,
//     date: DateTime(2025, 4, 2, 9, 00),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cardPayment,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX889900',
//     feeTitle: 'Maintenance Fee',
//     amount: 28000,
//     date: DateTime(2025, 4, 15, 11, 45),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.bankTransfer,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX990011',
//     feeTitle: 'Art Supplies',
//     amount: 12000,
//     date: DateTime(2025, 4, 20, 15, 30),
//     status: TransactionStatus.failed,
//     paymentType: PaymentType.wallet,
//     failureReason: 'Payment timeout',
//   ),

//   // May 2025
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX001122',
//     feeTitle: 'Field Trip',
//     amount: 35000,
//     date: DateTime(2025, 5, 5, 8, 30),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cashInHand,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX112233',
//     feeTitle: 'Music Lessons',
//     amount: 25000,
//     date: DateTime(2025, 5, 12, 14, 15),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.cardPayment,
//   ),
//   TransactionModel(
//     studentName: 'Ugo matt',
//     studentClass: 'JSS1',
//     session: '2024/2025',
//     term: 'Second Term',
//     discountAmount: 0.0,
//     id: 'TRX223344',
//     feeTitle: 'Cafeteria Payment',
//     amount: 18000,
//     date: DateTime(2025, 5, 20, 12, 00),
//     status: TransactionStatus.successful,
//     paymentType: PaymentType.wallet,
//   ),
// ];
