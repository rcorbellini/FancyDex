import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PokeBarStats extends AnimatedWidget {
  final Map<String, int> stats;

  PokeBarStats({Key key, Animation<double> animation, this.stats})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return CustomPaint(
      painter: PokeBarStatsPainter(stats, animation.value),
      child: Container(
        width: 350,
        height: 150,
      ),
    );
  }
}

class PokeBarStatsPainter extends CustomPainter {
  final Map<String, int> data;
  // Currently based on the length of the category names
  double marginTopX = 0;
  double marginTopY;
  //padding between the bars
  final double paddingY = 5;
  final double axisWidth = 2;
  final double barHeight = 15;
  final double percentage;
  PokeBarStatsPainter(this.data, this.percentage) {
    // determine where to begin with X, based on the width of the category names
    data.forEach((key, value) {
      var text = createText(key, 1, true);
      if ((text.width + 5) > marginTopX) {
        marginTopX = text.width + 5;
      }
    });
    marginTopY = paddingY;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double number = 0;
    double sum = 0;
    data.forEach((key, value) {
      drawBar(canvas, size, number, key, value, sum);
      number++;
      sum += value;
    });
  }

  void drawBar(Canvas canvas, Size size, double number, String key, int value,
      double sum) {
    double y = number * (paddingY + barHeight) + marginTopY + barHeight / 2;

    Color colorBar = Colors.red.shade300;
    if (value >= 100) {
      colorBar = Colors.green.shade300;
    } else if (value >= 90) {
      colorBar = Colors.orange.shade300;
    }

    drawText(key, canvas, 0, y, label: true);
    drawText(value.toString(), canvas, marginTopX + 5, y, label: false);
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barHeight - 10
      ..color = colorBar;

    double minValue = min(totalValue() * percentage / 100 - sum, value * 1.0);
    if (minValue > 0) {
      final width = (size.width - marginTopX) / (maxValue() / minValue);

      if (width + marginTopX < size.width) {
        Paint paint2 = Paint()
          ..strokeWidth = barHeight - 10
          ..strokeCap = StrokeCap.round
          ..color = Colors.grey.shade100;

        canvas.drawLine(
          Offset(width + marginTopX + 2, y),
          Offset(size.width, y),
          paint2,
        );
      }

      canvas.drawLine(
        Offset(marginTopX + 35, y),
        Offset(width + marginTopX, y),
        paint,
      );
    }
  }

  void drawText(String key, Canvas canvas, double x, double y,
      {bool label = false}) {
    TextPainter tp = createText(key, 1, label);
    tp.paint(canvas, new Offset(x, y - tp.height / 2));
  }

  TextPainter createText(String key, double scale, bool label) {
    TextSpan span = new TextSpan(
        style: GoogleFonts.rambla(
            fontSize: 14, color: label ? Colors.grey.shade500 : Colors.black),
        text: key);

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textScaleFactor: scale,
        textDirection: TextDirection.ltr);
    tp.layout();
    return tp;
  }

  @override
  bool shouldRepaint(PokeBarStatsPainter oldDelegate) =>
      this.percentage != oldDelegate.percentage;

  int maxValue() => data.values.reduce(max);
  int totalValue() => data.values.fold(0, (p, c) => p + c);
}
