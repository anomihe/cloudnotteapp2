import 'package:cloudnottapp2/src/components/global_widgets/appbar_leading.dart';
import 'package:cloudnottapp2/src/components/shared_widget/general_button.dart';
import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: setTextTheme(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: customAppBarLeadingIcon(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last 7 days',
              style: setTextTheme(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _notificationWidget(
              ontTap: () {},
              imageUrl: 'assets/app/student_image.png',
              title: '2024/2025 - 1st Term',
              subtitle: 'result is now available',
              time: '14:00',
              isDivider: true,
            ),
          ],
        ),
      ),
    );
  }
}

_notificationWidget({
  required void Function() ontTap,
  required String imageUrl,
  required String title,
  required String subtitle,
  required String time,
  required bool? isDivider,
}) {
  return Row(
    children: [
      CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
      ),
      SizedBox(
        width: 10.w,
      ),
      Expanded(
        child: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: setTextTheme(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' $subtitle',
                style: setTextTheme(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 5.w),
      Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              time,
              style: setTextTheme(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Buttons(
              width: 38.w,
              height: 12.h,
              text: 'view',
              fontSize: 8.sp,
              onTap: ontTap,
              isLoading: false,
            )
          ],
        ),
      )
    ],
  );
}
