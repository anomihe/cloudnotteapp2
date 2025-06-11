import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/user_chatting_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UserChattingWidget extends StatelessWidget {
  const UserChattingWidget({
    super.key,
    required this.chat,
    this.isFirstMessage = false,
  });

  final UserChattingModel chat;
  final bool isFirstMessage;

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        chat.isUserMessage ? Alignment.centerLeft : Alignment.centerRight;

    final messageTime = DateFormat('HH:mm').format(chat.dateTime);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          if (isFirstMessage)
            Container(
              height: 20.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: redShades[6],
              ),
              child: Center(
                child: Text(
                  chat.formatDateTime,
                  style: setTextTheme(
                      // color: whiteShades[0],
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            alignment: messageAlignment,
            child: Container(
              margin: chat.isUserMessage
                  ? EdgeInsets.only(right: 50.w)
                  : EdgeInsets.only(left: 50.w),
              decoration: BoxDecoration(
                color: chat.isUserMessage
                    ? (ThemeProvider().isDarkMode
                        ? blueShades[2]
                        : redShades[7])
                    : redShades[1],
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 14.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      chat.text,
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: chat.isUserMessage
                            ? (ThemeProvider().isDarkMode
                                ? Colors.white
                                : Colors.black)
                            : Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      messageTime,
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
