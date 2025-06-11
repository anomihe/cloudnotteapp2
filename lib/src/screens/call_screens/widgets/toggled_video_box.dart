import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggledVideoBox extends StatefulWidget {
  final double? height;
  final double? width;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxShadow? boxShadow;
  final String streamUrl;
  final String profilePicUrl;
  final bool isAudioMuted;
  final bool isVideoMuted;
  final bool? isOnToOne;
  const ToggledVideoBox({
    super.key,
    this.height,
    this.width,
    this.color,
    this.boxShadow,
    this.borderRadius,
    required this.streamUrl,
    required this.isAudioMuted,
    required this.isVideoMuted,
    required this.profilePicUrl,
    this.isOnToOne,
  });

  @override
  State<ToggledVideoBox> createState() => _ToggledVideoBoxState();
}

class _ToggledVideoBoxState extends State<ToggledVideoBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width ?? 120.w,
          height: widget.height ?? 150.h,
          decoration: widget.isVideoMuted
              ? BoxDecoration(
                  color: widget.color ?? blueShades[14],
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(
                        15.r,
                      ),
                )
              : BoxDecoration(
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(
                        15.r,
                      ),
                  image: DecorationImage(
                    image: AssetImage(widget.streamUrl),
                    fit: BoxFit.cover,
                  ),
                ),
          child: widget.isVideoMuted
              ? Center(
                  child: Container(
                    width: 70.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      image: DecorationImage(
                        image: AssetImage(
                          widget.profilePicUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : null,
        ),

        // show video muted icon if it is a one to one call
        if (widget.isAudioMuted && widget.isOnToOne == true) ...[
          Positioned(
            top: 10,
            left: 10,
            child: Icon(
              Icons.mic_off,
              color: redShades[0],
            ),
          ),
        ]
      ],
    );
  }
}
