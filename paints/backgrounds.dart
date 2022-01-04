import 'package:flutter/material.dart';

class WPG extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shape2 = Path()
      ..moveTo(0, size.height * .5)
      ..quadraticBezierTo(
          size.width * .05, size.height * .85, size.width * .95, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height * .5);

    final paint2 = Paint()
      ..color = Colors.cyan[600]
      ..style = PaintingStyle.fill;

    canvas.drawPath(shape2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DBG extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shape1 = Path()
      ..moveTo(size.width * .1, size.height)
      ..lineTo(size.width * .65, size.height * .85)
      ..lineTo(size.width, size.height * .9)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * .3, size.height);

    final paint2 = Paint()
      ..color = Colors.cyan[600]
      ..style = PaintingStyle.fill;

    canvas.drawPath(shape1, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LPG extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shape1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * .9)
      ..lineTo(size.width * .65, size.height)
      ..lineTo(0, size.height);

    final shape3 = Path()
      ..moveTo(size.width * .15, 0)
      ..quadraticBezierTo(
          size.width * .8, size.height * .15, size.width, size.height * .4)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * .15, 0);

    final paint2 = Paint()
      ..color = Colors.cyan[600]
      ..style = PaintingStyle.fill;

    canvas.drawPath(shape1, paint2);

    canvas.drawPath(shape3, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
