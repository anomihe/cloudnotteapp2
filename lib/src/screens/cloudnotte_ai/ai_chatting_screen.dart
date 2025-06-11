import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/user_chatting_mock_data.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/call_screens/widgets/call_action_buttons.dart';

import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';

import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_widgets/user_chatting_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AiChattingScreen extends StatefulWidget {
  const AiChattingScreen({super.key, required this.aiChatModel});
  static const String routeName = '/ai_chatting_screen';
  final UserChatModel aiChatModel;

  @override
  State<AiChattingScreen> createState() => _AiChattingScreenState();
}

class _AiChattingScreenState extends State<AiChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: customAppBarLeadingIcon(context),
        title: GestureDetector(
          onTap: () {
            // context.push(AiProfileScreen.routeName);
          },
          child: Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.aiChatModel.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                widget.aiChatModel.title,
                style: setTextTheme(fontSize: 15.sp),
              ),
              SizedBox(width: 5),
              if (widget.aiChatModel.isVerified == true)
                SvgPicture.asset('assets/icons/verified_icon.svg'),
            ],
          ),
        ),
        actions: [
          Material(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: GestureDetector(
                onTap: () {
                  // context.push(AiCallScreen.routeName);
                },
                child: SvgPicture.asset(
                  'assets/icons/call_icon_border.svg',
                  height: 26.r,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dummyChatting.length,
                itemBuilder: (ctx, index) => UserChattingWidget(
                  chat: dummyChatting[index],
                  isFirstMessage: index == 0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.r),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/icons/+.svg',
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        ThemeProvider().isDarkMode
                            ? blueShades[3]
                            : Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomTextFormField(
                      hintText: "Type a message",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 14.w,
                      ),
                      // fillColor: redShades[3],
                      borderRadius: 25.r,
                      // textAlignVertical: TextAlignVertical(y: 0),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(width: 7.w),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/icons/camera_icon.svg',
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        ThemeProvider().isDarkMode
                            ? blueShades[3]
                            : Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.keyboard_voice_outlined,
                      color: ThemeProvider().isDarkMode
                          ? blueShades[3]
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
