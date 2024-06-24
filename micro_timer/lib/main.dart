import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/timer_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TimerEntryAdapter());
  }

  final timerBox = await Hive.openBox<TimerEntry>('timerEntries');

  runApp(TimerApp(timerBox: timerBox));
}

class TimerApp extends StatelessWidget {
  final Box<TimerEntry> timerBox;

  const TimerApp({Key? key, required this.timerBox}) : super(key: key);

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
      ),
    );
  }
}
