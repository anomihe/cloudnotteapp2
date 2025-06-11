import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/chat_message_model.dart';
import 'package:cloudnottapp2/src/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LiveMessagesWidget extends StatelessWidget {
  const LiveMessagesWidget({
    super.key,
    required this.liveClassChatModel,
    this.isFirstMessage = false,
  });

  final ChatMessageModel liveClassChatModel;
  final bool isFirstMessage;

  @override
  Widget build(BuildContext context) {
    // Determine message alignment based on isStudentMessage
    final messageAlignment = liveClassChatModel.user?.role == "teacher"
        ? Alignment.centerRight
        : Alignment.centerRight;

    final messageTime = DateFormat.Hm().format(
      DateTime.parse(
        liveClassChatModel.timeStamps ?? DateTime.now().toIso8601String(),
      ),
    );
    // final messageTime = DateFormat('HH:mm').format(
    //   DateTime.parse(
    //     liveClassChatModel.timeStamps ?? DateTime.now().toIso8601String(),
    //   ),
    // );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          // show date at the top for the first message
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
                  liveClassChatModel.formattedDateTime,
                  style: setTextTheme(
                    color: whiteShades[0],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(height: 10.h),
          liveClassChatModel.user?.name ==
                  context.read<UserProvider>().user?.username
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 300.w,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                      ),
                      // margin: const EdgeInsets.only(right: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20.h,
                            // width: 500.w,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: redShades[5],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              liveClassChatModel.user?.name ?? "Unknown",
                              style: setTextTheme(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: blueShades[8],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: redShades[7],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                )),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 14.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    liveClassChatModel.message ?? "",
                                    style: setTextTheme(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: blueShades[8],
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
                                      color: blueShades[2],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(width: 5.w),
                    // Container(
                    //   width: 37.w,
                    //   height: 37.w,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(100.r),
                    //     image: DecorationImage(
                    //       image: liveClassChatModel.user?.image == null
                    //           ? const AssetImage(
                    //               "assets/app/mock_person_image.jpg")
                    //           : NetworkImage(
                    //               liveClassChatModel.user?.image ?? "",
                    //             ),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: 37.w,
                    //   height: 37.w,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(100.r),
                    //     image: DecorationImage(
                    //       image: liveClassChatModel.user?.image == null
                    //           ? const AssetImage(
                    //               "assets/app/mock_person_image.jpg")
                    //           : NetworkImage(
                    //               liveClassChatModel.user?.image ?? "",
                    //             ),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 5.w),
                    Container(
                      width: 300.w,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                      ),
                      // margin: const EdgeInsets.only(right: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20.h,
                            // width: 500.w,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: redShades[5],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              liveClassChatModel.user?.name ?? "Unknown",
                              style: setTextTheme(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: blueShades[8],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: redShades[7],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                )),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 14.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    liveClassChatModel.message ?? "",
                                    style: setTextTheme(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: blueShades[8],
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
                                      color: blueShades[2],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
