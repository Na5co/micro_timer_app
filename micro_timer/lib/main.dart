import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/achievement.dart';
import 'models/timer_entry.dart';
import 'models/level.dart';
import 'screens/home_screen.dart';
import 'screens/test_level_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TimerEntryAdapter());
  Hive.registerAdapter(AchievementAdapter());
  Hive.registerAdapter(LevelAdapter());

  final timerBox = await Hive.openBox<TimerEntry>('timerEntries');
  final achievementBox = await Hive.openBox<Achievement>('achievements');
  final levelBox = await Hive.openBox<Level>('levels');

  if (levelBox.isEmpty) {
    levelBox.put(0,
        Level(currentLevel: 0, currentExperience: 0, currentCharacter: 'Cell'));
  }

  runApp(TimerApp(
    timerBox: timerBox,
    achievementBox: achievementBox,
    levelBox: levelBox,
  ));
}

class TimerApp extends StatelessWidget {
  final Box<TimerEntry> timerBox;
  final Box<Achievement> achievementBox;
  final Box<Level> levelBox;

  const TimerApp({
    super.key,
    required this.timerBox,
    required this.achievementBox,
    required this.levelBox,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(
        timerBox: timerBox,
        achievementBox: achievementBox,
        levelBox: levelBox,
      ),
      routes: {
        '/test': (context) => TestLevelScreen(levelBox: levelBox),
      },
    );
  }
}
