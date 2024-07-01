import 'package:flutter/material.dart';
import '../../widgets/timer_display.dart';
import '../../widgets/background/background_container.dart';

class TimerDisplayContainer extends StatelessWidget {
  final Size size;
  final String time;
  final Key timerKey;

  const TimerDisplayContainer({
    super.key,
    required this.size,
    required this.time,
    required this.timerKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: timerKey,
      height: size.height * 0.15,
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
