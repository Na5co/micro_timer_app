import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../services/level_service.dart';
import '../../models/level.dart';
import '../../widgets/asset_loaders/sound.dart';
import '../../widgets/level_experience.dart';
import 'character_display.dart';
import 'timer_display_container.dart';

class HomeBody extends StatelessWidget {
  final String time;
  final Box<Level> levelBox;
  final LevelService levelService;
  final GlobalKey characterKey;
  final GlobalKey timerKey;
  final GlobalKey experienceBarKey;

  const HomeBody({
    super.key,
    required this.time,
    required this.levelBox,
    required this.levelService,
    required this.characterKey,
    required this.timerKey,
    required this.experienceBarKey,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCharacterCard(size),
            const SizedBox(height: 24),
            TimerDisplayContainer(size: size, time: time, timerKey: timerKey),
            const SizedBox(height: 16),
            const Center(child: SoundButton()),
            const SizedBox(height: 24),
            LevelExperienceWidget(
                levelBox: levelBox, experienceBarKey: experienceBarKey),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(Size size) {
    return Card(
      key: characterKey,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent.withOpacity(0.51),
              Colors.white.withOpacity(0.02)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CharacterDisplay(
          size: size,
          character: levelService.currentLevel.currentCharacter,
        ),
      ),
    );
  }
}
