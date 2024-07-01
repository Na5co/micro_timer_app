import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level.dart';
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

    final currentCharacter = kCharacters[level.currentLevel];
    final nextCharacter = level.currentLevel < kCharacters.length - 1
        ? kCharacters[level.currentLevel + 1]
        : kCharacters.last;

    final totalXPForNextLevel =
        nextCharacter.experiencePoints - currentCharacter.experiencePoints;
    final currentXPProgress =
        level.currentExperience - currentCharacter.experiencePoints;
    final progressFraction =
        totalXPForNextLevel > 0 ? currentXPProgress / totalXPForNextLevel : 0.0;

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
                  currentCharacter.name,
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
                widthFactor: progressFraction.clamp(0.0, 1.0),
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
            '$currentXPProgress/$totalXPForNextLevel XP',
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
