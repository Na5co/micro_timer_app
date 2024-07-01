import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/timer_service.dart';
import '../services/achievement_service.dart';
import '../services/level_service.dart';
import '../widgets/start_stop_button.dart';
import '../services/onboarding_service.dart';

import '../widgets/levelup.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_body.dart';
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
    Key? key,
    required this.timerBox,
    required this.achievementBox,
    required this.levelBox,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TimerService _timerService;
  late final AchievementService _achievementService;
  late final LevelService _levelService;
  String _time = "00:00:00";
  bool _showOnboarding = false;

  final GlobalKey _characterKey = GlobalKey();
  final GlobalKey _timerKey = GlobalKey();
  final GlobalKey _experienceBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _levelService.levelUpNotifier.addListener(_showLevelUpPopup);
    _checkOnboarding();
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

  Future<void> _checkOnboarding() async {
    bool hasCompletedOnboarding =
        await OnboardingService.hasCompletedOnboarding();
    if (!hasCompletedOnboarding) {
      setState(() {
        _showOnboarding = true;
      });
    }
  }

  void _completeOnboarding() async {
    await OnboardingService.setOnboardingComplete();
    setState(() {
      _showOnboarding = false;
    });
  }

  void _showLevelUpPopup() {
    final level = _levelService.levelUpNotifier.value;
    if (level != null) {
      showDialog(
        context: context,
        builder: (context) => LevelUpPopup(character: level.currentCharacter),
      );
      _levelService.levelUpNotifier.value = null;
    }
  }

  Future<void> _showActivityTypeDialog() async {
    final selectedType = await showDialog<String>(
      context: context,
      builder: (context) => _buildActivityTypeDialog(kActivityTypes),
    );

    if (selectedType != null) {
      await _timerService.stop(selectedType);
    }
  }

  Widget _buildActivityTypeDialog(List<String> activityTypes) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Select Activity Type',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            activityTypes.map((type) => _buildRadioListTile(type)).toList(),
      ),
    );
  }

  Widget _buildRadioListTile(String type) {
    return RadioListTile<String>(
      title: Text(type, style: GoogleFonts.poppins()),
      value: type,
      groupValue: null,
      onChanged: (value) => Navigator.of(context).pop(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(
        onAchievementsPressed: _navigateToAchievementsScreen,
        onHistoryPressed: _navigateToEntriesScreen,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade100, Colors.purple.shade100],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: HomeBody(
                        time: _time,
                        levelBox: widget.levelBox,
                        levelService: _levelService,
                        characterKey: _characterKey,
                        timerKey: _timerKey,
                        experienceBarKey: _experienceBarKey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    StartStopButton(
                      isRunning: _timerService.isRunning,
                      onPress: _handleStartStop,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          if (_showOnboarding)
            OnboardingOverlay(
              steps: [
                OnboardingStep(
                  message:
                      "This is your character. It evolves as you focus and gain experience!",
                  targetKey: _characterKey,
                ),
                OnboardingStep(
                  message:
                      "This is the timer. Start it when you begin focusing, and stop it when you're done.",
                  targetKey: _timerKey,
                ),
                OnboardingStep(
                  message:
                      "This is your experience bar. As you focus, you'll gain experience and level up!",
                  targetKey: _experienceBarKey,
                ),
              ],
              onComplete: _completeOnboarding,
            ),
        ],
      ),
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
        builder: (context) => EntriesList(timerBox: widget.timerBox),
      ),
    );
  }

  Future<void> _handleStartStop() async {
    if (_timerService.isRunning) {
      _showActivityTypeDialog();
    } else {
      _timerService.start();
    }
  }

  @override
  void dispose() {
    _timerService.dispose();
    _levelService.levelUpNotifier.removeListener(_showLevelUpPopup);
    super.dispose();
  }
}
