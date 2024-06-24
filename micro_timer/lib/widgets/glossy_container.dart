import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';

class GlossMask extends StatelessWidget {
  final double height;
  final double width;

  const GlossMask({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GlossyContainer(
      borderRadius: BorderRadius.circular(10),
      opacity: 0.3,
      height: height,
      width: width,
    );
  }
}
