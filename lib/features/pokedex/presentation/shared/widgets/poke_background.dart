import 'package:flutter/cupertino.dart';

class PokeBackground extends CustomPainter {
  final Color color;

  PokeBackground(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()..color = color;

    Path path = Path()
      ..relativeLineTo(0, 250)
      ..quadraticBezierTo(size.width / 2, 320.0, size.width, 250)
      ..relativeLineTo(0, -250)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
