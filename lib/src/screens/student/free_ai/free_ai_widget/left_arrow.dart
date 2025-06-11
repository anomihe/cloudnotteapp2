import 'package:flutter/material.dart';

class LeftArrow extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const LeftArrow({
    super.key,
    this.width = 30,
    this.height = 30,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: LeftArrowPainter(color: color),
      ),
    );
  }
}

class LeftArrowPainter extends CustomPainter {
  final Color color;

  LeftArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.2) // Start at top center
      ..lineTo(size.width * 0.5, size.height * 0.6) // Draw down
      ..lineTo(
          size.width * 0.3, size.height * 0.8) // Move slightly left and down
      ..lineTo(size.width * 0.2, size.height * 0.8) // Extend left
      ..lineTo(size.width * 0.35, size.height * 0.65) // Arrowhead up
      ..moveTo(size.width * 0.2, size.height * 0.8) // Back to tip
      ..lineTo(size.width * 0.35, size.height * 0.95); // Arrowhead down

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
