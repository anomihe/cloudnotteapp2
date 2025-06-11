import 'package:cloudnottapp2/src/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CallButton extends StatelessWidget {
  final void Function() onTap;
  final String svgIcon;
  final Color? boxColor;
  final Color? svgColor;
  final double? width;
  final double? height;

  const CallButton({
    super.key,
    required this.onTap,
    required this.svgIcon,
    this.boxColor,
    this.svgColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: width ?? screenSize.width * 0.13,
      height: height ?? screenSize.width * 0.13,
      decoration: BoxDecoration(
        color: boxColor ?? blueShades[1],
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100.r),
          onTap: onTap,
          splashColor: Colors.grey.withOpacity(0.3),
          child: Center(
            child: SvgPicture.asset(
              svgIcon,
              colorFilter:
                  ColorFilter.mode(svgColor ?? blueShades[2], BlendMode.srcIn),
              fit: BoxFit.none,
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleColorCallButton extends StatefulWidget {
  final void Function() onTap;
  final IconData svgIcon;
  final IconData svgIcon1;
  final Color? boxColor;
  final Color? svgColor;
  final double? width;
  final double? height;

  final bool isPressed;
  const ToggleColorCallButton({
    super.key,
    required this.onTap,
    required this.svgIcon,
    required this.svgIcon1,
    required this.isPressed,
    this.boxColor,
    this.width,
    this.height,
    this.svgColor,
  });

  @override
  _ToggleColorCallButtonState createState() => _ToggleColorCallButtonState();
}

class _ToggleColorCallButtonState extends State<ToggleColorCallButton> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // bool ispressed = false;
    return InkWell(
      // onTap: () {
      //   setState(() {
      //     ispressed = !ispressed;
      //   });

      //   widget.onTap();
      // },
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
          width: widget.width ?? screenSize.width * 0.13,
          height: widget.height ?? screenSize.width * 0.13,
          decoration: BoxDecoration(
            color: widget.isPressed
                ? (widget.boxColor ?? blueShades[1])
                : redShades[5],
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: widget.isPressed
              ? 
               Icon(
                  widget.svgIcon,
                  color: widget.isPressed
                      ? (widget.svgColor ?? blueShades[2])
                      : redShades[1],
                ) : Icon(
                  widget.svgIcon1,
                  color: widget.isPressed
                      ? (widget.svgColor ?? blueShades[2])
                      : redShades[1],
                )
          // SvgPicture.asset(
          //   widget.isPressed ? widget.svgIcon1 : widget.svgIcon,
          //   width: 10.w,
          //   height: 10.h,
          //   colorFilter: ColorFilter.mode(
          //     widget.isPressed
          //         ? redShades[1]
          //         : (widget.svgColor ?? blueShades[2]),
          //     BlendMode.srcIn,
          //   ),
          //   fit: BoxFit.none,
          // ),
          ),
    );
  }
}
