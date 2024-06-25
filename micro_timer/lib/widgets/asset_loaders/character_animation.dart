import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CharacterAnimation extends StatelessWidget {
  final double width;
  final double height;
  final String character;

  const CharacterAnimation({
    super.key,
    required this.width,
    required this.height,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/$character.json',
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
