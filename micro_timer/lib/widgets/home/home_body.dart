import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:micro_timer/models/character.dart';
import '../../services/level_service.dart';
import '../../models/level.dart';
import '../../widgets/asset_loaders/sound.dart';
import '../../widgets/level_experience.dart';
import 'character_display.dart';
import 'timer_display_container.dart';
import '../../characters.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCharacterCard(context, size),
        TimerDisplayContainer(size: size, time: time, timerKey: timerKey),
        LevelExperienceWidget(
            levelBox: levelBox, experienceBarKey: experienceBarKey),
      ],
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
        height: size.height * 0.35,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent.withOpacity(0.51),
              Colors.purpleAccent.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CharacterDisplay(
                    size: Size(size.width * 0.4, size.height * 0.25),
                    character: character.name,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      _showCharacterDescription(context, character),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Character Details',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
