import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/achievement.dart';
import 'models/timer_entry.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TimerEntryAdapter());
  Hive.registerAdapter(AchievementAdapter());

  final timerBox = await Hive.openBox<TimerEntry>('timerEntries');
  final achievementBox = await Hive.openBox<Achievement>('achievements');

  runApp(TimerApp(timerBox: timerBox, achievementBox: achievementBox));
}

class TimerApp extends StatelessWidget {
  final Box<TimerEntry> timerBox;
  final Box<Achievement> achievementBox;

  const TimerApp({
    Key? key,
    required this.timerBox,
    required this.achievementBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(timerBox: timerBox, achievementBox: achievementBox),
    );
  }
}
