import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/timer_service.dart';

class TimerDisplay extends StatelessWidget {
  final String time;
  final PomodoroState state;

  const TimerDisplay({
    super.key,
    required this.time,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: GoogleFonts.lato(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _getStateText() {
    switch (state) {
      case PomodoroState.focus:
        return 'Focus Session';
      case PomodoroState.shortBreak:
        return 'Short Break';
      case PomodoroState.longBreak:
        return 'Long Break';
    }
  }

  Color _getStateColor() {
    switch (state) {
      case PomodoroState.focus:
        return Colors.red.shade400;
      case PomodoroState.shortBreak:
        return Colors.green.shade400;
      case PomodoroState.longBreak:
        return Colors.blue.shade400;
    }
  }
}
