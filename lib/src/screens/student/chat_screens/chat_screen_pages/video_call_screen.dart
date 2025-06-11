import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  static const String routeName = '/video_call_screen';

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 500.h,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/app/teacher_image.png',
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    bottom: 18.h,
                    left: 18.w,
                    child: Image.asset(
                      'assets/app/student_image.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      width: 48.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: blueShades[12],
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Icon(Icons.keyboard_voice_outlined)),
                ),
                SizedBox(width: 15.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: blueShades[11],
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Icon(Icons.videocam_outlined)),
                ),
                SizedBox(width: 15.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: blueShades[11],
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/more_icon_flat.svg',
                      fit: BoxFit.none,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    width: 70.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: redShades[0],
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/call_icon_flat.svg',
                      fit: BoxFit.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}
