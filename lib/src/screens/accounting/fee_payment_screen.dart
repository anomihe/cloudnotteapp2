import 'dart:developer';

import 'package:cloudnottapp2/src/components/shared_widget/copyable_text_widget.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/accounting_mode_second.dart'
    show StudentFeeSecond;
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    show BasicAssessment, SpaceSession, Student;
import 'package:cloudnottapp2/src/data/models/user_model.dart' show SpaceTerm;
import 'package:cloudnottapp2/src/data/models/fee_model.dart';
import 'package:cloudnottapp2/src/data/providers/accounting_providers.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart'
    show UserProvider;
import 'package:cloudnottapp2/src/screens/accounting/admin_fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/transaction_history_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/accounting/make_payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/providers/result_provider.dart';

class FeePaymentScreen extends StatefulWidget {
  static const routeName = '/fee_payment_screen';
  const FeePaymentScreen({super.key});

  @override
  State<FeePaymentScreen> createState() => _FeePaymentScreenState();
}

enum PaymentStatus {
  all,
  cleared,
  owning,
  unpaid,
}

PaymentStatus statusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'cleared':
      return PaymentStatus.cleared;
    case 'unpaid':
      return PaymentStatus.unpaid;
    case 'owning': // <-- this is the key
    case 'owing': // <-- and this (the one from the log)
    case 'uncleared':
      return PaymentStatus.owning;
    default:
      return PaymentStatus.all;
  }
}

