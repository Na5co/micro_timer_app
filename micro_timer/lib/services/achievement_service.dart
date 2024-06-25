import 'package:hive/hive.dart';
import '../models/achievement.dart';

class AchievementService {
  final Box<Achievement> _box;

  AchievementService(this._box);

  List<Achievement> get achievements => _box.values.toList();

  void checkAndUnlockAchievements(int completedPomodoros) {
    if (completedPomodoros >= 10) {
      _unlockAchievement('First 10 Pomodoros', 'Complete 10 Pomodoros');
    }
    if (completedPomodoros >= 50) {
      _unlockAchievement('Half Century', 'Complete 50 Pomodoros');
    }
    if (completedPomodoros >= 100) {
      _unlockAchievement('Centurion', 'Complete 100 Pomodoros');
    }
  }

  void _unlockAchievement(String title, String description) {
    final achievement = _box.values.firstWhere(
      (a) => a.title == title,
      orElse: () => Achievement(title: title, description: description),
    );

    if (!achievement.achieved) {
      achievement.achieved = true;
      _box.put(achievement.title, achievement);
    }
  }
}
