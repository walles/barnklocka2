import 'dart:math';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  final int _hours;
  final int _minutes;

  const Clock(int hours, int minutes, {Key? key})
      : _hours = hours,
        _minutes = minutes,
        super(key: key);

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
      child:
          CustomPaint(painter: _ClockPainter(widget._hours, widget._minutes)),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final int _hours;
  final int _minutes;

  _ClockPainter(int hours, int minutes)
      : _hours = hours,
        _minutes = minutes;

  @override
  void paint(Canvas canvas, Size size) {
    // We should be inside an AspectRatio(1.0) widget
    assert((size.width - size.height) < 1.0, '${size.width} vs ${size.height}');

    _paintClockFaceBackground(canvas, size.width);
    _paintNumbers(canvas, size.width);

    _paintHourHand(canvas, size.width);
    _paintMinuteHand(canvas, size.width);

    _paintMinuteTicks(canvas, size.width);
    _paintHourTicks(canvas, size.width);
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

  void _paintHand(Canvas canvas, double diameter, double rotationFraction,
      double widthFraction, double lengthFraction) {
    const fullRotation = pi * 2;
    final rotation = fullRotation * rotationFraction;

    final radius = diameter / 2;
    final width = radius * widthFraction;
    final length = radius * lengthFraction;
    final backExtent = radius * .1;

    final paint = Paint();
    paint.strokeWidth = width;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    canvas.save();
    try {
      canvas.translate(radius, radius);
      canvas.rotate(rotation);
      canvas.drawLine(Offset(0, backExtent), Offset(0, -length), paint);
    } finally {
      canvas.restore();
    }
  }

  void _paintHourHand(Canvas canvas, double diameter) {
    final rotationFraction = (_hours / 12.0) + (_minutes / (12 * 60));
    const widthFraction = .1;
    const lengthFraction = .65;
    _paintHand(
        canvas, diameter, rotationFraction, widthFraction, lengthFraction);
  }

  void _paintMinuteHand(Canvas canvas, double diameter) {
    final rotationFraction = _minutes / 60;
    const widthFraction = .05;
    const lengthFraction = .9;
    _paintHand(
        canvas, diameter, rotationFraction, widthFraction, lengthFraction);
  }

  void _paintTicks(Canvas canvas, double diameter, int count,
      double lengthFactor, double widthFactor) {
    final radius = diameter / 2;
    final length = radius * lengthFactor;
    final width = radius * widthFactor;

    final paint = Paint();
    paint.strokeWidth = width;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    const fullRotation = pi * 2;

    canvas.save();
    try {
      canvas.translate(radius, radius);
      for (int i = 0; i < count; i++) {
        final rotationFraction = i / count;
        final rotation = fullRotation * rotationFraction;

        final outerRadius = radius - length * .5;
        final innerRadius = radius - length * 1.5;

        final inner =
            Offset(innerRadius * sin(rotation), innerRadius * cos(rotation));
        final outer =
            Offset(outerRadius * sin(rotation), outerRadius * cos(rotation));

        canvas.drawLine(inner, outer, paint);
      }
    } finally {
      canvas.restore();
    }
  }

  void _paintMinuteTicks(Canvas canvas, double diameter) {
    _paintTicks(canvas, diameter, 60, .05, .01);
  }

  void _paintHourTicks(Canvas canvas, double diameter) {
    _paintTicks(canvas, diameter, 12, .05, .03);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // FIXME: How do we know?
    return false;
  }
}