class _FeePaymentScreenState extends State<FeePaymentScreen> {
  PaymentStatus selectedFilter = PaymentStatus.all;
  NumberFormat numberFormat = NumberFormat('#,##0', 'en_US');
  @override
  void initState() {
    super.initState();
    Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
        context: context, alias: context.read<UserProvider>().alias);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        Provider.of<AccountingProvider>(context, listen: false)
            .getStudentsPayment(
          context: context,
          studentId: context.read<UserProvider>().memberId ?? '',
          spaceId: context.read<UserProvider>().spaceId ?? '',
          spaceSessionIds: [context.read<UserProvider>().classSessionId ?? ''],
          spaceTermIds: [context.read<UserProvider>().termId ?? ''],
        ),
      ]);
      Provider.of<AccountingProvider>(context, listen: false)
          .getBasicPaymentHistory(
        context: context,
        studentId: context.read<UserProvider>().memberId ?? '',
        spaceId: context.read<UserProvider>().spaceId ?? '',
        spaceSessionId: context.read<UserProvider>().classSessionId ?? '',
        spaceTermIds: [context.read<UserProvider>().termId ?? ''],
      );
    });
  }

  String? sessionId;
  String? termId;
  @override
  Widget build(BuildContext context) {
    final myUser = context.watch<UserProvider>().singleSpace;
final hasDedicatedAccount = (myUser?.dedicatedAccountBank?.isNotEmpty ?? false) ||
    (myUser?.dedicatedAccountName?.isNotEmpty ?? false) ||
    (myUser?.dedicatedAccountNumber?.isNotEmpty ?? false);

    final spaceTerms = context.watch<UserProvider>().data?.spaceTerms ?? [];
    final userTermId = context.watch<UserProvider>().termId;
    final selectedTerm = spaceTerms.firstWhere(
      (term) => term.id == userTermId,
      orElse: () => SpaceTerm.empty(),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Fee Payment',
          style: setTextTheme(fontSize: 24.sp),
        ),
        actions: [
          Row(
            children: [
              Buttons(
                width: 100.w,
                height: 30.h,
                fontSize: 12.sp,
                boxColor: blueShades[0],
                fontWeight: FontWeight.w400,
                text: 'Make payment',
                isLoading: false,
                onTap: () {
                  context.push(MakePaymentScreen.routeName);
                },
              ),
              SizedBox(width: 10.w),
              // TextButton(
              //   onPressed: () {
              //     context.push(TransactionHistoryScreen.routeName);
              //   },
              //   child: Text(
              //     'History',
              //     style: setTextTheme(
              //       fontSize: 14.sp,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Consumer<ResultProvider>(
                      builder: (context, value, _) {
                        final classSessionId =
                            context.watch<UserProvider>().classSessionId;
                        final selectedSession =
                            value.space?.spaceSessions?.firstWhere(
                          (s) => s.id == classSessionId,
                          orElse: () => SpaceSession.empty(),
                        );

                        return CustomDropdownFormField<SpaceSession>(
                          value: selectedSession,
                          hintText: 'Select Session',
                          onChanged: (value) {
                            setState(() {
                              sessionId = value?.id;
                            });
                          },
                          items: value.space?.spaceSessions
                                  ?.map(
                                    (session) => DropdownMenuItem<SpaceSession>(
                                      value: session,
                                      child: SizedBox(
                                        width: 100.w,
                                        child: Text(
                                          session.session,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList() ??
                              [],
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomDropdownFormField<SpaceTerm>(
                      hintText: 'Select Term',
                      value: selectedTerm,
                      onChanged: (value) {
                        setState(() {
                          termId = value.id;
                        });
                        Future.wait([
                          Provider.of<AccountingProvider>(context,
                                  listen: false)
                              .getStudentsPayment(
                            context: context,
                            studentId:
                                context.read<UserProvider>().memberId ?? '',
                            spaceId: context.read<UserProvider>().spaceId ?? '',
                            spaceSessionIds: [sessionId ?? ''],
                            spaceTermIds: [termId ?? ''],
                          ),
                        ]);
                        Provider.of<AccountingProvider>(context, listen: false)
                            .getBasicPaymentHistory(
                          context: context,
                          studentId:
                              context.read<UserProvider>().memberId ?? '',
                          spaceId: context.read<UserProvider>().spaceId ?? '',
                          spaceSessionId: sessionId ?? '',
                          spaceTermIds: [termId ?? ''],
                        );
                      },
                      items: spaceTerms
                          .map(
                            (term) => DropdownMenuItem(
                              value: term,
                              child: SizedBox(
                                width: 100.w,
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  term.name,
                                  style: setTextTheme(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    context.push(TransactionHistoryScreen.routeName);
                  },
                  child: Text(
                    'View Transaction History',
                    style: setTextTheme(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Consumer<AccountingProvider>(
                builder: (context, value, _) {
                  if (value.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (value.studentPay.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                  log('accountStudentData: ${context.read<UserProvider>().user?.id}');

                  final totalFees = value.studentPay.isEmpty
                      ? 0
                      : value.studentPay
                          .map((e) => int.parse(e.amount ?? '0'))
                          .reduce((a, b) => a + b);
                  final totalDiscount = value.studentPay.isEmpty
                      ? 0
                      : value.studentPay
                          .map((e) => int.parse(e.discountAmount ?? '0'))
                          .reduce((a, b) => a + b);

                  final totalAmountPaid = value.studentPay.isEmpty
                      ? 0
                      : value.studentPay
                          .map((e) => int.parse(e.amountPaid ?? '0'))
                          .reduce((a, b) => a + b);
                  final totalOutstanding =
                      totalFees - totalAmountPaid - totalDiscount;
                  final provider = context.read<AccountingProvider>();
                  final settlementAccounts = provider.settlementAccount;
                  // final filteredFees = value.studentPay.where((fee) {
                  //   final feeStatus = statusFromString(fee.status ?? '');
                  //   return selectedFilter == PaymentStatus.all ||
                  //       feeStatus == selectedFilter;
                  // }).toList();
                  final filteredFees = value.studentPay.where((fee) {
                    final status = fee.status ?? '';
                    final mappedStatus = statusFromString(status);
                    log('Filtering -> status: $status | mapped: $mappedStatus | selected: $selectedFilter');
                    return selectedFilter == PaymentStatus.all ||
                        mappedStatus == selectedFilter;
                  }).toList();

                  // return ListView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: value.accountStudentData.length,
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       final student = value.accountStudentData[index];
                  //       final studentName =
                  //           '${student?.student.user?.firstName} ${student?.student.user?.lastName}';
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _containerBuild(context,
                              title: 'Outstanding',
                              amount: numberFormat.format(totalOutstanding),
                              arrowBoxColor: redShades[0],
                              icon: CupertinoIcons.arrow_down),
                          _containerBuild(context,
                              title: 'Amount Paid',
                              amount: numberFormat.format(totalAmountPaid),
                              arrowBoxColor: Colors.green,
                              icon: CupertinoIcons.arrow_up),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _containerBuild(context,
                              title: 'Discounts',
                              amount: numberFormat.format(totalDiscount),
                              arrowBoxColor: blueShades[0],
                              icon: CupertinoIcons.arrow_down),
                          _containerBuild(context,
                              title: 'Fee Amount',
                              amount: numberFormat.format(totalFees),
                              arrowBoxColor: goldenShades[0],
                              icon: CupertinoIcons.arrow_up),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      _containerBuild(context,
                          isExpanded: true,
                          title: 'Wallet',
                          amount: numberFormat.format(int.parse(context
                                  .read<UserProvider>()
                                  .singleSpace
                                  ?.spaceWallet
                                  ?.balance ??
                              '0')),
                          arrowBoxColor: redShades[0],
                          icon: CupertinoIcons.arrow_down),
                      SizedBox(height: 10.h),
                       if (hasDedicatedAccount)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ThemeProvider().isDarkMode
                                ? blueShades[21]
                                : blueShades[18],
                          ),
                          color: ThemeProvider().isDarkMode
                              ? blueShades[15]
                              : blueShades[17],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Transform.flip(
                            //   flipY: true,
                            //   child: Icon(
                            //     Icons.error_outline,
                            //     color: redShades[1],
                            //   ),
                            // ),
                            // SizedBox(width: 10),

           
           Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Money sent to this account will automatically pay your fees',
                      style: setTextTheme(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    CopyableText(
                      label: 'Bank Name',
                      value: myUser?.dedicatedAccountBank ?? 'N/A',
                    ),
                    CopyableText(
                      label: 'Account Name',
                      value: myUser?.dedicatedAccountName ?? 'N/A',
                    ),
                    CopyableText(
                      label: 'Account No',
                      shouldCopy: true,
                      feedbackPosition: CopyFeedbackPosition.right,
                      value: myUser?.dedicatedAccountNumber ?? 'N/A',
                    ),
                  ],
                ),
              )
                            // Expanded(
                            //   child: Column(
                            //     spacing: 5.h,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'Money sent to this account will automatically pay your fees',
                            //         style: setTextTheme(
                            //           fontSize: 13,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //       // use skeletonizer for account number loading state
                            //       CopyableText(
                            //         label: 'Bank Name',
                            //         value: settlementAccounts.isNotEmpty
                            //             ? settlementAccounts.first.bankName ??
                            //                 'N/A'
                            //             : 'No account found',
                            //         // shouldCopy: false,
                            //       ),
                            //       CopyableText(
                            //         label: 'Account Name',
                            //         value: settlementAccounts.isNotEmpty
                            //             ? settlementAccounts
                            //                     .first.accountName ??
                            //                 'N/A'
                            //             : 'No account found',
                            //         // shouldCopy: false,
                            //       ),
                            //       CopyableText(
                            //         label: 'Account No',
                            //         shouldCopy: true,
                            //         feedbackPosition:
                            //             CopyFeedbackPosition.right,
                            //         value: settlementAccounts.isNotEmpty
                            //             ? settlementAccounts
                            //                     .first.accountNumber ??
                            //                 'N/A'
                            //             : 'No account found',
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Outstanding Fees',
                            style: setTextTheme(
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.0,
                            child: CustomDropdownFormField(
                              hintText: 'Filter by',
                              value: selectedFilter,
                              onChanged: (value) {
                                if (value != null) {
                                  log('Filter changed to: $value');
                                  setState(() {
                                    selectedFilter = value;
                                  });
                                }
                              },
                              items: PaymentStatus.values.map((status) {
                                String label = switch (status) {
                                  PaymentStatus.all => 'All',
                                  PaymentStatus.cleared => 'cleared',
                                  PaymentStatus.owning => 'owning',
                                  PaymentStatus.unpaid => 'Unpaid',
                                };

                                Color itemColor = switch (status) {
                                  PaymentStatus.all => blueShades[0],
                                  PaymentStatus.cleared => Colors.green,
                                  PaymentStatus.owning => goldenShades[0],
                                  PaymentStatus.unpaid => redShades[0],
                                };

                                return DropdownMenuItem<PaymentStatus>(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8.r,
                                        height: 8.r,
                                        decoration: BoxDecoration(
                                          color: itemColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        label,
                                        style: setTextTheme(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        children: List.generate(
                          filteredFees.length,
                          (index) {
                            // final filteredFees = fees
                            //     .where((fee) =>
                            //         selectedFilter == PaymentStatus.all ||
                            //         fee.status == selectedFilter)
                            //     .toList();

                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _FeeTileWidget(
                                key: ValueKey(
                                    filteredFees[index].paymentItem.feeName),
                                fee: filteredFees[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                  // });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

_containerBuild(
  BuildContext context, {
  required String title,
  required String amount,
  IconData? icon,
  Color? arrowBoxColor,
  bool? isExpanded = false,
}) {
  return Container(
    width: isExpanded == true
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 2.2,
    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
    decoration: BoxDecoration(
      color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: ThemeProvider().isDarkMode ? blueShades[21] : blueShades[18],
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 25.r,
          height: 25.r,
          decoration: BoxDecoration(
            color: arrowBoxColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 15.r,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: setTextTheme(
                  fontSize: 13.sp,
                  lineHeight: 1.5,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${context.watch<UserProvider>().model?.currency} ',
                  style: setTextTheme(
                    // fontFamily: "Arial",
                    fontSize: 18.sp,
                    // color: ThemeProvider().isDarkMode
                    //     ? Colors.white
                    //     : Colors.black,
                    fontWeight: FontWeight.w300,
                    // lineHeight: 1.1,
                    letterSpacing: 0,
                  ),
                  children: [
                    TextSpan(
                      text: amount,
                      style: setTextTheme(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

class _FeeTileWidget extends StatelessWidget {
  // final FeeModel fee;
  final StudentFeeSecond fee;
  _FeeTileWidget({
    super.key,
    required this.fee,
  });
  final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
  Color _getStatusColor(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.cleared => Colors.green,
      PaymentStatus.owning => goldenShades[0],
      PaymentStatus.unpaid => redShades[0],
      _ => blueShades[0],
    };
  }

  IconData _getStatusIcon(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.cleared => Icons.check,
      PaymentStatus.owning => Icons.access_time,
      PaymentStatus.unpaid => Icons.error_outline,
      _ => Icons.circle,
    };
  }

  @override
  Widget build(BuildContext context) {
    final amountPaid = int.parse(fee.amountPaid ?? '0');
    final discountAmount = int.parse(fee.discountAmount ?? '0');
    final totalAmount = int.parse(fee.amount ?? '0');
    final outstanding = totalAmount - amountPaid - discountAmount;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ThemeProvider().isDarkMode ? blueShades[21] : blueShades[18],
        ),
        color: ThemeProvider().isDarkMode ? blueShades[15] : blueShades[17],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.symmetric(
            horizontal: 15.r,
            vertical: 5.h,
          ),
          title: Row(
            children: [
              Container(
                width: 25.r,
                height: 25.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: _getStatusColor(statusFromString(fee.status ?? '')),
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(statusFromString(fee.status ?? '')),
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fee.paymentItem.feeName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${fee.spaceSession.session} - ${fee.spaceTerm.name}',
                      style: setTextTheme(
                        fontSize: 12.sp,
                        color: whiteShades[3],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text:
                            '${context.watch<UserProvider>().model?.currency}',
                        style: TextStyle(
                          fontFamily: "Arial",
                          fontSize: 12.sp,
                          color: whiteShades[3],
                          fontWeight: FontWeight.w400,
                          // lineHeight: 1.1,
                          letterSpacing: 0,
                        ),
                        children: [
                          TextSpan(
                            text: numberFormat
                                .format(int.parse(fee.amount ?? '0')),
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: whiteShades[3],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            _buildDetailRow('Fee Amount:',
                '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(int.parse(fee.amount ?? '0'))}'),
            _buildDetailRow('Outstanding:',
                '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(int.parse(outstanding.toString()))}'),
            _buildDetailRow('Discount:',
                '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(int.parse(fee.discountAmount ?? '0'))}'),
            _buildDetailRow('Amount Paid:',
                '${context.watch<UserProvider>().model?.currency} ${numberFormat.format(int.parse(fee.amountPaid ?? '0'))}'),
            _buildDetailRow('Status:', fee.status?.toUpperCase() ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: setTextTheme(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: whiteShades[3],
            ),
          ),
        ],
      ),
    );
  }
}

// Replace the existing fees list with:
List<FeeModel> fees = [
  FeeModel(
    title: 'School Fees',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 100000,
    outstandingAmount: 50000,
    discountAmount: 5000,
    amountPaid: 45000,
    status: PaymentStatus.owning,
  ),
  FeeModel(
    title: 'Technology Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 25000,
    outstandingAmount: 0,
    discountAmount: 2500,
    amountPaid: 25000,
    status: PaymentStatus.cleared,
  ),
  FeeModel(
    title: 'Sports Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 15000,
    outstandingAmount: 15000,
    discountAmount: 0,
    amountPaid: 0,
    status: PaymentStatus.unpaid,
  ),
  FeeModel(
    title: 'Library Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 10000,
    outstandingAmount: 5000,
    discountAmount: 1000,
    amountPaid: 4000,
    status: PaymentStatus.owning,
  ),
  FeeModel(
    title: 'Laboratory Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 20000,
    outstandingAmount: 0,
    discountAmount: 2000,
    amountPaid: 18000,
    status: PaymentStatus.cleared,
  ),
  FeeModel(
    title: 'Development Levy',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 30000,
    outstandingAmount: 30000,
    discountAmount: 0,
    amountPaid: 0,
    status: PaymentStatus.unpaid,
  ),
  FeeModel(
    title: 'Art Supplies Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 8000,
    outstandingAmount: 3000,
    discountAmount: 500,
    amountPaid: 4500,
    status: PaymentStatus.owning,
  ),
  FeeModel(
    title: 'Examination Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 12000,
    outstandingAmount: 0,
    discountAmount: 1000,
    amountPaid: 11000,
    status: PaymentStatus.cleared,
  ),
  FeeModel(
    title: 'Transport Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 45000,
    outstandingAmount: 45000,
    discountAmount: 0,
    amountPaid: 0,
    status: PaymentStatus.unpaid,
  ),
  FeeModel(
    title: 'Maintenance Fee',
    session: '2025/2026',
    term: 'First Term',
    totalAmount: 15000,
    outstandingAmount: 7500,
    discountAmount: 1500,
    amountPaid: 6000,
    status: PaymentStatus.owning,
  ),
];
