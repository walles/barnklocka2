import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Clock();
  }
}

class _Clock extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(painter: _ClockPainter()),
    );
  }
}

class _ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // We should be inside an AspectRatio(1.0) widget
    assert(size.width == size.height);

    // FIXME: Maybe drop one or both of these lines?
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.drawColor(Colors.green, BlendMode.src);

    _paintClockFaceBackground(canvas, size.width);
    _paintNumbers(canvas, size.width);

    // FIXME: Draw hour hand
    // FIXME: Draw minute hand
    // FIXME: Draw some ticks? Find a reference image!
  }

  void _paintClockFaceBackground(Canvas canvas, double diameter) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(diameter / 2, diameter / 2), diameter / 2, paint);
  }

  void _paintNumbers(Canvas canvas, double diameter) {
    final radius = diameter / 2;
    final numberPlacementRadius = radius * .8;

    final style = TextStyle(
      color: Colors.black,
      fontSize: radius * .2,
    );

    const fullRotation = pi * 2;
    for (int number = 1; number <= 12; number++) {
      final rotation = fullRotation * -number / 12;
      final x = radius - numberPlacementRadius * sin(rotation);
      final y = radius - numberPlacementRadius * cos(rotation);

      final textSpan = TextSpan(
        text: number.toString(),
        style: style,
      );
      final painter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      painter.layout(
        minWidth: 0,
        maxWidth: diameter,
      );
      painter.paint(
          canvas, Offset(x - painter.width / 2, y - painter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // FIXME: How do we know?
    return false;
  }
}
