import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/call_screens/add_to_call_screen.dart';
import 'package:cloudnottapp2/src/screens/call_screens/call_settings_screen.dart';
import 'package:cloudnottapp2/src/screens/call_screens/widgets/call_action_buttons.dart';
import 'package:cloudnottapp2/src/screens/call_screens/widgets/toggled_video_box.dart';
import 'package:cloudnottapp2/src/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OneToOneCallScreen extends StatefulWidget {
  static const String routeName = '/oneToOneCallScreen';
  const OneToOneCallScreen({super.key});

  @override
  OneToOneCallScreenState createState() => OneToOneCallScreenState();
}

class OneToOneCallScreenState extends State<OneToOneCallScreen> {
  late Offset floatingBoxPosition;
  bool audioPressed = false;
  bool videoPressed = false;
  bool visibleAction = true;
  bool isBottomRight = false;
  final horizontalPadding = 5.0.w;
  final verticalPadding = 7.h;
  final addedHei = 40.h + 40.h; // action buttons height + spacing
  final removeHei = 40.h;
  final double boxWidth = 120.w; // Width of the draggable box
  final double boxHeight = 140.h; // Height of the draggable box

  void _toggleAudio() {
    setState(() {
      audioPressed = !audioPressed;
    });
  }

  void _toggleVideo() {
    setState(() {
      videoPressed = !videoPressed;
    });
  }

  void _toggleVisibleAction() {
    setState(() {
      visibleAction = !visibleAction;
    });
  }

  void _animateToBottomRight() {
    final screenSize = MediaQuery.of(context).size;
    setState(
      () {
        if (isBottomRight) {
          floatingBoxPosition = Offset(
            screenSize.width - boxWidth - 20.w,
            screenSize.height - boxHeight - addedHei - verticalPadding * 8,
          ); // move up a bit
        } else {
          floatingBoxPosition = Offset(
            screenSize.width - boxWidth - 20.w,
            screenSize.height - boxHeight - removeHei - verticalPadding * 6,
          ); // Move to bottom right
        }
        isBottomRight = !isBottomRight;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        floatingBoxPosition = Offset(
          screenSize.width - boxWidth - 20.w,
          screenSize.height - boxHeight - addedHei - verticalPadding * 3,
        );
      });
    });
  }

  double _constrain(double value, double min, double max) {
    return value.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Stack(
            children: [
              // Main video call background
              GestureDetector(
                onTap: () {
                  setState(() {
                    _toggleVisibleAction();
                    _animateToBottomRight();
                  });
                },
                child: Container(
                  height: screenSize.height - 33.h,
                  width: screenSize.width - horizontalPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: redShades[1],
                      width: 4.w,
                    ),
                    image: const DecorationImage(
                        image: AssetImage(
                          'assets/app/teacher_image.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              // draggable floating box
              Positioned(
                left: floatingBoxPosition.dx,
                top: floatingBoxPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(
                      () {
                        // update position and constrain it within screen bounds
                        floatingBoxPosition = Offset(
                          _constrain(
                            // horizontal bounds
                            floatingBoxPosition.dx + details.delta.dx,
                            horizontalPadding * 2, // left
                            screenSize.width -
                                boxWidth -
                                verticalPadding * 2.5, // right
                          ),
                          _constrain(
                            // vertical bounds
                            floatingBoxPosition.dy + details.delta.dy,
                            verticalPadding, // top
                            !visibleAction
                                ? screenSize.height - boxHeight - removeHei * 2
                                : screenSize.height -
                                    boxHeight -
                                    addedHei -
                                    verticalPadding * 8, // bottom
                          ),
                        );
                      },
                    );
                  },
                  child: ToggledVideoBox(
                    isAudioMuted: !audioPressed,
                    isVideoMuted: !videoPressed,
                    width: boxWidth,
                    height: boxHeight,
                    isOnToOne: true,
                    streamUrl: 'assets/app/mock_person_image.jpg',
                    profilePicUrl: 'assets/app/mock_person_image.jpg',
                  ),
                ),
              ),
              if (visibleAction)
                Positioned(
                  top: 10.h,
                  left: 15.w,
                  child: CallButton(
                    onTap: () {},
                    svgIcon: 'assets/icons/minimize_call.svg',
                    boxColor: blueShades[14],
                    svgColor: whiteShades[0],
                  ),
                ),
              if (visibleAction)
                Positioned(
                  top: 10.h,
                  right: 15.w,
                  child: CallButton(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        isDismissible: true,
                        useSafeArea: true,
                        builder: (context) {
                          return const CallSettingsScreen();
                        },
                      );
                    },
                    svgIcon: 'assets/icons/options_icon.svg',
                    boxColor: blueShades[14],
                    svgColor: whiteShades[0],
                  ),
                ),
              if (visibleAction)
                Positioned(
                  left: (screenSize.width / 10) - horizontalPadding * 3,
                  bottom: 4.h,
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    width: screenSize.width - 27.w * 2,
                    decoration: BoxDecoration(
                      color: blueShades[15],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ToggleColorCallButton(
                          // voice call muted icon
                          isPressed: audioPressed,
                          onTap: _toggleAudio,
                          svgIcon: Icons.keyboard_voice_outlined,

                          svgIcon1: Icons.mic_off_outlined,

                          boxColor: blueShades[3],
                          // svgColor: whiteShades[0],
                        ),
                        ToggleColorCallButton(
                          // toggle video icon
                          isPressed: videoPressed,
                          onTap: _toggleVideo,
                          svgIcon: Icons.videocam_outlined,
                          svgIcon1: Icons.videocam_off_outlined,
                          boxColor: blueShades[3],
                        ),
                        CallButton(
                          onTap: () {
                            // show live chat screen but dont leave the screen
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              isDismissible: true,
                              useSafeArea: true,
                              builder: (context) {
                                return const AddToCallScreen();
                              },
                            );
                          },
                          svgIcon: 'assets/icons/add_to_call.svg',
                          boxColor: blueShades[3],
                        ),
                        CallButton(
                          onTap: () {},
                          svgIcon: 'assets/icons/exams_icon.svg',
                          boxColor: blueShades[3],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CallButton(
                            // end call button
                            onTap: () {
                              appCustomDialog(
                                context: context,
                                title: 'End Call',
                                content:
                                    'Are you sure you want to end the call?',
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
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
