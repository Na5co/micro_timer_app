import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/level.dart';
import '../models/character.dart';
import '../characters.dart';
import '../services/achievement_service.dart';

class LevelService {
  final Box<Level> _levelBox;
  final AchievementService _achievementService;
  late final ValueNotifier<Level?> _levelUpNotifier =
      ValueNotifier<Level?>(null);

  LevelService(this._levelBox, this._achievementService) {
    _initializeLevel();
  }

  void _initializeLevel() {
    if (_levelBox.isEmpty) {
      final initialCharacter = kCharacters.first;
      final initialLevel = Level(
        currentLevel: 0,
        currentExperience: 0,
        currentCharacter: initialCharacter.name,
      );
      _levelBox.put(0, initialLevel);
    }
  }

  Level get currentLevel => _levelBox.get(0)!;

  ValueNotifier<Level?> get levelUpNotifier => _levelUpNotifier;

  void updateExperiencePoints(int points) {
    final level = currentLevel;
    level.currentExperience += points;
    bool leveledUp = false;
    while (level.currentExperience >=
        kCharacters[level.currentLevel + 1].experiencePoints) {
      level.currentLevel++;
      level.currentCharacter = kCharacters[level.currentLevel].name;
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
