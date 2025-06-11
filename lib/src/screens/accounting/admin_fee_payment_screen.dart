import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/accounting_models.dart'
    show ClassFeeData, PaymentItemSecond;
import 'package:cloudnottapp2/src/data/models/user_model.dart' show SpaceModel, SpaceTerm;
import 'package:cloudnottapp2/src/data/models/enter_score_widget_model.dart'
    show BasicAssessment, SpaceSession, Student;
import 'package:cloudnottapp2/src/data/models/fee_model.dart';
import 'package:cloudnottapp2/src/data/providers/accounting_providers.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/accounting/fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AdminFeePaymentScreen extends StatefulWidget {
  static const routeName = '/admin_fee_payment_screen';
  const AdminFeePaymentScreen({super.key});

  @override
  State<AdminFeePaymentScreen> createState() => _AdminFeePaymentScreenState();
}

class _AdminFeePaymentScreenState extends State<AdminFeePaymentScreen> {
  PaymentStatus selectedFilter = PaymentStatus.all;
  NumberFormat format = NumberFormat(
    '#,##0',
    'en_US',
  );
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Provider.of<ResultProvider>(context, listen: false).getSpaceReportData(
        context: context, alias: context.read<UserProvider>().alias);
    _loadFeeData();
    // Provider.of<AccountingProvider>(context, listen: false)
    //     .getStudentPaymentItem(
    //         context: context, spaceId: context.read<UserProvider>().spaceId)
    //     .then((_) {
    //   Provider.of<AccountingProvider>(context, listen: false).getFeeItemSummary(
    //       context: context,
    //       spaceId: context.read<UserProvider>().spaceId ?? '',
    //       spaceSessionId: context.read<UserProvider>().classSessionId ?? '',
    //       spaceTermIds: [userProvider.termId ?? ''],
    //       paymentItemIds: [selectedItem?.id ?? '']);
    //   _initializePayments();
    // });
    print('sess ${context.read<UserProvider>().classSessionId}');
    sessionId = userProvider.classSessionId;
    termId = userProvider.termId;
    // Future.wait([]);
  }

  Future<void> _loadFeeData() async {
    try {
      final userProvider = context.read<UserProvider>();
      final accountingProvider = context.read<AccountingProvider>();

      await accountingProvider.getStudentPaymentItem(
        context: context,
        spaceId: userProvider.spaceId,
      );

       userProvider.getSpace(context, userProvider.alias, userProvider.spaceId);
      await accountingProvider.getFeeItemSummary(
        context: context,
        spaceId: userProvider.spaceId ?? '',
        spaceSessionId: userProvider.classSessionId ?? '',
        spaceTermIds: [userProvider.termId ?? ''],
        paymentItemIds: [selectedItem?.id ?? ''],
      );
      _initializePayments();
    } catch (e, stackTrace) {
      debugPrint("Error loading fee data: $e\n$stackTrace");

      // Optional: show error message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Failed to load data. Please try again.")),
      // );
    }
  }

  void _initializePayments() {
    // Only proceed if we have both sessionId and termId
    if (sessionId != null && termId != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accountingProvider =
          Provider.of<AccountingProvider>(context, listen: false);

      // Get account summary and class fees
      Future.wait([
        accountingProvider.getAccountSummary(
          context: context,
          spaceId: userProvider.spaceId ?? '',
          spaceSessionId: sessionId ?? '',
          spaceTermIds: [termId ?? ''],
        ),
        accountingProvider.classFee(
          context: context,
          spaceId: userProvider.spaceId ?? '',
          spaceSessionId: sessionId ?? '',
          spaceTermIds: [termId ?? ''],
        ),
        // Also get fee item summary if we have a selected payment item
        if (selectedItem != null)
          accountingProvider.getFeeItemSummary(
            context: context,
            spaceId: userProvider.spaceId ?? '',
            spaceSessionId: sessionId ?? '',
            spaceTermIds: [termId ?? ''],
            paymentItemIds: [selectedItem?.id ?? ''],
          ),
      ]);
    }
  }

  String? sessionId;
  String? termId;
  String? selectedClass;
  PaymentItemSecond? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Fee Payment',
          style: setTextTheme(fontSize: 24.sp),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    children: [
                      _buildCon(
                        context,
                        title: 'Process fee',
                        svgPath: "assets/icons/result_icon.svg",
                      ),
                      _buildCon(
                        context,
                        title: 'Create fee',
                        svgPath: "assets/icons/notes_icon.svg",
                        cardColor: redShades[2],
                      ),
                      _buildCon(
                        context,
                        title: 'Debtors',
                        svgPath: "assets/icons/stacked_icon.svg",
                        cardColor: redShades[9],
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // fit: FlexFit.loose,
                      child: Consumer<ResultProvider>(
                        builder: (context, value, _) {
                          SpaceSession? selectedSession;
                          if (sessionId != null &&
                              value.space?.spaceSessions != null) {
                            selectedSession =
                                value.space?.spaceSessions?.firstWhere(
                              (session) => session.id == sessionId,
                              orElse: () => value.space!.spaceSessions!.first,
                            );
                          }
                          return CustomDropdownFormField<SpaceSession>(
                            hintText: 'Select Session',
                            value: selectedSession,
                            onChanged: (value) {
                              setState(() {
                                sessionId = value?.id;
                              });
                              print('sessionIdsssssss $sessionId');
                            },
                            items: value.space?.spaceSessions
                                    ?.map(
                                      (session) =>
                                          DropdownMenuItem<SpaceSession>(
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
                      child:
                          Consumer<UserProvider>(builder: (context, value, _) {
                        SpaceTerm? selectedTerm;
                        if (termId != null && value.data?.spaceTerms != null) {
                          selectedTerm = value.data?.spaceTerms?.firstWhere(
                            (term) => term.id == termId,
                            orElse: () => value.data!.spaceTerms!.first,
                          );
                        }
                        return CustomDropdownFormField<SpaceTerm>(
                          value: selectedTerm,
                          hintText: 'Select Term',
                          onChanged: (value) {
                            setState(() {
                              termId = value.id;
                            });
                            print('termId $termId');
                            Future.wait([
                              Provider.of<AccountingProvider>(context,
                                      listen: false)
                                  .getAccountSummary(
                                context: context,
                                spaceId:
                                    context.read<UserProvider>().spaceId ?? '',
                                spaceSessionId: sessionId ?? '',
                                spaceTermIds: [termId ?? ''],
                              ),
                              Provider.of<AccountingProvider>(context,
                                      listen: false)
                                  .classFee(
                                context: context,
                                spaceId:
                                    context.read<UserProvider>().spaceId ?? '',
                                spaceSessionId: sessionId ?? '',
                                spaceTermIds: [termId ?? ''],
                              ),
                            ]);
                          },
                          items: value.data?.spaceTerms
                                  ?.map(
                                    (term) => DropdownMenuItem<SpaceTerm>(
                                      value: term,
                                      child: SizedBox(
                                        width: 100.w,
                                        child: Text(
                                          term.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: setTextTheme(),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList() ??
                              [],
                        );
                      }),
                    ),
                  ],
                ),

                // Replace the existing transaction history section with this:   symbol: '${context.watch<UserProvider>().model.currency}'
                Consumer<AccountingProvider>(
                  builder: (context, accountingProvider, _) {
                    if (accountingProvider.isLoading) {
                      return SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(color: Colors.white),
                              child: SkeletonItem(
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                            shape: BoxShape.circle,
                                            width: 50,
                                            height: 50),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: SkeletonParagraph(
                                          style: SkeletonParagraphStyle(
                                              lines: 3,
                                              spacing: 6,
                                              lineStyle: SkeletonLineStyle(
                                                randomLength: true,
                                                height: 10,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                minLength:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        6,
                                                maxLength:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3,
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  SkeletonParagraph(
                                    style: SkeletonParagraphStyle(
                                        lines: 3,
                                        spacing: 6,
                                        lineStyle: SkeletonLineStyle(
                                          randomLength: true,
                                          height: 10,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          minLength: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                        )),
                                  ),
                                  SizedBox(height: 12),
                                  SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                      width: double.infinity,
                                      minHeight:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      maxHeight:
                                          MediaQuery.of(context).size.height /
                                              3,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SkeletonAvatar(
                                              style: SkeletonAvatarStyle(
                                                  width: 20, height: 20)),
                                          SizedBox(width: 8),
                                          SkeletonAvatar(
                                              style: SkeletonAvatarStyle(
                                                  width: 20, height: 20)),
                                          SizedBox(width: 8),
                                          SkeletonAvatar(
                                              style: SkeletonAvatarStyle(
                                                  width: 20, height: 20)),
                                        ],
                                      ),
                                      SkeletonLine(
                                        style: SkeletonLineStyle(
                                            height: 16,
                                            width: 64,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      )
                                    ],
                                  )
                                ],
                              )),
                            ),
                          ),
                        ),
                      );
                    }
                    final summary = accountingProvider.accountingSummary;
                    return Column(
                      spacing: 10.h,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: 'Transaction History is available on web',
            backgroundColor: redShades[5],
          ));
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _containerBuild(
                              context,
                              title: 'Amount received',
                              amount:
                                  format.format(int.parse(summary?.totalAmountReceived ?? '0')),
                              arrowBoxColor: redShades[0],
                              icon: CupertinoIcons.arrow_down,
                            ),
                            _containerBuild(
                              context,
                              title: 'Original amount',
                              amount:
                                  format.format(int.parse(summary?.totalOriginalAmount ?? '0')),
                              arrowBoxColor: Colors.green,
                              icon: CupertinoIcons.arrow_up,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _containerBuild(
                              context,
                              title: 'Discount applied',
                              amount:
                                  format.format(int.parse(summary?.totalDiscountsApplied ?? '0')),
                              arrowBoxColor: blueShades[0],
                              icon: CupertinoIcons.arrow_down,
                            ),
                            _containerBuild(
                              context,
                              title: 'Expected amount',
                              amount:
                                  '${format.format(int.parse(summary?.totalExpectedAmount ?? '0'))}',
                              arrowBoxColor: goldenShades[0],
                              icon: CupertinoIcons.arrow_up,
                            ),
                          ],
                        ),
                        _containerBuild(
                          context,
                          title: 'Outstanding amount',
                          isExpanded: true,
                          amount:
                              ' ${format.format(int.parse(summary?.totalOutstandingAmount ?? '0'))}',
                          arrowBoxColor: goldenShades[0],
                          icon: CupertinoIcons.arrow_up,
                        ),
                        SizedBox(height: 10.h),
                        // _loadingContainer(context)
                      ],
                    );
                  },
                ),

                SizedBox(height: 10.h),
                Text(
                  'Payment item summary',
                  style: setTextTheme(
                    fontSize: 16.sp,
                  ),
                ),
                Consumer<AccountingProvider>(builder: (context, value, _) {
                  if (selectedItem == null && value.paymentItem.isNotEmpty) {
                    selectedItem = value.paymentItem.first;
                  }

                  return CustomDropdownFormField(
                    hintText: 'Payment Item',
                    value: selectedItem,
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                      });
                      // if (selectedItem != null) {
                      Provider.of<AccountingProvider>(context, listen: false)
                          .getFeeItemSummary(
                        context: context,
                        spaceId: context.read<UserProvider>().spaceId ?? '',
                        spaceSessionId: sessionId ?? '',
                        spaceTermIds: [termId ?? ''],
                        paymentItemIds: [selectedItem?.id ?? ''],
                      );
                    },
                    items: value.paymentItem
                        .map(
                          (items) => DropdownMenuItem(
                            value: items,
                            child: Text(
                              items.feeName,
                              style: setTextTheme(
                                fontSize: 14.sp,
                                color: ThemeProvider().isDarkMode
                                    ? Colors.white
                                    : Color(0xff172B47),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),
                Consumer<AccountingProvider>(builder: (context, value, _) {
                  return Column(
                    spacing: 10.h,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _containerBuild(
                            context,
                            title: 'Amount received',
                            amount:
                                '${format.format(int.parse(value.itemFeeSummary?.totalAmountReceived ?? '0'))}',
                            arrowBoxColor: redShades[0],
                            icon: CupertinoIcons.arrow_down,
                          ),
                          _containerBuild(
                            context,
                            title: 'Original amount',
                            amount:
                                '${format.format(int.parse(value.itemFeeSummary?.totalOriginalAmount ?? '0'))}',
                            arrowBoxColor: Colors.green,
                            icon: CupertinoIcons.arrow_up,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _containerBuild(
                            context,
                            title: 'Discount applied',
                            amount:
                                '${format.format(int.parse(value.itemFeeSummary?.totalDiscountsApplied ?? '0'))}',
                            arrowBoxColor: blueShades[0],
                            icon: CupertinoIcons.arrow_down,
                          ),
                          _containerBuild(
                            context,
                            title: 'Expected amount',
                            amount:
                                '${format.format(int.parse(value.itemFeeSummary?.totalExpectedAmount ?? '0'))}',
                            arrowBoxColor: goldenShades[0],
                            icon: CupertinoIcons.arrow_up,
                          ),
                        ],
                      ),
                      _containerBuild(
                        context,
                        title: 'Outstanding amount',
                        isExpanded: true,
                        amount:
                            '${format.format(int.parse(value.itemFeeSummary?.totalOutstandingAmount ?? '0'))}',
                        arrowBoxColor: goldenShades[0],
                        icon: CupertinoIcons.arrow_up,
                      ),
                    ],
                  );
                }),
                SizedBox(height: 10.h),
                Text(
                  'Class Fees Summary',
                  style: setTextTheme(
                    fontSize: 16.sp,
                  ),
                ),
                Consumer<AccountingProvider>(builder: (context, value, _) {
                  return Column(
                    children: List.generate(
                      value.classFeeData.length,
                      (index) {
                        return Column(
                          children: [
                            _FeeTileWidget(
                              fee: value.classFeeData[index],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                })
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: 10,
                //     itemBuilder: (context, index) {
                //       return _classCards();
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_loadingContainer(BuildContext context) {
  return Column(
    children: [
      SkeletonListTile(
        hasSubtitle: true,
        leadingStyle: SkeletonAvatarStyle(
          width: 25.r,
          height: 25.r,
          borderRadius: BorderRadius.circular(100),
        ),
        titleStyle: SkeletonLineStyle(
          width: 50,
          height: 10,
          borderRadius: BorderRadius.circular(8),
          minLength: MediaQuery.of(context).size.width / 2,
        ),
      ),
      SkeletonParagraph(
        style: SkeletonParagraphStyle(
            lines: 2,
            spacing: 6,
            lineStyle: SkeletonLineStyle(
              // width: 50,
              // randomLength: true,
              height: 10,
              borderRadius: BorderRadius.circular(8),
              minLength: MediaQuery.of(context).size.width / 2,
            )),
      ),
    ],
  );
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
        : MediaQuery.of(context).size.width / 2.15,
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
                  text: '${context.watch<UserProvider>().model?.currency}',
                  style: TextStyle(
                    fontFamily: "Arial",
                    color: ThemeProvider().isDarkMode
                            ? Colors.white
                            : Colors.black,
                    fontSize: 18.sp,
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
  final ClassFeeData fee;

  const _FeeTileWidget({
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    final money = Provider.of<UserProvider>(context, listen: false).model;
    NumberFormat format = NumberFormat(
      '#,##0',
      'en_US',
    );
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
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
                  color: redShades[1],
                ),
                child: Center(
                    child: Text(
                  (fee.classInfo.name != null &&
                          fee.classInfo.name!.length >= 2)
                      ? fee.classInfo.name!.substring(0, 2)
                      : fee.classInfo.name?.substring(0, 1) ?? '',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fee.classInfo.classGroup.name}',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider().isDarkMode
                            ? Colors.white
                            : Color(0xff172B47),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '${money?.currency}',
                        style: TextStyle(
                          fontFamily: "Arial",
                          fontSize: 12.sp,
                          color: ThemeProvider().isDarkMode
                              ? Colors.grey
                              : Colors.black,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                        children: [
                          TextSpan(
                            text:
                                ' ${format.format(int.parse(fee.totalAmountReceived))}',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              color: ThemeProvider().isDarkMode
                                  ? Colors.grey
                                  : Colors.black,
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
                ' ${format.format(int.parse(fee.totalExpectedAmount))}', money),
            _buildDetailRow('Outstanding:',
                ' ${format.format(fee.totalOutstandingAmount)}', money),
            _buildDetailRow('Amount Received:',
                ' ${format.format(int.parse(fee.totalAmountReceived))}',money),
            // _buildDetailRow('Amount Paid:', 'N${fee.}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,SpaceModel? money) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: setTextTheme(
              fontSize: 12.sp,
              color:
                  ThemeProvider().isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          RichText(
            text: TextSpan(
              text: '${money?.currency}',
              style: TextStyle(
                fontFamily: "Arial",
                color: ThemeProvider().isDarkMode
                    ? Colors.white
                    : Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: setTextTheme(
                    fontSize: 12.sp,
                    color: ThemeProvider().isDarkMode
                        ? Colors.white:Colors.black,
                        // : Color(0xff172B47),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCon(
  BuildContext context, {
  required String title,
  Color? cardColor,
  String? svgPath,
}) {
  return GestureDetector(
    onTap: () {
      showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: '$title is available on web',
            backgroundColor: redShades[9],
          ));
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: cardColor ?? redShades[0],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (svgPath != null)
            SvgPicture.asset(
              "assets/icons/result_icon.svg",
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          if (svgPath != null) SizedBox(width: 5.w),
          Text(
            title,
            style: setTextTheme(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          )
        ],
      ),
    ),
  );
}
