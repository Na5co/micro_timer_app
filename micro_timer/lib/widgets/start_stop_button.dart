import 'package:flutter/material.dart';

class StartStopButton extends StatefulWidget {
  final bool isRunning;
  final VoidCallback onPress;

  const StartStopButton({
    super.key,
    required this.isRunning,
    required this.onPress,
  });

  @override
  _StartStopButtonState createState() => _StartStopButtonState();
}

class _StartStopButtonState extends State<StartStopButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onPress,
      backgroundColor: widget.isRunning ? Colors.red : Colors.green,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          widget.isRunning ? Icons.stop : Icons.play_arrow,
          key: ValueKey<bool>(widget.isRunning),
        ),
      ),
    );
  }
}
