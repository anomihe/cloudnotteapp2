import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/data/local/mockdata/user_profile_mockdata.dart';
import 'package:cloudnottapp2/src/data/models/user_profiles_model.dart';
import 'package:cloudnottapp2/src/screens/student/chat_screens/chat_screen_widgets/group_profile_members_widget.dart';
import 'package:cloudnottapp2/src/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';

class GroupChatProfileScreen extends StatefulWidget {
  static const String routeName = '/group_chat_profile';
  const GroupChatProfileScreen({super.key});

  @override
  State<GroupChatProfileScreen> createState() => _GroupChatProfileScreenState();
}

class _GroupChatProfileScreenState extends State<GroupChatProfileScreen> {
  final userProfilesModel = UserProfilesModel;
  bool showAllMembers = false;
  static const int initialDisplayCount = 5;
  int get onlineMembers =>
      mockMembersList.where((member) => member.isOnline).length;
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
                          image: AssetImage('assets/app/mock_person_image.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'JSS1 Group Chat',
                      style: setTextTheme(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${mockMembersList.length.toString()} members, $onlineMembers online',
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
                  container(
                    onTap: () {},
                    Icon(
                      Icons.search_rounded,
                      color: redShades[1],
                    ),
                    'Search',
                  ),
                  container(
                    onTap: () {},
                    Icon(
                      CupertinoIcons.person_badge_plus_fill,
                      color: redShades[1],
                    ),
                    'Add Members',
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
                  // border: Border.all(
                  //   width: 0.5,
                  //   color: ThemeProvider().isDarkMode
                  //       ? blueShades[10]
                  //       : whiteShades[3],
                  // ),
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
                  // border: Border.all(
                  //   width: 0.5,
                  //   color: ThemeProvider().isDarkMode
                  //       ? blueShades[10]
                  //       : whiteShades[3],
                  // ),
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: ThemeProvider().isDarkMode
                      ? blueShades[15]
                      : whiteShades[7],
                  borderRadius: BorderRadius.circular(12.r),
                  // border: Border.all(
                  //   width: 0.5,
                  //   color: ThemeProvider().isDarkMode
                  //       ? blueShades[10]
                  //       : whiteShades[3],
                  // ),
                ),
                child: Text(
                  'members (${mockMembersList.length.toString()})',
                  style: setTextTheme(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: showAllMembers
                        ? mockMembersList.length
                        : math.min(initialDisplayCount, mockMembersList.length),
                    itemBuilder: (context, index) {
                      return GroupProfileMembersWidget(
                          userProfilesModel: mockMembersList[index]);
                    },
                  ),
                  if (mockMembersList.length > initialDisplayCount)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllMembers = !showAllMembers;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            showAllMembers ? 'Show Less' : 'Show More',
                            style: setTextTheme(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Icon(
                            showAllMembers
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  appCustomDialog(
                      context: context,
                      title: 'Leave group?',
                      content: 'You are about to exit group',
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
                  'Leave group',
                  style: setTextTheme(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: redShades[1],
                  ),
                ),
              ),
              Divider(),
              Text(
                'Report group',
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

void showMediaBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => DefaultTabController(
      length: 3,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeProvider().isDarkMode
                    ? blueShades[15]
                    : whiteShades[7],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'Media',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Documents',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Links',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Media Grid
                  GridView.builder(
                    padding: EdgeInsets.all(16.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/app/mock_person_image.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),

                  // Documents List
                  ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.insert_drive_file),
                        title: Text(
                          'No documents',
                          style: setTextTheme(fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          'No files shared yet',
                          style: setTextTheme(
                            fontSize: 12.sp,
                            color: ThemeProvider().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),

                  // Links List
                  ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.link),
                        title: Text(
                          'No links',
                          style: setTextTheme(fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          'No links shared yet',
                          style: setTextTheme(
                            fontSize: 12.sp,
                            color: ThemeProvider().isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

container(Widget icon, String title, {required void Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 70.w,
      height: 38.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: ThemeProvider().isDarkMode ? blueShades[15] : whiteShades[7],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            title,
            style: setTextTheme(
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    ),
  );
}
