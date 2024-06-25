import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../services/timer_service.dart';
import '../services/achievement_service.dart';
import '../widgets/timer_display.dart';
import '../widgets/start_stop_button.dart';
import '../widgets/background_container.dart';
import '../widgets/sound.dart';
import '../widgets/character_animation.dart';
import '../models/timer_entry.dart';
import '../models/achievement.dart';
import 'entries_screen.dart';
import 'achievement_screen.dart';

class HomeScreen extends StatefulWidget {
  final Box<TimerEntry> timerBox;
  final Box<Achievement> achievementBox;

  const HomeScreen({
    super.key,
    required this.timerBox,
    required this.achievementBox,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TimerService _timerService;
  late AchievementService _achievementService;
  String _time = "00:00:00";

  @override
  void initState() {
    super.initState();
    _achievementService = AchievementService(widget.achievementBox);
    _timerService = TimerService(widget.timerBox, _achievementService);
    _timerService.timeStream.listen((time) {
      setState(() {
        _time = time;
      });
    });
  }

  Future<void> _showActivityTypeDialog() async {
    final List<String> _activityTypes = [
      'work',
      'exercise',
      'study',
      'leisure'
    ];
    String? selectedType;

    final value = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Activity Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _activityTypes.map((type) {
              return RadioListTile<String>(
                title: Text(type),
                value: type,
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                  Navigator.of(context).pop(value);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (value != null) {
      _timerService.logDurationWithType(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Samurai Timer", style: GoogleFonts.lato()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AchievementsScreen(achievementBox: widget.achievementBox),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieAnimation(
              width: size.width * 0.5,
              height: size.height * 0.3,
            ),
            SizedBox(height: size.height * 0.05),
            Stack(
              alignment: Alignment.center,
              children: [
                GradientBGContainer(
                  height: size.height * 0.1,
                  width: size.width * 0.8,
                ),
                TimerDisplay(time: _time),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            const SoundButton(),
            SizedBox(height: size.height * 0.05),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EntriesScreen(timerBox: widget.timerBox),
                  ),
                );
              },
              child: const Text('View History'),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Text(
                "Stay focused, stay humble.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StartStopButton(
        isRunning: _timerService.isRunning,
        onPress: () async {
          if (_timerService.isRunning) {
            await _timerService.stop();
            _showActivityTypeDialog();
          } else {
            _timerService.start();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }
}
