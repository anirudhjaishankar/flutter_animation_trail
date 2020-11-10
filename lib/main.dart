import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animation Experiments',
      home: Container(child: MyPainter()),
    );
  }
}

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter>
    with SingleTickerProviderStateMixin {
  double percentage;

  Animation<double> animation;
  AnimationController controller;

  bool _isPlaying = true;
  String durationRemaining = "";
  Duration elapsedTime = new Duration();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    Tween<double> _rotationTween = Tween(begin: 0, end: 100);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          this.durationRemaining = controller.duration.inSeconds.toString();
          controller.stop();
        }

        if (!this._isPlaying) {
          controller.stop();
        }
      });

    controller.forward();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (animation.status != AnimationStatus.completed && _isPlaying) {
          elapsedTime = controller.lastElapsedDuration;
          this.durationRemaining = elapsedTime.inSeconds.toString();
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomPaint(
              painter: ShapePainter(animation.value),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
//                  FlatButton(
//                    child: _isPlaying ? Text("Stop") : Text("Start"),
//                    onPressed: () {
//                      setState(() {
//                        this._isPlaying = !this._isPlaying;
//                        if (_isPlaying) {
//                          controller.forward();
//                        } else {
//                          controller.stop();
//                        }
//                      });
//                    },
//                  ),
//                  SizedBox(height: 10.0),
                  Text(
                    durationRemaining + 's',
                    style: TextStyle(
                      fontSize: 50.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Black Widow Knee Slides",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  double percentage;

  ShapePainter([this.percentage = 0]);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = RadialGradient(colors: [Color(0xff396AFC), Color(0xff2948FF)])
          .createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: 150,
      ))
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var startAngle = math.pi * 1.5;
    var endAngle = (this.percentage / 100) * 2 * math.pi;

    canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: 150,
        ),
        startAngle,
        endAngle,
        false,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
