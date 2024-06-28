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

  const HomeBody({
    Key? key,
    required this.time,
    required this.levelBox,
    required this.levelService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CharacterDisplay(
              size: size,
              character: levelService.currentLevel.currentCharacter,
            ),
            TimerDisplayContainer(size: size, time: time),
            const SoundButton(),
            LevelExperienceWidget(levelBox: levelBox),
          ],
        ),
      ),
    );
  }
}
