import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/config/storage.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:cloudnottapp2/src/data/providers/accounting_providers.dart';
import 'package:cloudnottapp2/src/data/providers/exam_home_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/recorded_class_screen.dart';
import 'package:cloudnottapp2/src/screens/accounting/fee_payment_screen.dart';
import 'package:cloudnottapp2/src/screens/student/student_landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AccountSummaryScreen extends StatefulWidget {
  static const String routeName = "/account_summary";
  const AccountSummaryScreen({super.key});

  @override
  State<AccountSummaryScreen> createState() => _AccountSummaryScreenState();
}

class _AccountSummaryScreenState extends State<AccountSummaryScreen> {
  final controller = PageController(initialPage: 0);
  String userRole ='';
    @override 
    void initState(){
      super.initState(); 
       final userProvider = Provider.of<UserProvider>(context, listen: false);
       userProvider.getSpace(context, userProvider.alias, userProvider.spaceId);
       userRole = localStore.get('role', defaultValue: userProvider.role);
      final accountingProvider =
          Provider.of<AccountingProvider>(context, listen: false);
           accountingProvider.getAccountSummary(
          context: context,
          spaceId: userProvider.spaceId ?? '',
          spaceSessionId:userProvider.classSessionId ?? '',
          spaceTermIds: [userProvider.termId?? ''],
        );
    
    Provider.of<ExamHomeProvider>(context, listen: false)
        .getMyTeachersGroup(
      context: context,
      spaceId: userProvider.spaceId,
      termId: userProvider.model?.currentSpaceTerm?.id ??'',
      classGroupId:  [] ,
      sessionId: userProvider.model?.currentSpaceSessionId??'',
    );
    }
    NumberFormat format = NumberFormat(
    '#,##0',
    'en_US',
  );
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final userpro = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Summary',
          style: setTextTheme(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: customAppBarLeadingIcon(context),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            children: [
              Container(
                width: screenSize.width,
                height: 80.h,
                padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 35.w),
                decoration: BoxDecoration(
                  color: blueShades[2],
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${userpro.model?.currentSpaceSession?.session}',
                      style: setTextTheme(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: whiteShades[0],
                      ),
                    ),
                    VerticalDivider(
                      // width: 2,
                      thickness: 2,
                      color: whiteShades[0],
                    ),
                    Text(
                      '${userpro.model?.currentSpaceTerm?.name}',
                      style: setTextTheme(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: whiteShades[0],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 16 / 12,
                  ),
                  children: [
                    Consumer<ExamHomeProvider>(
                      builder: (context,value,_) {
                        return GestureDetector(
                          // onTap: () {
                          //   context.push(
                          //     '/homework_entry_screen',
                          //     extra: HomeworkModel(
                          //       subject: '',
                          //       // status: 'Open',
                          //       task: '',
                          //       date: DateTime.now(), questions: [],
                          //       // id: '123',
                          //     ),
                          //   );
                          // },
                          child: _infoCard(
                            icon: "assets/icons/assignment_icon.svg",
                            count: "${value.examTeacherGroup.length}",
                            title: "Computer Base Tests",
                            backgroundColor: greenShades[0],
                            color: whiteShades[0],
                            countText: "Group",
                          ),
                        );
                      }
                    ),
                    if(userRole =='admin')
                    _infoCard(
                      icon: "assets/icons/class_icon.svg",
                      count: "${userpro.model?.classCount}",
                      title: "My Classes",
                      backgroundColor: greenShades[1],
                      color: Colors.black,
                      countText: "Classes",
                    ),
                    // _infoCard(
                    //   icon: "assets/icons/exams_icon.svg",
                    //   count: "12",
                    //   title: "Exams",
                    //   backgroundColor: goldenShades[0],
                    //   color: Colors.black,
                    //   countText: "new",
                    // ),
                    GestureDetector(
                      onTap: () {
                        context.push(RecordedClass.routeName);
                      },
                      child: _infoCard(
                        icon: "assets/icons/recorded_icon.svg",
                        count: "${(userpro.filteredTimeTable.isNotEmpty &&
 userpro.filteredTimeTable.first.classRecordings != null)
    ? userpro.filteredTimeTable.first.classRecordings!.length
    : 0
}",
                        title: "Recorded Class",
                        backgroundColor: redShades[0],
                        color: whiteShades[0],
                        countText: "today",
                      ),
                    ),
                     if(userRole =='admin')
                    Consumer<AccountingProvider>(
                      builder: (context,value, _) {
                        return GestureDetector(
                          onTap: () {
                           context.push(StudentLandingScreen.routeName, extra: {
                              'id': context.read<UserProvider>().spaceId,
                              'provider': context.read<UserProvider>(),
                              'currentIndex':  1,
                            });
                          },
                          child: Skeletonizer(
                            enabled: value.isLoading,
                            child: _infoCard(
                              icon: "assets/icons/exams_icon.svg",
                              title: "Outstanding Payment",
                              amount: int.tryParse(value.accountingSummary?.totalOutstandingAmount ?? '0'),

                              // amount: format.format(int.parse(value?.accountingSummary?.totalOutstandingAmount ?? '0')),
                              isAmount: true,
                              backgroundColor: blueShades[0],
                              color: whiteShades[0],
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatAmount(int amount) {
    if (amount > 999999) {
      return 'NGN ${( int.parse(format.format(amount)) / 1000000).toStringAsFixed(1)}M';
    } else {
      return 'NGN ${ format.format(amount)}';
    }
  }

  Widget _infoCard(
      {Color? color,
      required String icon,
      bool? isAmount,
      int? amount,
      String? title,
      String? count,
      String? countText,
      Color? backgroundColor}) {
    return Container(
      padding: EdgeInsets.only(
        top: 15.h,
        left: 15.w,
      ),
      height: 110.h,
      width: 165.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisAlignment: isAmount == true
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
                height: 25.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Flexible(
                flex: 1,
                child: Text(
                  "$title",
                  overflow: TextOverflow.clip,
                  style: setTextTheme(
                    color: color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
          if (isAmount == true)
            Align(
              alignment: formatAmount(amount!).contains('M')
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    child: Text(
                      formatAmount(amount!),
                      style: setTextTheme(
                        color: color,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Text(
                  "$count",
                  textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                      leadingDistribution: TextLeadingDistribution.even),
                  style: setTextTheme(
                    color: color,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    lineHeight: 0.4,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "$countText",
                    textAlign: TextAlign.start,
                    style: setTextTheme(
                      color: color,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}
