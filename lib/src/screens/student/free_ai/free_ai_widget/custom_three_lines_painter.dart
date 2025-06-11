import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';

/*
This widget is used as an icon for leading microsoft word in the listtile of the drawer
*/

class CustomThreeLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeProvider().isDarkMode ? redShades[1] : Colors.black
      ..strokeWidth = 2.0;

    canvas.drawLine(const Offset(0, 0), const Offset(13, 0), paint);

    canvas.drawLine(const Offset(0, 5), const Offset(17, 5), paint);

    canvas.drawLine(const Offset(0, 10), const Offset(10, 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
