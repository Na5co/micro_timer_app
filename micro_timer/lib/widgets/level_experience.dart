import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level.dart';
import '../models/character.dart';

import '../constants.dart';
import '../characters.dart';

class LevelExperienceWidget extends StatelessWidget {
  final Box<Level> levelBox;

  const LevelExperienceWidget({super.key, required this.levelBox});

  @override
  Widget build(BuildContext context) {
    final level = levelBox.get(0);
    if (level == null) {
      return const Center(child: Text('Level information not found.'));
    }

    final character = kCharacters.firstWhere(
      (char) => char.level == level.currentLevel,
      orElse: () => Character(
        level: 0,
        name: 'Unknown',
        experiencePoints: 0,
        description: 'No character found',
      ),
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Level: ${level.currentLevel}',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Character: ${character.name}',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: level.currentExperience /
                (kCharacters[level.currentLevel].experiencePoints),
            backgroundColor: Colors.grey.shade300,
            color: kPrimaryColor,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            'Experience: ${level.currentExperience}/${kCharacters[level.currentLevel].experiencePoints}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: kSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You are now ${character.name}. ${character.description}',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: kSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
