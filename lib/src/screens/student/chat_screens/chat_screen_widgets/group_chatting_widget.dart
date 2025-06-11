import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/data/models/user_chatting_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class GroupChattingWidget extends StatelessWidget {
  const GroupChattingWidget({
    super.key,
    required this.chat,
    this.isFirstMessage = false,
    required this.userChatModel,
  });

  final UserChattingModel chat;
  final UserChatModel userChatModel;
  final bool isFirstMessage;

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        chat.isUserMessage ? Alignment.centerLeft : Alignment.centerRight;

    final messageTime = DateFormat('HH:mm').format(chat.dateTime);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                    color: whiteShades[0],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(height: 10.h),
          chat.isUserMessage
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 35.r,
                      height: 35.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/app/profile_picture1.png',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              ThemeProvider().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              BlendMode.srcIn,
                            )),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                        ),
                        alignment: messageAlignment,
                        child: Padding(
                          padding: EdgeInsets.only(right: 50.w),
                          child: Column(
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
                                  color: ThemeProvider().isDarkMode
                                      ? Color.fromARGB(255, 12, 70, 118)
                                      : redShades[5],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  "Chimeruze chidimdu",
                                  style: setTextTheme(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeProvider().isDarkMode
                                        ? whiteShades[0]
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.only(right: 50.w),
                                decoration: BoxDecoration(
                                  color: (ThemeProvider().isDarkMode
                                      ? blueShades[2]
                                      : redShades[7]),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.r),
                                    bottomRight: Radius.circular(20.r),
                                  ),
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
                                          color: (ThemeProvider().isDarkMode
                                              ? Colors.white
                                              : Colors.black),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        alignment: messageAlignment,
                        child: Container(
                          margin: EdgeInsets.only(left: 50.w),
                          decoration: BoxDecoration(
                            color: redShades[1],
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 14.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  chat.text,
                                  style: setTextTheme(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
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
                    ),
                  ],
                )
        ],
      ),
    );
  }
}


// import 'package:cloudnottapp2/src/config/config.dart';
// import 'package:cloudnottapp2/src/data/models/chat_message_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// class LiveMessagesWidget extends StatelessWidget {
//   const LiveMessagesWidget({
//     super.key,
//     required this.liveClassChatModel,
//     this.isFirstMessage = false,
//   });

//   final ChatMessageModel liveClassChatModel;
//   final bool isFirstMessage;

//   @override
//   Widget build(BuildContext context) {
    // Determine message alignment based on isStudentMessage
  //   final messageAlignment = liveClassChatModel.user?.role == "teacher"
  //       ? Alignment.centerRight
  //       : Alignment.centerLeft;

  //   final messageTime = DateFormat('HH:mm').format(
  //     DateTime.parse(
  //       liveClassChatModel.timeStamps ?? DateTime.now().toIso8601String(),
  //     ),
  //   );
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     child: Column(
  //       children: [
  //         // show date at the top for the first message
  //         if (isFirstMessage)
  //           Container(
  //             height: 20.h,
  //             width: 100.w,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(20.r),
  //               color: redShades[6],
  //             ),
  //             child: Center(
  //               child: Text(
  //                 liveClassChatModel.formattedDateTime,
  //                 style: setTextTheme(
  //                   color: whiteShades[0],
  //                   fontSize: 10.sp,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //         SizedBox(height: 10.h),
  //         liveClassChatModel.user?.role == "student"
  //             ? Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Container(
  //                     alignment: messageAlignment,
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color: redShades[1],
  //                         borderRadius: BorderRadius.circular(20.r),
  //                       ),
  //                       padding: EdgeInsets.symmetric(
  //                         vertical: 10.h,
  //                         horizontal: 14.w,
  //                       ),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.end,
  //                         children: [
  //                           Align(
  //                             alignment: Alignment.centerLeft,
  //                             child: Text(
  //                               liveClassChatModel.message ?? "",
  //                               style: setTextTheme(
  //                                   fontSize: 12.sp,
  //                                   fontWeight: FontWeight.w500,
  //                                   // color: whiteShades[0]
  //                                   ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 10.h,
  //                           ),
  //                           Align(
  //                             alignment: Alignment.centerRight,
  //                             child: Text(
  //                               messageTime,
  //                               style: setTextTheme(
  //                                 fontSize: 12.sp,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: whiteShades[0],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 5.w),
  //                   Container(
  //                     width: 37.w,
  //                     height: 37.w,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(100.r),
  //                       image: DecorationImage(
  //                         image: liveClassChatModel.user?.image == null
  //                             ? const AssetImage(
  //                                 "assets/app/mock_person_image.jpg")
  //                             : NetworkImage(
  //                                 liveClassChatModel.user?.image ?? "",
  //                               ),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             : Row(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     width: 37.w,
  //                     height: 37.w,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(100.r),
  //                       image: DecorationImage(
  //                         image: liveClassChatModel.user?.image == null
  //                             ? const AssetImage(
  //                                 "assets/app/mock_person_image.jpg")
  //                             : NetworkImage(
  //                                 liveClassChatModel.user?.image ?? "",
  //                               ),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 5.w),
  //                   Container(
  //                     width: 270.w,
  //                     padding: EdgeInsets.symmetric(vertical: 4.h),
  //                     // margin: const EdgeInsets.only(right: 50),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                           height: 20.h,
  //                           // width: 500.w,
  //                           width: double.infinity,
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 16.w, vertical: 4.h),
  //                           decoration: BoxDecoration(
  //                             color: redShades[5],
  //                             borderRadius: BorderRadius.only(
  //                               topLeft: Radius.circular(20.r),
  //                               topRight: Radius.circular(20.r),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             liveClassChatModel.user?.name ?? "Unknown",
  //                             style: setTextTheme(
  //                               fontSize: 12.sp,
  //                               fontWeight: FontWeight.w500,
  //                               color: blueShades[8],
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           decoration: BoxDecoration(
  //                               color: redShades[7],
  //                               borderRadius: BorderRadius.only(
  //                                 bottomLeft: Radius.circular(20.r),
  //                                 bottomRight: Radius.circular(20.r),
  //                               )),
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: 10.h, horizontal: 14.w),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.end,
  //                             children: [
  //                               Align(
  //                                 alignment: Alignment.centerLeft,
  //                                 child: Text(
  //                                   liveClassChatModel.message ?? "",
  //                                   style: setTextTheme(
  //                                     fontSize: 12.sp,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: blueShades[8],
  //                                   ),
  //                                 ),
  //                               ),
  //                               Align(
  //                                 alignment: Alignment.centerRight,
  //                                 child: Text(
  //                                   messageTime,
  //                                   style: setTextTheme(
  //                                     fontSize: 12.sp,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: blueShades[2],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //       ],
  //     ),
  //   );
  // }
// }
