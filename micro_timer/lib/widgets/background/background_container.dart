import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../../constants.dart'; // Import the constants

class GradientBGContainer extends StatelessWidget {
  final double height;
  final double width;
  const GradientBGContainer({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      child: SizedBox(
        height: height,
        width: width,
        child: AnimatedMeshGradient(
          options: AnimatedMeshGradientOptions(
            grain: 0.5,
          ),
          colors: kGradientColors,
        ),
      ),
    );
  }
}
