import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/level.dart';
import '../models/character.dart';
import '../constants.dart';
import '../characters.dart';
import '../services/achievement_service.dart';

class LevelService {
  final Box<Level> _levelBox;
  final AchievementService _achievementService;
  late final ValueNotifier<Level?> _levelUpNotifier =
      ValueNotifier<Level?>(null);

  LevelService(this._levelBox, this._achievementService);

  Level get currentLevel =>
      _levelBox.get(0) ??
      Level(currentExperience: 0, currentLevel: 0, currentCharacter: 'Egg');

  ValueNotifier<Level?> get levelUpNotifier => _levelUpNotifier;

  void updateExperiencePoints(int points) {
    final level = currentLevel;
    level.currentExperience += points;
    bool leveledUp = false;
    while (true) {
      final nextLevel = level.currentLevel + 1;
      final character = kCharacters.firstWhere(
        (char) => char.level == nextLevel,
        orElse: () => Character(
          level: level.currentLevel,
          name: 'Unknown',
          experiencePoints: level.currentExperience,
          description: 'Unknown character',
        ),
      );
      if (level.currentExperience < character.experiencePoints) {
        break;
      }
      level.currentExperience -= character.experiencePoints;
      level.currentLevel = nextLevel;
      level.currentCharacter = character.name;
      leveledUp = true;
    }
    level.save();

    _achievementService.checkAndUnlockAchievements(level.currentLevel);

    if (leveledUp) {
      _levelUpNotifier.value = level;
      _levelUpNotifier.notifyListeners();
    }
  }
}
