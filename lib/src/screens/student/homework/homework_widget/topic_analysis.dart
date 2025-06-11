import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicAnalysis extends StatelessWidget {
  const TopicAnalysis(
      {super.key, required this.part, required this.percentage});

  final String part;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              part,
              style: setTextTheme(fontWeight: FontWeight.w800, fontSize: 18.sp),
            ),
            const Spacer(),
            Text(
              percentage,
              style: setTextTheme(fontSize: 20.sp),
            ),
          ],
        ),
        SizedBox(height: 2.h), // Add some spacing
        ResponsiveLine(
            percentage: double.parse(percentage.replaceAll('%', ''))),
        SizedBox(
          height: 15.h,
        ),
      ],
    );
  }
}

class ResponsiveLine extends StatelessWidget {
  final double percentage;

  const ResponsiveLine({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 9.h, // Line height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: CustomPaint(
          painter: LinePainter(percentage: percentage),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double percentage;

  LinePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    // Determine the color based on the percentage
    Color lineColor;
    if (percentage < 50) {
      lineColor = redShades[0]; // Red for 0–49%
    } else if (percentage <= 70) {
      lineColor = goldenShades[0]; // Yellow for 50–70%
    } else {
      lineColor = greenShades[0]; // Green for 71–100%
    }

    // Create the Paint object with the selected color
    final coloredPaint = Paint()
      ..color = lineColor
      ..strokeWidth = size.height
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = whiteShades[1]
      ..strokeWidth = size.height
      ..style = PaintingStyle.fill;

    // Calculate the width of the colored and white sections
    final coloredWidth = (size.width * (percentage / 100));
    final whiteWidth = size.width - coloredWidth;

    // Draw the colored section
    canvas.drawRect(
      Rect.fromLTWH(0, 0, coloredWidth, size.height),
      coloredPaint,
    );

    // Draw the white section
    canvas.drawRect(
      Rect.fromLTWH(coloredWidth, 0, whiteWidth, size.height),
      whitePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
