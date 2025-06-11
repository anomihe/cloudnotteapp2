import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/group_chat_profile_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/group_chatting_screen.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/user_chatting_page.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class UserChatInitialDisplay extends StatelessWidget {
  const UserChatInitialDisplay({super.key, required this.userChatModel});

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
                userChatModel.isGroupChat == true
                    ? context.push(GroupChatProfileScreen.routeName,
                        extra: userChatModel)
                    : context.push(UserProfileScreen.routeName,
                        extra: userChatModel);
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
                  userChatModel.isGroupChat == true
                      ? context.push(GroupChattingPage.routeName,
                          extra: userChatModel)
                      : context.push(UserChattingPage.routeName,
                          extra: userChatModel);
                },
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    userChatModel.title,
                                    style: setTextTheme(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                if (userChatModel.isVerified == true)
                                  SvgPicture.asset(
                                      'assets/icons/verified_icon.svg')
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              userChatModel.text,
                              style: setTextTheme(fontSize: 12.sp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            userChatModel.formatDateTime,
                            style: setTextTheme(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
            // SizedBox(width: 8.w),
          ],
        ),
        Divider(),
      ],
    );
  }
}

// import 'package:cloudnottapp2/src/config/config.dart';
// import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
// import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/group_chat_profile_screen.dart';
// import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/group_chatting_screen.dart';
// import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/user_chatting_page.dart';
// import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/user_profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';

// class UserChatInitialDisplay extends StatelessWidget {
//   const UserChatInitialDisplay({super.key, required this.userChatModel});

//   final UserChatModel userChatModel;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 userChatModel.isGroupChat == true
//                     ? context.push(GroupChatProfileScreen.routeName,
//                         extra: userChatModel)
//                     : context.push(UserProfileScreen.routeName,
//                         extra: userChatModel);
//               },
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     child: Image.asset(userChatModel.image),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 10,
//                       height: 10,
//                       decoration: BoxDecoration(
//                         color: userChatModel.isOnline == true
//                             ? Colors.green
//                             : Colors.yellow,
//                         borderRadius: BorderRadius.circular(100),
//                         border: Border.all(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(width: 8.w),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   userChatModel.isGroupChat == true
//                       ? context.push(GroupChattingPage.routeName,
//                           extra: userChatModel)
//                       : context.push(UserChattingPage.routeName,
//                           extra: userChatModel);
//                 },
//                 child: Material(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 userChatModel.title,
//                                 style: setTextTheme(),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               if (userChatModel.isVerified == true)
//                                 SvgPicture.asset(
//                                     'assets/icons/verified_icon.svg')
//                             ],
//                           ),
//                           Text(
//                             userChatModel.text,
//                             style: setTextTheme(
//                               fontSize: 12.sp,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                       Spacer(),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             userChatModel.formatDateTime,
//                             style: setTextTheme(
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           // notification counter here
//                           if (userChatModel.notificationCount > 0)
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundColor: redShades[1],
//                                   radius: 6.5.r,
//                                   child: Center(
//                                     child: Text(
//                                       userChatModel.notificationCount
//                                           .toString(),
//                                       style: setTextTheme(
//                                         fontSize: 8.sp,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 // SizedBox(width: 7.w)
//                               ],
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
