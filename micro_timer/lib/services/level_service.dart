import 'package:hive/hive.dart';
import '../models/level.dart';
import '../constants.dart';
import '../services/achievement_service.dart';

class LevelService {
  final Box<Level> _levelBox;
  final AchievementService _achievementService;

  LevelService(this._levelBox, this._achievementService);

  Level get currentLevel => _levelBox.get(0)!;

  void updateExperiencePoints(int points) {
    final level = currentLevel;
    level.currentExperience += points;
    while (
        level.currentExperience >= kExperiencePoints[level.currentLevel + 1]!) {
      level.currentExperience -= kExperiencePoints[level.currentLevel + 1]!;
      level.currentLevel += 1;
      level.currentCharacter = kCharacters[level.currentLevel] ?? 'Cell';
    }
    level.save();
    _achievementService.checkAndUnlockAchievements(level.currentLevel);
  }
}
