import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/call_screens/widgets/call_action_buttons.dart';
import 'package:cloudnottapp2/src/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CallWaitingScreen extends StatefulWidget {
  const CallWaitingScreen({super.key});

  @override
  State<CallWaitingScreen> createState() => _CallWaitingScreenState();
}

class _CallWaitingScreenState extends State<CallWaitingScreen> {
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
          padding: EdgeInsets.all(5.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CallButton(
                      onTap: () {},
                      svgIcon: 'assets/icons/minimize_call.svg',
                      boxColor: blueShades[14],
                      svgColor: whiteShades[0],
                    ),
                    // Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Sarah Nwachukwu',
                          style: setTextTheme(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Calling...',
                          style: setTextTheme(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            lineHeight: 1,
                          ),
                        ),
                      ],
                    ),
                    // Spacer(),
                    CallButton(
                      onTap: () {},
                      svgIcon: 'assets/icons/options_icon.svg',
                      boxColor: blueShades[14],
                      svgColor: whiteShades[0],
                    ),
                  ],
                ),
              ),
              // SvgPicture.asset('assets/app/cloudnottapp2_logo_two.svg'),
              Image.asset(
                'assets/app/cloudnottapp2_logo_two.png',
              ),
              Container(
                padding: EdgeInsets.all(10.r),
                width: screenSize.width * 0.45,
                decoration: BoxDecoration(
                  color: blueShades[15],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleColorCallButton(
                      // voice call muted icon
                      isPressed: audioPressed,
                      onTap: _toggleAudio,
                      svgIcon: Icons.keyboard_voice_outlined,
                      svgIcon1: Icons.mic_off_outlined,
                      boxColor: blueShades[14],
                      svgColor: whiteShades[0],
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
