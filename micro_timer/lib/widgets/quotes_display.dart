import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuotesDisplay extends StatelessWidget {
  final double width; // Add a width parameter to control size

  const QuotesDisplay({super.key, required this.width});

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Always Keep Winning"),
      ].animate(interval: 400.ms).fade(duration: 5000.ms).shimmer(
        colors: [
          Colors.green,
          Colors.red,
          Colors.orange,
          Colors.purple,
        ],
      ),
    );
  }
}
