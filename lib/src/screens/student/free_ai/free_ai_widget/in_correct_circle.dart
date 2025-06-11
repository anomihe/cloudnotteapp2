import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InCorrectCircle extends StatelessWidget {
  const InCorrectCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: freeAiColors[3],
        border: Border.all(color: freeAiColors[4], width: 1),
      ),
      child: CustomPaint(
        painter: XMarkPainter(),
      ),
    );
  }
}

// Painter for X Mark
class XMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = freeAiColors[4]
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw first diagonal (top-left to bottom-right)
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.75),
      paint,
    );

    // Draw second diagonal (top-right to bottom-left)
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width * 0.25, size.height * 0.75),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
