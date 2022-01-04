import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/databases/sa.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 330,
        width: 330,
        child: Transform.rotate(
          angle: -pi / 2,
          child: CustomPaint(
            painter: ClockPainter(),
          ),
        ));
  }
}

class ClockPainter extends CustomPainter {
  DateTime dateTime = DateTime.now();
  List list = Hive.box("Time_Table").values.toList();

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = size.width / 3;

    final mainBody = Paint();

    mainBody.strokeWidth = 10.0;
    mainBody.color = Colors.cyan[50];

    final outline = Paint()
      ..strokeWidth = 9.0
      ..color = Colors.cyan[800]
      ..style = PaintingStyle.stroke;

    final dial = Paint()..color = Colors.cyan[800];

    final hourHand = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(colors: [Colors.lime[700], Colors.amber])
          .createShader(Rect.fromCircle(center: center, radius: radius));
    final secHand = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(colors: [Colors.lime[100], Colors.amber])
          .createShader(Rect.fromCircle(center: center, radius: radius));

    final minHand = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(colors: [Colors.lime, Colors.amber])
          .createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, mainBody);
    canvas.drawCircle(center, radius, outline);

    for (var item in list) {
      int h = item["timeHour"] >= 12 ? item["timeHour"] - 12 : item["timeHour"];
      int m = item['timeMinute'];

      Subjects s = Hive.box<Subjects>("Subjects").get(item['subject']);

      List<Color> colors = [];

      s != null
          ? s.colorsList.forEach((element) {
              colors.add(element);
            })
          : colors = [];

      int durh = item["durHour"];
      int durm = item["durMin"];
      final d = Paint()
        ..shader = RadialGradient(
                colors: item['done']
                    ? [Colors.blueGrey, Colors.blueGrey[800]]
                    : s != null
                        ? colors
                        : [Colors.pink, Colors.purple])
            .createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius - 5),
          (h * pi / 6) + (m * pi / 360),
          ((durh * pi / 6) + (durm * pi / 360)),
          true,
          d);
    }

    final marks = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.cyan[800];

    for (var i = 0; i < 360; i += 30) {
      final x1 = centerX + radius * cos(i * pi / 180);
      final y1 = centerY + radius * sin(i * pi / 180);

      final x2 = centerX + (radius - 15) * cos(i * pi / 180);
      final y2 = centerY + (radius - 15) * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), marks);
    }

    final hourX = centerX +
        65 * cos((dateTime.hour * 30 + dateTime.minute * .5) * pi / 180);
    final hourY = centerY +
        65 * sin((dateTime.hour * 30 + dateTime.minute * .5) * pi / 180);
    canvas.drawLine(center, Offset(hourX, hourY), hourHand);

    final minX = centerX + 90 * cos(dateTime.minute * 6 * pi / 180);
    final minY = centerY + 90 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minX, minY), minHand);

    final secX = centerX + 90 * cos(dateTime.second * 6 * pi / 180);
    final secY = centerY + 90 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secX, secY), secHand);

    canvas.drawCircle(center, radius - 110, dial);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
