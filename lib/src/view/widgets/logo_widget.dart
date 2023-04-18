import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:libroteca/src/styles/colors.dart';

class LogoWidget extends StatefulWidget {
  Size? size;
  LogoWidget({this.size});
  @override
  _LogoWidgetState createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  double width = 0.0;
  double height = 0.0;
  int duration = 1600;
  double heightCompleted = 0;
  double left = 0;
  Size? size;
  @override
  void initState() {
    super.initState();
    size = widget.size;
    left = size!.width * 0.31;
    heightCompleted = size!.height * 0.2;

    animationController = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
          if (duration > 200) {
            duration -= 300;
            setState(() {
              animationController.duration = Duration(milliseconds: duration);
              left += 200;
              if (left > size!.width) heightCompleted = 0;
            });
          }
          animationController.forward();
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 1)).then((e) {
        width = size!.height * 0.2;
        height = size!.height * 0.2;
      });
    });
    return AnimatedContainer(
      width: size!.width,
      height: heightCompleted,
      duration: Duration(seconds: 1),
      curve: Curves.bounceIn,
      child: Stack(
        children: [
          AnimatedPositioned(
            width: size!.height * 0.2,
            left: left,
            duration: Duration(milliseconds: duration),
            child: Transform.rotate(
              angle: animation.value,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                alignment: Alignment.center,
                width: width,
                height: height,
                child: Image.asset(
                  "assets/images/libro-logo.png",
                  colorBlendMode: BlendMode.color,
                  color: primaryColor,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
