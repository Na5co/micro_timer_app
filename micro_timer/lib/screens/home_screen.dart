import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../services/timer_service.dart';
import '../services/achievement_service.dart';
import '../services/level_service.dart';
import '../widgets/timer_display.dart';
import '../widgets/start_stop_button.dart';
import '../widgets/background/background_container.dart';
import '../widgets/asset_loaders/sound.dart';
import '../widgets/asset_loaders/character_animation.dart';
import '../widgets/level_experience.dart';
import '../models/timer_entry.dart';
import '../models/achievement.dart';
import '../models/level.dart';
import 'entries_screen.dart';
import 'achievement_screen.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  final Box<TimerEntry> timerBox;
  final Box<Achievement> achievementBox;
  final Box<Level> levelBox;

  const HomeScreen({
    super.key,
    required this.timerBox,
    required this.achievementBox,
    required this.levelBox,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TimerService _timerService;
  late final AchievementService _achievementService;
  late final LevelService _levelService;
  String _time = "00:00:00";

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    _achievementService = AchievementService(widget.achievementBox);
    _levelService = LevelService(widget.levelBox, _achievementService);
    _timerService = TimerService(widget.timerBox, _levelService);
    _timerService.timeStream.listen(_updateTime);
  }

  void _updateTime(String time) {
    setState(() => _time = time);
  }

  Future<void> _showActivityTypeDialog() async {
    final selectedType = await showDialog<String>(
      context: context,
      builder: (context) => _buildActivityTypeDialog(kActivityTypes),
    );

    if (selectedType != null) {
      _timerService.logDurationWithType(selectedType);
    }
  }

  Widget _buildActivityTypeDialog(List<String> activityTypes) {
    return AlertDialog(
      title: const Text('Select Activity Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            activityTypes.map((type) => _buildRadioListTile(type)).toList(),
      ),
    );
  }

  Widget _buildRadioListTile(String type) {
    return RadioListTile<String>(
      title: Text(type),
      value: type,
      groupValue: null,
      onChanged: (value) => Navigator.of(context).pop(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("Pomodo Samurai", style: GoogleFonts.lato()),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.emoji_events),
          tooltip: 'Achievements',
          onPressed: _navigateToAchievementsScreen,
        ),
        IconButton(
          icon: const Icon(Icons.history),
          tooltip: 'View History',
          onPressed: _navigateToEntriesScreen,
        ),
      ],
    );
  }

  Widget _buildBody() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCharacterAnimation(size),
            _buildTimerDisplay(size),
            const SoundButton(),
            LevelExperienceWidget(levelBox: widget.levelBox),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterAnimation(Size size) {
    return Center(
      child: CharacterAnimation(
        width: size.width * 0.5,
        height: size.height * 0.3,
        character: _levelService.currentLevel.currentCharacter,
      ),
    );
  }

  Widget _buildTimerDisplay(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientBGContainer(
            height: size.height * 0.1,
            width: size.width * 0.8,
          ),
          TimerDisplay(time: _time),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return StartStopButton(
      isRunning: _timerService.isRunning,
      onPress: _handleStartStop,
    );
  }

  void _navigateToAchievementsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AchievementsScreen(achievementBox: widget.achievementBox),
      ),
    );
  }

  void _navigateToEntriesScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EntriesScreen(timerBox: widget.timerBox),
      ),
    );
  }

  Future<void> _handleStartStop() async {
    if (_timerService.isRunning) {
      await _timerService.stop();
      _showActivityTypeDialog();
    } else {
      _timerService.start();
    }
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }
}
