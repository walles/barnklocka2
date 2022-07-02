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

    // Draw clock face background
    final backdropPaint = Paint();
    backdropPaint.color = Colors.white;
    backdropPaint.style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, backdropPaint);

    // FIXME: Draw numbers

    // FIXME: Draw hour hand

    // FIXME: Draw minute hand

    // FIXME: Draw some ticks? Find a reference image!
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // FIXME: How do we know?
    return false;
  }
}
