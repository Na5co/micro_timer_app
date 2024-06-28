import 'package:flutter/material.dart';
import '../../widgets/asset_loaders/character_animation.dart';

class CharacterDisplay extends StatelessWidget {
  final Size size;
  final String character;

  const CharacterDisplay({
    Key? key,
    required this.size,
    required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CharacterAnimation(
        width: size.width * 0.5,
        height: size.height * 0.3,
        character: character,
      ),
    );
  }
}
