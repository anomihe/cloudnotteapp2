/*
 * File: homework_container.dart
 * 
 * This file defines the `HomeworkContainer` widget, a reusable stateless component designed to display 
 * a confirmation or submission dialog for homework-related screens. It features a rich text description 
 * and two customizable buttons for primary and secondary actions.
 * 
 * Key Features:
 * - Accepts dynamic text content via `InlineSpan` for rich text formatting.
 * - Customizable buttons with configurable colors, text styles, and actions.
 * - Supports consistent layout and style across multiple screens.
 */

import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_button.dart';

// Container used for the homework ready screen and the homework submission screen
class HomeworkContainer extends StatelessWidget {
  const HomeworkContainer({
    super.key,
    required this.richText,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryButtonTap,
    required this.onSecondaryButtonTap,
    this.primaryButtonColor,
    this.secondaryButtonBorderColor,
    this.primaryButtonTextStyle,
    this.secondaryButtonTextStyle,
  });

  final InlineSpan richText; // The rich text to be displayed
  final String primaryButtonText; // The primary button's text
  final String secondaryButtonText; // The secondary button's text
  final VoidCallback onPrimaryButtonTap; // Action for the primary button
  final VoidCallback onSecondaryButtonTap; // Action for the secondary button
  final Color? primaryButtonColor; // Optional color for the primary button
  final Color?
      secondaryButtonBorderColor; // Optional border color for the secondary button
  final TextStyle?
      primaryButtonTextStyle; // Optional text style for the primary button
  final TextStyle?
      secondaryButtonTextStyle; // Optional text style for the secondary button

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 368.w,
      height: 291.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE7EEFF),
        ),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 29.w, right: 29.w, top: 60.h),
              child: RichText(
                text: richText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: onPrimaryButtonTap,
            child: CustomButton(
              buttonColor: primaryButtonColor ?? Colors.transparent,
              text: primaryButtonText,
              textStyle: primaryButtonTextStyle ??
                  TextStyle(
                    color: whiteShades[0],
                    fontSize: 15.48.sp,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          SizedBox(height: 7.h),
          GestureDetector(
            onTap: onSecondaryButtonTap,
            child: CustomButton(
              text: secondaryButtonText,
              borderColor: secondaryButtonBorderColor ?? Colors.transparent,
              textStyle: secondaryButtonTextStyle ??
                  TextStyle(
                    fontSize: 15.48.sp,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
