import 'dart:io';

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/auth_provider.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:cloudnottapp2/src/screens/app_screens/support_screen.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/choose_school.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/account_summary.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/change_password_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/join_space_request_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/link_user_account_screen.dart';
import 'package:cloudnottapp2/src/screens/student/profile_screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/user_provider.dart';
import '../../../utils/alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final UserProvider value;

  const ProfileScreen({super.key, required this.value});
  static const routeName = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _toTitleCase(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String? role;
  @override
  void initState() {
    super.initState();
    role =
        localStore.get('role', defaultValue: context.read<UserProvider>().role);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Size
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 77.r,
                      height: 77.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: widget.value.user?.profileImageUrl != null &&
                                  widget.value.user!.profileImageUrl!.isNotEmpty
                              ? NetworkImage(
                                  widget.value.user!.profileImageUrl ?? "")
                              : AssetImage('assets/app/profile_picture1.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: widget.value.user?.profileImageUrl ==
                                      null ||
                                  widget.value.user!.profileImageUrl!.isEmpty
                              ? ColorFilter.mode(redShades[1], BlendMode.srcIn)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Flexible(
                      child: Text(
                        '${widget.value.user?.firstName} ${widget.value.user?.lastName}',
                        style: setTextTheme(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${widget.value.user?.username}',
                      style: setTextTheme(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   spacing: 5,
                    //   children: [
                    //     Text(
                    //       'Role:',
                    //       style: setTextTheme(
                    //         fontSize: 16.sp,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //     Text('$role')
                    //   ],
                    // ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Current space',
                      style: setTextTheme(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(ChooseSchool.routeName);
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: ThemeProvider().isDarkMode
                                  ? blueShades[21]
                                  : blueShades[18],
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 5.h,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.value.currentSpace,
                                  style: setTextTheme(
                                    // fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              SvgPicture.asset(
                                'assets/icons/arrow_right.svg',
                                colorFilter: ColorFilter.mode(
                                  redShades[1],
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _containerBuild(
                      children: [
                        if (role != 'teacher')
                          _containerRows(
                            () {
                              context.push(AccountSummaryScreen.routeName);
                            },
                            'assets/icons/summary_icon.svg',
                            'Account Summary',
                            isDivider: true,
                          ),
                        // _containerRows(() {
                        //   context.push(NotificationScreen.routeName);
                        // }, 'assets/icons/notifications_icon.svg', 'Notifications',
                        //     isDivider: true, numBadge: true, badgeCount: '17'),
                        _containerRows(
                          () {
                            context.push(LiveChatScreen.routeName);
                          },
                          'assets/icons/support_icon.svg',
                          'Support',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _containerBuild(
                      title: 'Spaces',
                      children: [
                        _containerRows(
                          () {
                            Provider.of<UserProvider>(context, listen: false)
                                .setAlias('');
                            localStore.delete('role');
                            context.push(ChooseSchool.routeName);
                          },
                          'assets/icons/spaces_icon.svg',
                          'My spaces',
                          isDivider: true,
                          numBadge: true,
                          badgeCount: '${widget.value.space.length}',
                        ),
                        _containerRows(
                          () {
                            context.push(LinkUserAccountScreen.routeName);
                          },
                          'assets/icons/link_icon.svg',
                          'Link user account',
                          isDivider: true,
                        ),
                        _containerRows(
                          () {
                            context.push(JoinSpaceRequestScreen.routeName);
                          },
                          'assets/icons/space_request_icon.svg',
                          'Join space request',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _containerBuild(
                      title: 'Preferences',
                      children: [
                        _containerRows(
                          () {
                            context.push(ChangePasswordScreen.routeName);
                          },
                          'assets/icons/settings_icon.svg',
                          'Change password',
                          isDivider: true,
                        ),
                        _containerRows(
                          () {},
                          'assets/icons/theme_icon.svg',
                          'Dark mode',
                          isDivider: true,
                          trailing: SizedBox(
                            height: 24,
                            child: Transform.scale(
                              scale: 0.9,
                              child: Switch(
                                value: themeProvider.isDarkMode,
                                inactiveThumbColor: Colors.grey[600],
                                trackOutlineColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                onChanged: (value) {
                                  themeProvider.toggleTheme(value);
                                },
                              ),
                            ),
                          ),
                        ),
                        if(Platform.isIOS)
                         _containerRows(
                          () {
                            appCustomDialog(
                              context: context,
                              title: "Delete Account",
                              content: 'Are you sure you want to delete your account',
                             
                              action1: "No",
                              action2: "Yes",
                              action1Function: () {
                                context.pop();
                              },
                              action2Function: () {
                                if (mounted) {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logOut(context);
                                }
                              },
                            );
                          },
                          'assets/icons/space_request_icon.svg',
                          'Delete Account',
                          isTrailing: false,
                           isDivider: true,
                          textColor: redShades[0],
                        ),
                        _containerRows(
                          () {
                            appCustomDialog(
                              context: context,
                              title: "Log Out",
                              content: 'Are you sure you want to log out',
                              action1: "No",
                              action2: "Yes",
                              action1Function: () {
                                context.pop();
                              },
                              action2Function: () {
                                if (mounted) {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logOut(context);
                                }
                              },
                            );
                          },
                          'assets/icons/space_request_icon.svg',
                          'Logout',
                          isTrailing: false,
                          textColor: redShades[1],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 40,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.r, vertical: 3.r),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: redShades[1],
                      ),
                      top: BorderSide(
                        color: redShades[1],
                      ),
                      bottom: BorderSide(
                        color: redShades[1],
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                  child: Text(
                    _toTitleCase(role!),
                    style: setTextTheme(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: redShades[1],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _containerRows(
  void Function() ontTap,
  String leadingIcon,
  String rowText, {
  bool? isDivider,
  Color? textColor,
  bool? isTrailing,
  Widget? trailing,
  ColorFilter? leadingColor,
  bool? numBadge,
  String? badgeCount,
}) {
  return Column(
    children: [
      GestureDetector(
        onTap: ontTap,
        child: Material(
          child: Row(
            spacing: 10.w,
            children: [
              SvgPicture.asset(
                leadingIcon,
                width: 20.r,
                height: 20.r,
                colorFilter: leadingColor ??
                    ColorFilter.mode(redShades[1], BlendMode.srcIn),
                fit: BoxFit.cover,
              ),
              Text(
                rowText,
                style: setTextTheme(
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
              if (numBadge == true)
                CircleAvatar(
                  backgroundColor: redShades[1],
                  radius: 12,
                  child: Center(
                    child: Text(
                      badgeCount ?? '',
                      style: setTextTheme(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              Spacer(),
              if (isTrailing == false)
                SizedBox.shrink()
              else if (trailing == null)
                SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  colorFilter: ColorFilter.mode(
                    ThemeProvider().isDarkMode ? redShades[1] : Colors.black,
                    BlendMode.srcIn,
                  ),
                )
              else
                trailing,
            ],
          ),
        ),
      ),
      if (isDivider == true) Divider(),
    ],
  );
}

Widget _containerBuild({String? title, List<Widget> children = const []}) {
  return Column(
    children: [
      if (title != null)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: setTextTheme(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: whiteShades[3],
              ),
            ),
          ),
        ),
      if (title != null)
        SizedBox(
          height: 5.h,
        ),
      Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: ThemeProvider().isDarkMode ? blueShades[21] : blueShades[18],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: children,
          ),
        ),
      ),
    ],
  );
}
