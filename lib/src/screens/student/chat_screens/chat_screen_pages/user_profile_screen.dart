import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/user_profile_mockdata.dart';
import 'package:cloudnottapp2/src/data/models/user_chat_model.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_pages/group_chat_profile_screen.dart';
import 'package:cloudnottapp2/src/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = '/user_profile';
  const UserProfileScreen({super.key, required this.userChatModel});

  final UserChatModel userChatModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: customAppBarLeadingIcon(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 25.r,
            vertical: 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 71.r,
                      height: 71.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: AssetImage(userChatModel.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      userChatModel.title,
                      style: setTextTheme(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'username',
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  container(
                    onTap: () {},
                    Icon(
                      CupertinoIcons.chat_bubble_text,
                      color: redShades[1],
                    ),
                    'Message',
                  ),
                  container(
                    onTap: () {},
                    Icon(
                      CupertinoIcons.phone_fill,
                      size: 20,
                      color: redShades[1],
                    ),
                    'Audio',
                  ),
                  container(
                    onTap: () {},
                    Icon(
                      Icons.videocam_outlined,
                      color: redShades[1],
                    ),
                    'Video',
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.r,
                  vertical: 15.r,
                ),
                decoration: BoxDecoration(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : whiteShades[7],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description ',
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'How does the earth rotate round an orbit? and trying to figure it out seems different from your slide presentation ',
                      style: setTextTheme(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : whiteShades[7],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: GestureDetector(
                  onTap: () {
                    showMediaBottomSheet(context);
                  },
                  child: Material(
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/gallery_icon.svg'),
                        SizedBox(width: 10.w),
                        Text(
                          'Media, links and docs',
                          style: setTextTheme(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded, size: 20)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () {
                  appCustomDialog(
                      context: context,
                      title: 'Leave group?',
                      // content: 'You are about to exit group',
                      action1: 'exit',
                      action2: 'cancel',
                      action1Function: () {
                        // add leave group logic
                        context.pop();
                      },
                      action2Function: () {
                        context.pop();
                      });
                },
                child: Text(
                  'Block ${userChatModel.title}',
                  style: setTextTheme(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: redShades[1],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Divider(),
              Text(
                'Report ${userChatModel.title}',
                style: setTextTheme(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: redShades[1],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
