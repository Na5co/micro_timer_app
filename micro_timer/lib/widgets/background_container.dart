import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class GradientBGContainer extends StatelessWidget {
  final double height;
  final double width;
  const GradientBGContainer(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      child: SizedBox(
        height: height,
        width: width,
        child: AnimatedMeshGradient(
          options: AnimatedMeshGradientOptions(
              speed: 5, amplitude: 10, frequency: 5),
          colors: const [
            Colors.pink,
            Colors.pinkAccent,
            Colors.lightBlue,
            Colors.white,
          ],
        ),
      ),
    );
  }
}
