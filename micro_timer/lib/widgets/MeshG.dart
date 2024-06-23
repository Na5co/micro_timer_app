import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class MeshG extends StatelessWidget {
  const MeshG({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final containerWidth = size.width * 0.8;
    final containerHeight = size.height * 0.8;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      child: SizedBox(
        height: containerHeight,
        width: containerWidth,
        child: AnimatedMeshGradient(
          options: AnimatedMeshGradientOptions(),
          colors: const [
            Colors.lime,
            Colors.yellow,
            Colors.green,
            Colors.greenAccent,
          ],
        ),
      ),
    );
  }
}
