import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:micro_timer/models/achievement.dart';
import '../services/timer_service.dart';
import '../services/achievement_service.dart';
import '../widgets/timer_display.dart';
import '../widgets/start_stop_button.dart';
import '../widgets/background_container.dart';
import '../widgets/glossy_container.dart';
import '../widgets/quotes_display.dart';
import '../widgets/sound.dart';
import '../models/timer_entry.dart';
import '../widgets/timer_entries.dart';
import '../widgets/achievment.dart';

class HomeScreen extends StatefulWidget {
  final Box<TimerEntry> timerBox;
  final Box<Achievement> achievementBox;

  const HomeScreen({
    Key? key,
    required this.timerBox,
    required this.achievementBox,
  }) : super(key: key);

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

  void _showActivityTypeDialog() async {
    final List<String> _activityTypes = [
      'work',
      'exercise',
      'study',
      'leisure'
    ];
    String? selectedType;

    await showDialog<String>(
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
    ).then((value) {
      if (value != null) {
        _timerService.logDurationWithType(value);
      }
    });
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
                      AchievementsList(achievementBox: widget.achievementBox),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 1),
                  child: QuotesDisplay(width: size.width),
                ),
                SizedBox(height: size.height * 0.08),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GradientBGContainer(
                        height: size.height * 0.2,
                        width: size.width * 0.9,
                      ),
                      GlossMask(
                        height: size.height * 0.15,
                        width: size.width * 0.45,
                      ),
                      TimerDisplay(time: _time),
                    ],
                  ),
                ),
                const SoundButton(),
              ],
            ),
          ),
          Expanded(
            child: EntriesList(timerBox: widget.timerBox),
          ),
          Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
            child: Text(
              "Stay focused, stay humble.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: StartStopButton(
        isRunning: _timerService.isRunning,
        onPress: () async {
          if (_timerService.isRunning) {
            _timerService.stop();
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
