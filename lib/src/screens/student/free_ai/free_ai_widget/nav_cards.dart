/*
This file is a reusable widget for navigating the user from
the choose_school file to the learn_with_ai file
 */

import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learn_with_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NavCard extends StatefulWidget {
  const NavCard({
    super.key,
    this.isDefault = false,
  });
  final bool isDefault;

  @override
  State<NavCard> createState() => _NavCardState();
}

class _NavCardState extends State<NavCard> {
  bool _isHovered = false;
  bool _isTapped = false;
  onPress() {
    context.push(LearnWithAi.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        onTap: onPress,
        child: Container(
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _isTapped || _isHovered ? redShades[1] : whiteShades[1],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // School Logo
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.asset(
                      "assets/app/cloudnottapp2_logo_two.png",
                      fit: BoxFit.cover,
                      errorBuilder: (context, url, error) {
                        return Image.asset(
                          "assets/app/image.png",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // School Details
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AI Tutor",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Interact with document, audio and video",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
