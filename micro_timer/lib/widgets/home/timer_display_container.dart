import 'package:flutter/material.dart';
import '../../widgets/timer_display.dart';
import '../../widgets/background/background_container.dart';

class TimerDisplayContainer extends StatelessWidget {
  final Size size;
  final String time;

  const TimerDisplayContainer({
    Key? key,
    required this.size,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientBGContainer(
            height: size.height * 0.1,
            width: size.width * 0.8,
          ),
          TimerDisplay(time: time),
        ],
      ),
    );
  }
}
