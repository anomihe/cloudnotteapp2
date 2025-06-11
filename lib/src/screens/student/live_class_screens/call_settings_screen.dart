import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/providers/live_kit_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/utils/alert.dart';
import 'package:cloudnottapp2/src/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CallSettingsScreen extends StatefulWidget {
  final String? callId;
  const CallSettingsScreen({super.key, this.callId});
  static const String routeName = '/call_settings_screen';

  @override
  State<CallSettingsScreen> createState() => _CallSettingsScreenState();
}

class _CallSettingsScreenState extends State<CallSettingsScreen> {
  String? selectedLanguage;
  bool isRecorded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customAppBarLeadingIcon(context),
        title: Text(
          'Settings',
          style: setTextTheme(
            fontSize: 24.sp,
            color: ThemeProvider().isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body:
          Consumer<LiveKitController>(builder: (context, liveKitController, _) {
        return Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            spacing: 10.r,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdownFormField(
                title: 'Whats your preferred language?',
                items: [
                  DropdownMenuItem(
                    value: 'English',
                    child: Text(
                      'English',
                      style: setTextTheme(),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'French',
                    child: Text(
                      'French',
                      style: setTextTheme(),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Italian',
                    child: Text(
                      'Italian',
                      style: setTextTheme(),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Spanish',
                    child: Text(
                      'Spanish',
                      style: setTextTheme(),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(
                    () {
                      selectedLanguage = value as String;
                    },
                  );
                },
              ),
              Text.rich(
                TextSpan(
                    text: 'Your conversations will now be interpreted in ',
                    style: setTextTheme(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: selectedLanguage ?? 'English',
                        style: setTextTheme(
                          color: redShades[0],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ]),
              ),
              SizedBox(height: 5.h),
              CustomDropdownFormField(
                title: 'Whats your preferred voice type?',
                items: [
                  DropdownMenuItem(
                    value: 'Female Accent',
                    child: Text(
                      'Female Accent',
                      style: setTextTheme(),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Male Accent',
                    child: Text(
                      'Male Accent',
                      style: setTextTheme(),
                    ),
                  ),
                ],
                onChanged: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Record Class',
                    style: setTextTheme(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: liveKitController.isRecording,
                      inactiveThumbColor: Colors.grey[600],
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      onChanged: (value) async {
                        if (liveKitController.isRecording == false) {
                          await liveKitController
                              .startRecording(widget.callId ?? "");
                          if (liveKitController.isError) {
                            Alert.displaySnackBar(context,
                                message: liveKitController.errorMessage ??
                                    "Error Occurred");
                          }
                        } else {
                          appCustomDialog(
                            context: context,
                            title: 'Stop recording?',
                            content: 'Stop recording?',
                            action1: 'No',
                            action2: 'Yes',
                            action1Function: () {
                              context.pop();
                            },
                            action2Function: () async {
                              await liveKitController
                                  .stopRecording(widget.callId ?? "");
                              if (liveKitController.isError) {
                                Alert.displaySnackBar(context,
                                    message: liveKitController.errorMessage ??
                                        "Error Occurred");
                              }
                              context.pop();
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Buttons(
                text: 'Save',
                fontSize: 15.sp,
                onTap: () {},
                isLoading: false,
              )
            ],
          ),
        );
      }),
    );
  }
}
