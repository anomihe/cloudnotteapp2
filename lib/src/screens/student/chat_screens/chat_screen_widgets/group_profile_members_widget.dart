import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/user_profiles_model.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupProfileMembersWidget extends StatelessWidget {
  const GroupProfileMembersWidget({super.key, required this.userProfilesModel});

  final UserProfilesModel userProfilesModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 30.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage(userProfilesModel.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (userProfilesModel.isOnline == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfilesModel.name,
                  style: setTextTheme(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userProfilesModel.isAdmin ? 'admin' : 'member',
                  style: setTextTheme(
                    fontSize: 10.sp,
                    color: userProfilesModel.isAdmin
                        ? Colors.green
                        : ThemeProvider().isDarkMode
                            ? Colors.white
                            : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 10)
      ],
    );
  }
}
