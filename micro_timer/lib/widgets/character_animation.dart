import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  final double width;
  final double height;

  const LottieAnimation({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/egg_level1.json',
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
