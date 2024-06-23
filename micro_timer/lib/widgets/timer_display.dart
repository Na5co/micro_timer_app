import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final String time;

  const TimerDisplay({required this.time});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        time,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
