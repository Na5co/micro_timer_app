// import 'package:flutter/material.dart';
// import 'package:glossy/glossy.dart';

// class GlossMask extends StatelessWidget {
//   final double? height;
//   final double? width;
//   final Widget? child;

//   const GlossMask({
//     super.key,
//     this.height,
//     this.width,
//     this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(
//         minWidth: width ?? 0,
//         minHeight: height ?? 0,
//         maxWidth: width ?? double.infinity,
//         maxHeight: height ?? double.infinity,
//       ),
//       child: GlossyContainer(
//         borderRadius: BorderRadius.circular(10),
//         height: height ?? double.infinity,
//         width: width ?? double.infinity,
//         child: child,
//       ),
//     );
//   }
// }
