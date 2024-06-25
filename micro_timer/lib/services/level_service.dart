import 'package:hive/hive.dart';
import '../models/level.dart';
import '../constants.dart';
import 'achievement_service.dart';

class LevelService {
  final Box<Level> _levelBox;
  final AchievementService _achievementService;

  LevelService(this._levelBox, this._achievementService);

  Level get currentLevel => _levelBox.get(0)!;

  void updateExperiencePoints(int points) {
    final level = currentLevel;
    level.currentExperience += points;
    int nextLevelExperience =
        kExperiencePoints[level.currentLevel + 1] ?? double.maxFinite.toInt();

    while (level.currentExperience >= nextLevelExperience) {
      level.currentExperience -= nextLevelExperience;
      level.currentLevel += 1;
      level.currentCharacter =
          kCharacters[level.currentLevel] ?? kCharacters[1]!;
      nextLevelExperience =
          kExperiencePoints[level.currentLevel + 1] ?? double.maxFinite.toInt();
    }
    level.save();
    _achievementService.checkAndUnlockAchievements(level.currentLevel);
  }

  int experienceForNextLevel() {
    final level = currentLevel;
    return kExperiencePoints[level.currentLevel + 1] ?? 0;
  }
}
