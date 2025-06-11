import 'dart:async';
import 'dart:developer';

import 'package:cloudnottapp2/src/config/config.dart';

import 'package:cloudnottapp2/src/data/providers/live_kit_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/class_schedules_screen.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:cloudnottapp2/src/screens/student/live_class_screens/live_class_screen.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_recorded.dart';
import 'package:cloudnottapp2/src/screens/teacher/teacher_screens/teacher_recording.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/user_model.dart';

class SchedulesWidget extends StatefulWidget {
  const SchedulesWidget({
    super.key,
    required this.classSchedulesModel,
    required this.index,
  });
  final ClassTimeTable classSchedulesModel;
  // final ClassSchedulesModel classSchedulesModel;
  final int index;

  @override
  State<SchedulesWidget> createState() => _SchedulesWidgetState();
}

class _SchedulesWidgetState extends State<SchedulesWidget> {
  late Timer _timer;
  String _formattedTime = '';
  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _formattedTime = DateFormat.jm().format(now);
    });
  }

  // void _startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     _updateTime();
  //   });
  // }

  String generatedName = "Jenny";
  String totalHours = '';
  List<String> startTime = [];
  String? myDuration;
  String endTime = '';
  DateTime? time;
  DateTime now = DateTime.now();
  // void generateRandomName() {
  //   final random = Random();
  //   setState(() {
  //     generatedName = names[random.nextInt(names.length)];
  //   });
  // }
  String? userRole;
  @override
  void initState() {
    userRole = context.read<UserProvider>().singleSpace?.role?.toLowerCase();
    super.initState();
    _updateTime();
    // _startTimer();
    classTime();
    // generateRandomName();
  }

  void classTime() {
    setState(() {
      startTime = widget.classSchedulesModel.timeSlot?.time?.split('-') ?? [];
    });

    print("my time $startTime $myDuration");
    try {
      time = DateFormat.Hm().parse(startTime[1].trim());
    } catch (e) {
      print("Error parsing time: $e");
    }

    //myDuration.addAll(timeDifferences);
    // _startTimer();
    //print('condition ${widget.classSchedulesModel.liveClassroom}');
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dura = TimeCalculator.formatDuration(TimeCalculator.duration);
    DateTime dateTimeToCheck = DateTime(
      now.year,
      now.month,
      now.day,
      time?.hour ?? 0,
      time?.minute ?? 0,
    );
    final List<String> svgIconPaths = [
      'assets/icons/crown_icon.svg',
      'assets/icons/settings_icon.svg',
      'assets/icons/theme_icon.svg',
      'assets/icons/filter_icon.svg',
    ];
    final liveKitController = Provider.of<LiveKitController>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () async {
        log("USERNAME: ${userProvider.user?.username}");
        if (userProvider.user?.username == null ||
            userProvider.user?.username == "") {
          Alert.displaySnackBar(context, message: "Please login first");
          context.pop();
          return;
        }
        if (widget.classSchedulesModel.liveClassroom == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Alert.showLoading(context);
          });
          String? token = await liveKitController.getConnectionToken(
            username: userProvider.user?.username ?? "",
            meetId: widget.classSchedulesModel.id ?? "",
            userId: userProvider.user?.id ?? "",
            fullName:
                "${userProvider.user?.firstName} ${userProvider.user?.lastName}",
            email: userProvider.user?.email == null
                ? userProvider.user?.email ?? ""
                : DateTime.now().toIso8601String().toString(),
            role: userProvider.singleSpace?.role ?? "student",
          );
          token != null ? await liveKitController.connectToRoom(token) : {};
          if (liveKitController.isConnected) {
            Alert.hideDialog(context);
            context.push(LiveClassScreen.routeName, extra: {
              "callId": widget.classSchedulesModel.id,
              "username": userProvider.user?.username,
              "userId": userProvider.user?.id,
              "peerId": "",
              "room": liveKitController.room,
              "listener": liveKitController.listener,
            });
          }
          if (liveKitController.isError) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                Alert.hideDialog(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(liveKitController.errorMessage ?? ""),
                  ),
                );
              },
            );
          }
        } else {
          if (userProvider.singleSpace?.role != "student") {
            if (widget.classSchedulesModel.classRecordings?.isNotEmpty ==
                true) {
              context.push(
                TeacherRecorded.routeName,
                extra: widget.classSchedulesModel,
              );
            } else {
              context.push(
                TeacherRecording.routeName,
                extra: widget.classSchedulesModel,
              );
            }
          }
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            // the divider lines
            margin: EdgeInsets.only(left: 20.w, right: 10.w),
            padding: EdgeInsets.only(left: 25.w),
            height: 71.h,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 1.w,
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : blueShades[5],
                ),
                bottom: BorderSide(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[16]
                      : blueShades[5],
                ),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "${startTime[0]} - ${startTime[1]}",
                        style: setTextTheme(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: '',
                            style: setTextTheme(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${dura} ',
                      // '1 H / until ${widget.classSchedulesModel.timeSlot?.time ?? 'Unknown'}',
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 7.5.w,
            top: 71.h / 2 - 23.h / 2,
            child: Container(
              // checkmark container
              width: 26.w,
              height: 23.h,
              decoration: BoxDecoration(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : blueShades[7],
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(color: whiteShades[0], width: 3)),
              child: (dateTimeToCheck.isBefore(now) ||
                      dateTimeToCheck.isAtSameMomentAs(now))
                  ? SvgPicture.asset('assets/icons/check_mark_icon.svg')
                  : null,
              // child: DateTime.now().isAfter(time ?? DateTime.now())
              //     ? SvgPicture.asset('assets/icons/check_mark_icon.svg')
              //     : null,
              // child: widget.index == 0
              //     ? SvgPicture.asset('assets/icons/check_mark_icon.svg')
              //     : null,
            ),
          ),
          Positioned(
            right: 7.5.w,
            top: 5.h,
            child: Container(
                width: 140.w,
                height: 58.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : blueShades[5],
                  border: Border.all(
                      color: ThemeProvider().isDarkMode
                          ? Colors.transparent
                          : blueShades[6]),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: (widget.classSchedulesModel.activity
                            ?.trim()
                            .isNotEmpty ??
                        false)
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.classSchedulesModel.activity!.toUpperCase() ??
                              'No Activity',
                          overflow: TextOverflow.ellipsis,
                          style: setTextTheme(fontSize: 14.sp),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((widget.classSchedulesModel.subject?.name
                                  ?.trim()
                                  .isNotEmpty ??
                              false))
                            Text(
                              widget.classSchedulesModel.subject!.name != null
                                  ? widget.classSchedulesModel.subject!.name!
                                      .toUpperCase()
                                  : 'No Subject',
                              overflow: TextOverflow.ellipsis,
                              style: setTextTheme(fontSize: 14.sp),
                            ),
                          Row(
                            children: [
                              widget.classSchedulesModel.subject?.teacher?.user
                                          ?.profileImageUrl !=
                                      null
                                  ? Container(
                                      width: 24.r,
                                      height: 24.r,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            widget
                                                    .classSchedulesModel
                                                    .subject
                                                    ?.teacher
                                                    ?.user
                                                    ?.profileImageUrl ??
                                                '',
                                          ) as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 20.r,
                                      height: 20.r,
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          ThemeProvider().isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                            'assets/app/profile_picture1.png', color: Colors.black,),
                                      ),
                                    ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: Text(
                                  userRole == 'teacher'
                                      ? ' ${widget.classSchedulesModel.classInfo?.classGroup?.name}-${widget.classSchedulesModel.classInfo?.name}'
                                      : " ${widget.classSchedulesModel.subject?.teacher?.user?.firstName ?? widget.classSchedulesModel.subject?.teacher?.user?.firstName ?? "No Instructor"}",
                                  overflow: TextOverflow.ellipsis,
                                  style: setTextTheme(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
          ),
          if (widget.classSchedulesModel.liveClassroom == true) ...[
            Positioned(
              right: 132.5.w,
              top: 71.h / 2 - 23.h / 2,
              child: Container(
                width: 25.w,
                height: 23.h,
                decoration: BoxDecoration(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : whiteShades[0],
                  border: Border.all(
                    color: ThemeProvider().isDarkMode
                        ? blueShades[2]
                        : blueShades[6],
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: SvgPicture.asset(
                  'assets/app/play_14438589.svg',
                  color:
                      ThemeProvider().isDarkMode ? blueShades[1] : Colors.black,
                  // fit: BoxFit.none,
                  width: 15,
                  height: 15,
                    fit: BoxFit.contain,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
