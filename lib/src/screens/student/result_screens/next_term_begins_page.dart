import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/result_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/result_screens/widgets/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:provider/provider.dart';

class NextTermBeginsPage extends StatefulWidget {
  final String spaceId;
  const NextTermBeginsPage({super.key, required this.spaceId});

  @override
  State<NextTermBeginsPage> createState() => _NextTermBeginsPageState();
}

class _NextTermBeginsPageState extends State<NextTermBeginsPage> {
  // String sessionId = '';
  // String termId = '';
  // @override
  // void initState() {
  //   sessionId = localStore.get('sessionId',
  //       defaultValue: context.read<UserProvider>().classSessionId);
  //   termId = localStore.get('termId',
  //       defaultValue: context.read<UserProvider>().termId);

  //   super.initState();
  //   Provider.of<ResultProvider>(context, listen: false).getTermDate(
  //       context: context,
  //       sessionId: sessionId,
  //       termId: termId,
  //       spaceId: widget.spaceId);
  //   final resultProvider = Provider.of<ResultProvider>(context, listen: false);
  //   numberOfDayCnt = TextEditingController(
  //     text: resultProvider.termData?.daysOpen?.toString() ?? '',
  //   );
  // }

  // DateTimeRange? selectedDateRange;
  // DateTime? closeIme;
  // DateTime? nextTermDate;
  // TextEditingController numberOfDayCnt = TextEditingController();
  // DateTime? boardingDate;
  late String sessionId;
  late String termId;
  late TextEditingController numberOfDayCnt;
  DateTime? closeIme;
  DateTime? nextTermDate;
  DateTime? boardingDate;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    numberOfDayCnt = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      sessionId = localStore.get(
        'sessionId',
        defaultValue: context.read<UserProvider>().classSessionId,
      );
      termId = localStore.get(
        'termId',
        defaultValue: context.read<UserProvider>().termId,
      );

      // Fetch API Data
      final resultProvider = context.read<ResultProvider>();
      resultProvider.getTermDate(
        context: context,
        sessionId: sessionId,
        termId: termId,
        spaceId: widget.spaceId,
      );

      // // Initialize TextEditingController with API data
      // numberOfDayCnt.text = resultProvider.termData?.daysOpen?.toString() ?? '';
      resultProvider.addListener(_updateTextField);
      _isInitialized = true;
    }
  }

  void _updateTextField() {
    if (!mounted) return;
    final resultProvider = context.read<ResultProvider>();
    final newValue = resultProvider.termData?.daysOpen?.toString() ?? '';

    if (numberOfDayCnt.text != newValue) {
      numberOfDayCnt.text = newValue;
    }
  }

  @override
  void dispose() {
    numberOfDayCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultProvider>(builder: (context, value, _) {
      if (value.isLoading) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: SkeletonListView(
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              height: 60.h,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.h,
        children: [
          Text(
            'When will this term close',
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          DatePickerWidget(
            title: 'Select Date',
            initialDate: value.termData?.currentTermClosesOn,
            onDateSelected: (date) {
              print('Selected date: $date');
              setState(() {
                closeIme = date;
              });
            },
          ),
          SizedBox(height: 5.h),
          Text(
            'When will next term begin',
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          DatePickerWidget(
            title: 'Select Date',
            initialDate: value.termData?.nextTermBeginsOn,
            onDateSelected: (date) {
              setState(() {
                nextTermDate = date;
              });
            },
          ),
          SizedBox(height: 10.h),
          Text(
            'Number of days school opened',
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextField(
            controller: numberOfDayCnt,
            keyboardType: TextInputType.number,
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d{0,3}\.?(\d{1})?$')),
            ],
            decoration: InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.only(left: 15),
              fillColor:
                  ThemeProvider().isDarkMode ? blueShades[15] : whiteShades[0],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[3]
                      : whiteShades[3],
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[0]
                      : blueShades[1],
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[3]
                      : whiteShades[3],
                  width: 0.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[3]
                      : whiteShades[3],
                  width: 0.5,
                ),
              ),
            ),
            onChanged: (value) {},
          ),
          SizedBox(height: 10.h),
          Text(
            'When will boarding close (optional)',
            style: setTextTheme(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          DatePickerWidget(
            title: 'Select Date',
            initialDate: value.termData?.boardingResumesOn,
            onDateSelected: (date) {
              setState(() {
                boardingDate = date;
              });
            },
          ),
          Spacer(),
          Consumer<ResultProvider>(builder: (context, value, _) {
            return Buttons(
              onTap: value.isLoadingStateTwo
                  ? () {}
                  : () {
                      final daysOpenText = numberOfDayCnt.text.trim();
                      // final daysOpen = daysOpenText.isNotEmpty
                      //     ? int.tryParse(daysOpenText) ?? 0
                      //     : 0;
                      final daysOpen = int.parse(daysOpenText);

                      Provider.of<ResultProvider>(context, listen: false)
                          .setResumption(
                              context: context,
                              boardingResumesOn: boardingDate,
                              spaceId: widget.spaceId,
                              currentTermClosesOn: closeIme ?? DateTime.now(),
                              nextTermBeginsOn: nextTermDate ?? DateTime.now(),
                              daysOpen: daysOpen)
                          .then((_) {
                        // closeIme = null;
                        // nextTermDate = null;
                        //numberOfDayCnt.clear();
                        boardingDate = null;
                        if (context.mounted) {
                          Provider.of<ResultProvider>(context, listen: false)
                              .getTermDate(
                                  context: context,
                                  sessionId: sessionId,
                                  termId: termId,
                                  spaceId: widget.spaceId);
                        }
                      });
                    },
              text: value.isLoadingStateTwo ? 'Saving...' : 'Save',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              isLoading: false,
            );
          })
        ],
      );
    });
  }
}
