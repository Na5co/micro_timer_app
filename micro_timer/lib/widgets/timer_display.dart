import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final String time;

  const TimerDisplay({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        time,
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
