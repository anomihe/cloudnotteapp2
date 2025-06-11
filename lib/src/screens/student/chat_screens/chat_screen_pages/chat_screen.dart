import 'package:cloudnottapp2/src/data/local/mockdata/user_chat_mock_data.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/call_screens/one_to_one.dart';
import 'package:cloudnottapp2/src/screens/cloudnotte_ai/ai_chat_widget.dart';
import 'package:cloudnottapp2/src/screens/cloudnotte_ai/ai_chatting_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_widgets/user_chat_initial_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = "/chat_screens";
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 8.w,
        leading: SizedBox(
          width: 0.w,
        ),
        centerTitle: false,
        title: Text(
          'Chats',
          style: setTextTheme(
            fontSize: 24.sp,
          ),
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
                    // temporary navigation... remove
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OneToOneCallScreen()));
                  },
                  child: SvgPicture.asset(
                    'assets/icons/search_icon.svg',
                    colorFilter: ColorFilter.mode(
                      ThemeProvider().isDarkMode
                          ? whiteShades[0]
                          : Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/icons/add_icon.svg',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 15.w,
        ),
        child: Column(
          children: [
            AiChatWidget(
              userChatModel: aiChatDisplay,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dummyChatDisplay.length,
                itemBuilder: (BuildContext context, int index) =>
                    UserChatInitialDisplay(
                        userChatModel: dummyChatDisplay[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
