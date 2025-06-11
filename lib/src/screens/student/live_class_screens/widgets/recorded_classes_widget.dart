import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:cloudnottapp2/src/data/models/recorded_class_model.dart';
import 'package:cloudnottapp2/src/data/models/user_model.dart' show ClassRecording;
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecordedClassesWidget extends StatefulWidget {
  const RecordedClassesWidget({
    super.key,
    required this.recordedClassModel,
   required this.recordedClassModelTwo,
    this.onPress,
  });
final ClassRecording recordedClassModelTwo;
  final RecordedClassModel recordedClassModel;
  final Function()? onPress;

  @override
  State<RecordedClassesWidget> createState() => _RecordedClassesWidgetState();
}

class _RecordedClassesWidgetState extends State<RecordedClassesWidget> {
  bool _isHovered = false;
  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isTapped = true),
            onTapUp: (_) => setState(() => _isTapped = false),
            onTapCancel: () => setState(() => _isTapped = false),
            onTap: widget.onPress,
            child: Container(
              height: 120.h,
              width: 361.w,
              decoration: BoxDecoration(
                color: _isTapped || _isHovered
                    ? redShades[1]
                    : ThemeProvider().isDarkMode
                        ? blueShades[15]
                        : redShades[7],
                borderRadius: BorderRadius.circular(40.r),
                border: Border.all(
                  color: _isTapped || _isHovered
                      ? redShades[1]
                      : ThemeProvider().isDarkMode
                          ? blueShades[2]
                          : blueShades[4],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10.h,
                    right: 18.w,
                    child: SvgPicture.asset(
                      'assets/icons/time_sand_icon.svg',
                      colorFilter: ColorFilter.mode(
                        Color.fromARGB(255, 212, 211, 211),
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.none,
                    ),
                  ),
                  Positioned(
                    right: 18.w,
                    bottom: 10.h,
                    child: Container(
                      width: 68.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: _isTapped || _isHovered
                            ? Colors.white
                            : ThemeProvider().isDarkMode
                                ? blueShades[8]
                                : Colors.white,
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: _isTapped || _isHovered
                              ? Colors.white
                              : ThemeProvider().isDarkMode
                                  ? blueShades[2]
                                  : blueShades[4],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.recordedClassModel.duration,
                          style: setTextTheme(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: _isTapped || _isHovered
                                ? Colors.black
                                : ThemeProvider().isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.r, left: 10.w, right: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5.h,
                          ),
                          child: Container(
                            width: 46.w,
                            height: 41.h,
                            decoration: BoxDecoration(
                              color: redShades[1],
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/live_class_icon.svg',
                              fit: BoxFit.none,
                              // colorFilter: ColorFilter.mode(
                              //   ThemeProvider().isDarkMode
                              //       ? Colors.white
                              //       : redShades[1],
                              //   BlendMode.srcIn,
                              // ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        // Text Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.recordedClassModel.question,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: setTextTheme(
                                  fontSize: 25.sp,
                                  color: _isTapped || _isHovered
                                      ? Colors.white
                                      : ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  lineHeight: 1,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                widget.recordedClassModelTwo.timeRecorded??'',
                                style: setTextTheme(
                                  fontSize: 12.sp,
                                  color: _isTapped || _isHovered
                                      ? Colors.white
                                      : ThemeProvider().isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Container(
                                    width: 27.w,
                                    height: 27.w,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      image: DecorationImage(
                                        image: AssetImage(widget
                                            .recordedClassModel.teacherImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    widget.recordedClassModel.teacherName,
                                    style: setTextTheme(
                                      fontSize: 12.sp,
                                      color: _isTapped || _isHovered
                                          ? Colors.white
                                          : ThemeProvider().isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
        SizedBox(height: 10.h)
      ],
    );
  }
}
