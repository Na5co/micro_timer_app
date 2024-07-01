import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level.dart';
import '../models/character.dart';
import '../constants.dart';
import '../characters.dart';

class LevelExperienceWidget extends StatelessWidget {
  final Box<Level> levelBox;
  final Key experienceBarKey;

  const LevelExperienceWidget({
    super.key,
    required this.levelBox,
    required this.experienceBarKey,
  });

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
      key: experienceBarKey,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.6)
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level ${level.currentLevel}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  character.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Experience',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: level.currentExperience /
                    kCharacters[level.currentLevel].experiencePoints,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${level.currentExperience}/${kCharacters[level.currentLevel].experiencePoints} XP',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: kSecondaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
