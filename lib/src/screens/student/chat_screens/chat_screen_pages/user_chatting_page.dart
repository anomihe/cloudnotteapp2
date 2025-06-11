import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/user_chatting_mock_data.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/widgets/text_field_widget.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_widgets/user_chatting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UserChattingPage extends StatefulWidget {
  const UserChattingPage({super.key, required this.userChatModel});
  static const String routeName = '/user_chatting_page';
  final UserChatModel userChatModel;

  @override
  State<UserChattingPage> createState() => _UserChattingPageState();
}

class _UserChattingPageState extends State<UserChattingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: customAppBarLeadingIcon(context),
        title: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.userChatModel.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(100)),
            ),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                widget.userChatModel.title,
                overflow: TextOverflow.ellipsis,
                style: setTextTheme(
                  fontSize: 15.sp,
                ),
              ),
            ),
            SizedBox(width: 5),
            if (widget.userChatModel.isVerified == true)
              SvgPicture.asset('assets/icons/verified_icon.svg')
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    //
                  },
                  child: SvgPicture.asset(
                    'assets/icons/call_icon_border.svg',
                    height: 26.r,
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Container(
                    width: 25.r,
                    height: 25.r,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        border: Border.all()),
                    child: SvgPicture.asset(
                      'assets/icons/video_icon.svg',
                    ),
                  ),
                ),
              ],
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
                  SizedBox(
                    width: 7.w,
                  ),
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
