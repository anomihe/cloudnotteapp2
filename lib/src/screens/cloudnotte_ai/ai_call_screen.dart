import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/call_screens/add_to_call_screen.dart';
import 'package:cloudnottapp2/src/screens/call_screens/one_to_one.dart';
import 'package:cloudnottapp2/src/screens/call_screens/widgets/call_action_buttons.dart';
// import 'package:cloudnottapp2/src/screens/cloudnottapp2_ai/ai_call_translation_settings_screen.dart';
import 'package:cloudnottapp2/src/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';

class AiCallScreen extends StatefulWidget {
  const AiCallScreen({super.key, required this.userChatModel});

  static const String routeName = '/ai_call_screen';
  final UserChatModel userChatModel;

  @override
  State<AiCallScreen> createState() => _AiCallScreenState();
}

class _AiCallScreenState extends State<AiCallScreen> {
  bool audioPressed = false;

  void _toggleAudio() {
    setState(() {
      audioPressed = !audioPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Container(
                      width: 35.r,
                      height: 35.r,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: ThemeProvider().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        border: Border.all(),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/minimize_call.svg',
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          ThemeProvider().isDarkMode
                              ? Colors.black
                              : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'cloudnottapp2 Ai',
                            style: setTextTheme(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 5),
                          if (widget.userChatModel.isVerified == true)
                            SvgPicture.asset('assets/icons/verified_icon.svg'),
                        ],
                      ),
                      Text(
                        '20:32',
                        style: setTextTheme(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // showModalBottomSheet(
                      //   isScrollControlled: true,
                      //   context: context,
                      //   isDismissible: true,
                      //   useSafeArea: true,
                      //   builder: (context) {
                      //     return const AiCallTranslationSettingsScreen();
                      //   },
                      // );
                    },
                    child: Container(
                      width: 35.r,
                      height: 35.r,
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: ThemeProvider().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        border: Border.all(),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/settings_icon_2.svg',
                        colorFilter: ColorFilter.mode(
                          ThemeProvider().isDarkMode
                              ? Colors.black
                              : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset('assets/app/logo_cloudnottapp2.png'),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                width: screenSize.width / 2.1,
                decoration: BoxDecoration(
                  color: blueShades[15],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToggleColorCallButton(
                      isPressed: audioPressed,
                      onTap: _toggleAudio,
                      svgColor: Colors.white,
                      svgIcon: Icons.keyboard_voice_outlined,
                      svgIcon1: Icons.mic_off_outlined,
                      boxColor: Colors.transparent,
                    ),
                    SizedBox(width: 15.w),
                    CallButton(
                      // end call button
                      onTap: () {
                        appCustomDialog(
                          context: context,
                          title: 'End Call',
                          content: 'Are you sure you want to end the call?',
                          action1: 'No',
                          action2: 'Yes',
                          action1Function: () {
                            context.pop();
                          },
                          action2Function: () {
                            // end call logic
                            context.pop();
                            context.pop();
                          },
                        );
                      },
                      width: screenSize.width * 0.2,
                      svgIcon: 'assets/icons/call_icon_flat.svg',
                      svgColor: whiteShades[0],
                      boxColor: redShades[1],
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
}
