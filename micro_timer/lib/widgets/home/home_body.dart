import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/character.dart';
import '../../services/level_service.dart';
import '../../services/timer_service.dart';
import '../../models/level.dart';
import '../../widgets/asset_loaders/sound.dart';
import '../../widgets/level_experience.dart';
import 'character_display.dart';
import 'timer_display_container.dart';
import '../../characters.dart';

class HomeBody extends StatelessWidget {
  final String time;
  final PomodoroState pomodoroState;
  final Box<Level> levelBox;
  final LevelService levelService;
  final GlobalKey characterKey;
  final GlobalKey timerKey;
  final GlobalKey experienceBarKey;

  const HomeBody({
    super.key,
    required this.time,
    required this.pomodoroState,
    required this.levelBox,
    required this.levelService,
    required this.characterKey,
    required this.timerKey,
    required this.experienceBarKey,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCharacterCard(context, size),
          TimerDisplayContainer(
            size: size,
            time: time,
            pomodoroState: pomodoroState,
            timerKey: timerKey,
          ),
          LevelExperienceWidget(
            levelBox: levelBox,
            experienceBarKey: experienceBarKey,
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, Size size) {
    final character = kCharacters.firstWhere(
      (char) => char.name == levelService.currentLevel.currentCharacter,
      orElse: () => kCharacters.first,
    );

    return Card(
      key: characterKey,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: size.height * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent.withOpacity(0.41),
              Colors.purpleAccent.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CharacterDisplay(
                    size: Size(size.width * 0.8, size.height * 0.6),
                    character: character.name,
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _showCharacterDescription(context, character),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Character Details',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ),
            const Positioned(
              top: 8,
              right: 8,
              child: SoundButton(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCharacterDescription(BuildContext context, Character character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(character.name,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(character.description, style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: GoogleFonts.poppins()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
