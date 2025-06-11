import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/themes.dart';

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.text,
    required this.onTap,
    required this.isLoading,
    this.enabled = true,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.width,
    this.height,
    this.border,
    this.boxColor,
    this.progressColor,
    this.borderRadius,
    this.prefixIcon,
  });

  final Function() onTap;
  final bool isLoading;
  final bool enabled;
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final Border? border;
  final Color? boxColor;
  final Color? progressColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20.r),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: !isLoading && enabled ? onTap : null,
          child: Container(
            height: height ?? 40.h,
            width: width ?? double.infinity,
            decoration: BoxDecoration(
              color: enabled ? boxColor ?? blueShades[0] : Colors.grey[300],
              borderRadius: borderRadius ?? BorderRadius.circular(20.r),
              border: border,
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      child: CircularProgressIndicator(
                        color: progressColor ?? Colors.white,
                      ),
                    ),
                  if (!isLoading)
                    prefixIcon != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              prefixIcon!,
                              SizedBox(width: 8.w),
                              Text(
                                text,
                                style: setTextTheme(
                                  color: textColor ?? Colors.white,
                                  fontSize: fontSize ?? 16.sp,
                                  fontWeight: fontWeight ?? FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            text,
                            style: setTextTheme(
                              color: textColor ?? Colors.white,
                              fontSize: fontSize ?? 16.sp,
                              fontWeight: fontWeight ?? FontWeight.w500,
                            ),
                          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class Buttons extends StatelessWidget {
//   const Buttons({
//     super.key,
//     required this.text,
//     required this.onTap,
//     required this.isLoading,
//     this.enabled = true,
//     this.textColor,
//     this.fontSize,
//     this.fontWeight,
//     this.width,
//     this.height,
//     this.border,
//     this.boxColor,
//     this.progressColor,
//     this.borderRadius,
//     this.prefixIcon,
//   });

//   final Function() onTap;
//   final bool isLoading;
//   final bool enabled;
//   final String text;
//   final Color? textColor;
//   final double? fontSize;
//   final FontWeight? fontWeight;
//   final double? width;
//   final double? height;
//   final Border? border;
//   final Color? boxColor;
//   final Color? progressColor;
//   final BorderRadiusGeometry? borderRadius;
//   final Widget? prefixIcon;

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: borderRadius ?? BorderRadius.circular(20.r),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: !isLoading && enabled ? onTap : null,
//           child: Container(
//             height: height ?? 40.h,
//             width: width ?? double.infinity,
//             decoration: BoxDecoration(
//               color: enabled ? boxColor ?? redShades[1] : whiteShades[3],
//               borderRadius: borderRadius ?? BorderRadius.circular(20.r),
//               border: border,
//             ),
//             child: Center(
//               child: Stack(
//                 children: [
//                   if (isLoading)
//                     SizedBox(
//                       child: CircularProgressIndicator(
//                         color: progressColor ?? whiteShades[0],
//                       ),
//                     ),
//                   if (!isLoading && prefixIcon == null)
//                     Text(
//                       text,
//                       style: setTextTheme(
//                           color: textColor ?? whiteShades[0],
//                           fontSize: fontSize ?? 16.sp,
//                           fontWeight: fontWeight ?? FontWeight.w500),
//                     )
//                   else
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         prefixIcon!,
//                         SizedBox(width: 8.w),
//                         Text(
//                           text,
//                           style: setTextTheme(
//                               color: textColor ?? whiteShades[0],
//                               fontSize: fontSize ?? 16.sp,
//                               fontWeight: fontWeight ?? FontWeight.w500),
//                         ),
//                       ],
//                     )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
