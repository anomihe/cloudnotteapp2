import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CorrectCircle extends StatelessWidget {
  const CorrectCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: freeAiColors[1],
        border: Border.all(color: freeAiColors[2], width: 1),
      ),
      child: CustomPaint(
        painter: CheckmarkPainter(),
      ),
    );
  }
}

// Painter for Checkmark
class CheckmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = freeAiColors[2]
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.55) // Start point
      ..lineTo(size.width * 0.45, size.height * 0.75) // Bottom of check
      ..lineTo(size.width * 0.75, size.height * 0.25); // Top-right of check

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// // Painter for X Mark
// class XMarkPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     // Draw first diagonal (top-left to bottom-right)
//     canvas.drawLine(
//       Offset(size.width * 0.25, size.height * 0.25),
//       Offset(size.width * 0.75, size.height * 0.75),
//       paint,
//     );

//     // Draw second diagonal (top-right to bottom-left)
//     canvas.drawLine(
//       Offset(size.width * 0.75, size.height * 0.25),
//       Offset(size.width * 0.25, size.height * 0.75),
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
