import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CopyFeedbackPosition {
  left,
  right,
  above,
  below,
  toast,
}

class CopyableText extends StatefulWidget {
  final String label;
  final String value;
  final String? feedbackText;
  final bool? shouldCopy;
  final bool? spaced;
  final CopyFeedbackPosition feedbackPosition;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final TextStyle? feedbackTextStyle;
  final double? spaceWidth;

  const CopyableText({
    super.key,
    required this.label,
    required this.value,
    this.feedbackText,
    this.shouldCopy,
    this.spaced,
    this.feedbackPosition = CopyFeedbackPosition.right,
    this.labelTextStyle,
    this.valueTextStyle,
    this.feedbackTextStyle,
    this.spaceWidth,
  });

  @override
  State<CopyableText> createState() => _CopyableTextState();
}

class _CopyableTextState extends State<CopyableText> {
  bool _showCopied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.value));
    setState(() => _showCopied = true);

    if (widget.feedbackPosition == CopyFeedbackPosition.toast) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showCopied = false);
    });
  }

  Widget _buildCopyFeedback() {
    return AnimatedOpacity(
      opacity: _showCopied ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        width: 50.w,
        child: Text(
          widget.feedbackText ?? 'Copied!',
          style: widget.feedbackTextStyle ??
              setTextTheme(
                fontSize: 10.sp,
                color: blueShades[0],
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.feedbackPosition == CopyFeedbackPosition.above ||
        widget.feedbackPosition == CopyFeedbackPosition.below) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.feedbackPosition == CopyFeedbackPosition.above) ...[
            _buildCopyFeedback(),
            SizedBox(height: 4.h),
          ],
          _buildMainRow(),
          if (widget.feedbackPosition == CopyFeedbackPosition.below) ...[
            SizedBox(height: 4.h),
            _buildCopyFeedback(),
          ],
        ],
      );
    }

    return _buildMainRow();
  }

  Widget _buildMainRow() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${widget.label}:  ',
          style: widget.labelTextStyle ??
              setTextTheme(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
        ),
        widget.spaced == true
            ? Spacer()
            : (widget.spaceWidth != null
                ? SizedBox(width: widget.spaceWidth)
                : SizedBox.shrink()),
        if (widget.feedbackPosition == CopyFeedbackPosition.left &&
            widget.shouldCopy!) ...[
          _buildCopyFeedback(),
          SizedBox(width: 4.w),
        ],
        Flexible(
          child: Text(
            widget.value,
            // overflow: TextOverflow.ellipsis,
            // maxLines: 1,
            style: widget.valueTextStyle ??
                setTextTheme(
                  fontSize: 14,
                  color: whiteShades[4],
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        if (widget.shouldCopy == true) ...[
          SizedBox(width: 7.w),
          InkWell(
            onTap: _copyToClipboard,
            child: Icon(
              Icons.copy_rounded,
              size: 16.r,
              color: blueShades[0],
            ),
          ),
          if (widget.feedbackPosition == CopyFeedbackPosition.right) ...[
            SizedBox(width: 2.w),
            _buildCopyFeedback(),
          ],
        ],
      ],
    );
  }
}
