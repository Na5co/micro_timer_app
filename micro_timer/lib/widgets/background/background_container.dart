import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../../constants.dart';

class GradientBGContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget? child;

  const GradientBGContainer({
    super.key,
    required this.height,
    required this.width,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1.0,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 100,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedMeshGradient(
                  options: AnimatedMeshGradientOptions(
                    amplitude: 10,
                    speed: 5,
                    grain: 0.2,
                  ),
                  colors: kGradientColors,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              if (child != null) Positioned.fill(child: child!),
            ],
          ),
        ),
      ),
    );
  }
}
