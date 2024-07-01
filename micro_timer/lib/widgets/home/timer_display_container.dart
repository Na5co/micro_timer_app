import 'package:flutter/material.dart';
import '../../widgets/timer_display.dart';
import '../../widgets/background/background_container.dart';
import '../../services/timer_service.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerDisplayContainer extends StatelessWidget {
  final Size size;
  final String time;
  final PomodoroState pomodoroState;
  final Key timerKey;

  const TimerDisplayContainer({
    super.key,
    required this.size,
    required this.time,
    required this.pomodoroState,
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
            height: size.height,
            width: size.width * 1,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _getStateText(),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent.withOpacity(0.8),
                ),
              ),
              TimerDisplay(time: time, state: pomodoroState),
            ],
          ),
        ],
      ),
    );
  }

  String _getStateText() {
    switch (pomodoroState) {
      case PomodoroState.focus:
        return 'Focus Session';
      case PomodoroState.shortBreak:
        return 'Short Break';
      case PomodoroState.longBreak:
        return 'Long Break';
    }
  }
}
