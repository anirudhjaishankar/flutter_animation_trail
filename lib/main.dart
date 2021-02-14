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

  bool _isPlaying = false;
  int elapsedtime = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 22),
    );

    Tween<double> _rotationTween = Tween(begin: 0, end: 100);

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          timerComplete();
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
          this.elapsedtime += 1;
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void timerStart(){

  }
  void timerPause(){

  }

  void timerComplete(){
    this.elapsedtime = 0;
    this._isPlaying = false;
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF2F7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 80.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xff396AFC), Color(0xff2948FF)])
                )
              ),
              SizedBox(width: 20.0),
              Text("Planks", style: TextStyle(
                fontSize: 36.0
              ),)
            ],
          ),
          SizedBox(height: 80.0),
          Column(
            children: [
              CustomPaint(
                painter: ShapePainter(animation.value),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0),
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500
                      )
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '00:00:0'+elapsedtime.toString(),
                      style: TextStyle(
                        fontSize: 36.0,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Target",
                      style: TextStyle(
                        fontSize: 24.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                       '00:00:45',
                      style: TextStyle(
                        fontSize: 30.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 90.0),
              RawMaterialButton(
                onPressed: () {
                  setState(() {
                    this._isPlaying = !this._isPlaying;
                    if (_isPlaying) {
                      controller.forward();
                    } else {
                      controller.stop();
                    }
                  });
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child:  _isPlaying ?
                Icon(
                  Icons.pause,
                  size: 45.0,
                ) :
                Icon(
                    Icons.play_arrow,
                    size: 45.0
                ),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              )
            ],
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
    var foregroundTimerCircleProperty = Paint()
      ..shader = RadialGradient(colors: [Color(0xff396AFC), Color(0xff2948FF)])
          .createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 1.7),
        radius: 140,
      ))
      ..strokeWidth = 15.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var backgroundTimerCircleProperty = Paint()
      ..shader = RadialGradient(colors: [Color(0xffCDDEEE), Color(0xffCDDEEE)])
          .createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 1.7),
        radius: 140,
      ))
      ..strokeWidth = 15.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var startAngle = math.pi * 1.5;
    var endAngle = (this.percentage / 100) * 2 * math.pi;

    canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 1.7),
          radius: 140,
        ),
        startAngle,
        math.pi * 2,
        false,
        backgroundTimerCircleProperty);

    canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 1.7),
          radius: 140,
        ),
        startAngle,
        endAngle,
        false,
        foregroundTimerCircleProperty);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
