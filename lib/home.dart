import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Colors
  static const Color _bgColor = Color(0xff00af91);
  // static Color _ballColor = Color(0xfff58634);
  static Color _ballColor = Color(0xffffcc29);
  static const Color _trackColor = Color(0xff007965);

  static const double _ballH = 40;
  static const double _ballW = 40;
  static const double _containerH = 120;
  static const double _containerW = 300;
  static double _containerHy = math.sqrt(math.pow(_containerH, 2) + math.pow(_containerW, 2));

  // Animation Controllers
  AnimationController _a1;
  CurvedAnimation _c1;

  // Ball
  final Widget _ball = Container(
    width: _ballW,
    height: _ballH,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: _ballColor,
    ),
  );

  // counts
  int count = 0;

  // Animation function
  void _startAnimation() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count == 4) {
        setState(() {
          count = 0;
        });
      }
      setState(() {
        count++;
      });

      _a1.reset();
      _a1.forward();
      _c1 = CurvedAnimation(
        parent: _a1,
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  Pos _getPosition(CurvedAnimation _a1, int count) {
    Pos pos;

    if (count == 1) {
      pos =
          Pos((_containerH - _ballH) - (_a1.value * (_containerH - _ballH)), 0);
      return pos;
    } else if (count == 2) {
      pos = Pos(_a1.value * (_containerH - _ballH),
          _a1.value * (_containerW - _ballW));
      return pos;
    } else if (count == 3) {
      pos = Pos((_containerH - _ballH) - _a1.value * (_containerH - _ballH),
          (_containerW - _ballW));
      return pos;
    } else if (count == 4) {
      pos = Pos(_a1.value * (_containerH - _ballH),
          (_containerW - _ballW) - _a1.value * (_containerW - _ballW));
      return pos;
    } else {
      pos = Pos(_containerH - _ballH, 0);
      return pos;
    }
  }

  @override
  void initState() {
    super.initState();

    _a1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _c1 = CurvedAnimation(
      parent: _a1,
      curve: Curves.fastOutSlowIn,
    );

    _startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: Container(
          height: _containerH,
          width: _containerW,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: _containerH,
                  width: _ballW,
                  decoration: BoxDecoration(
                    color: _trackColor,
                    borderRadius: BorderRadius.circular(_ballH / 2),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  height: _containerH,
                  width: _ballW,
                  decoration: BoxDecoration(
                    color: _trackColor,
                    borderRadius: BorderRadius.circular(_ballH / 2),
                  ),
                ),
              ),
              Positioned(
                top: (_containerH - _ballH) / 2,
                child: Transform.rotate(
                  // angle: 23 * (pi / 180),
                  angle: math.asin(_containerH/(_containerHy+20)),
                  child: Container(
                    alignment: Alignment.center,
                    height: _ballH,
                    width: _containerW,
                    decoration: BoxDecoration(
                      color: _trackColor,
                      borderRadius: BorderRadius.circular(_ballH / 2),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (_containerH - _ballH) / 2,
                left: 0,
                child: Transform.rotate(
                  angle: -math.asin(_containerH/(_containerHy+20)),
                  child: Container(
                    alignment: Alignment.center,
                    height: _ballH,
                    width: _containerW,
                    decoration: BoxDecoration(
                      color: _trackColor,
                      borderRadius: BorderRadius.circular(_ballH / 2),
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _c1,
                builder: (_, child) {
                  return Positioned(
                    // top: (300 - _ballH) - (_a1.value * (300 - _ballH)),
                    // left: 0,
                    top: _getPosition(_c1, count).top,
                    left: _getPosition(_c1, count).left,
                    child: child,
                  );
                },
                child: _ball,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Pos {
  final double top, left;

  const Pos(this.top, this.left);
}
