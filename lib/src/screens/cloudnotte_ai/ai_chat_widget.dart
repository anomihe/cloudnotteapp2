import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/user_chat_mock_data.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/screens/cloudnotte_ai/ai_chatting_screen.dart';
import 'package:cloudnottapp2/src/screens/cloudnotte_ai/ai_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AiChatWidget extends StatelessWidget {
  const AiChatWidget({super.key, required this.userChatModel});

  final UserChatModel userChatModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                context.push(
                  AiProfileScreen.routeName,
                );
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    child: Image.asset(userChatModel.image),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: userChatModel.isOnline == true
                            ? Colors.green
                            : Colors.yellow,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.push(
                    AiChattingScreen.routeName,
                    extra: aiChatDisplay,
                  );
                },
                child: Material(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userChatModel.title,
                                style: setTextTheme(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              if (userChatModel.isVerified == true)
                                SvgPicture.asset(
                                    'assets/icons/verified_icon.svg')
                            ],
                          ),
                          Text(
                            userChatModel.text,
                            style: setTextTheme(
                              fontSize: 12.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userChatModel.formatDateTime,
                            style: setTextTheme(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // notification counter here
                          if (userChatModel.notificationCount > 0)
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: redShades[1],
                                  radius: 6.5.r,
                                  child: Center(
                                    child: Text(
                                      userChatModel.notificationCount
                                          .toString(),
                                      style: setTextTheme(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 7.w)
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
