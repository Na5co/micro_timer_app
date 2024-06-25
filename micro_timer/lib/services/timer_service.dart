import 'dart:async';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/timer_entry.dart';
import 'achievement_service.dart';

class TimerService {
  final Box<TimerEntry> _box;
  final AchievementService _achievementService;
  final _streamController = StreamController<String>.broadcast();
  Timer? _timer;
  Duration _duration = Duration.zero;
  int _completedPomodoros = 0;

  TimerService(this._box, this._achievementService);

  Stream<String> get timeStream => _streamController.stream;

  bool get isRunning => _timer?.isActive ?? false;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Update every second
      _duration += const Duration(seconds: 1);
      _updateTime();
    });
  }

  Future<void> stop() async {
    _timer?.cancel();
    _completedPomodoros++;
    _achievementService.checkAndUnlockAchievements(_completedPomodoros);
    _duration = Duration.zero;
    _updateTime();
  }

  Future<void> logDurationWithType(String type) async {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM, dd/yyyy').format(now);
    final entry = TimerEntry(
      _duration.inHours > 0
          ? '${_duration.inHours}:${twoDigits(_duration.inMinutes.remainder(60))}:${twoDigits(_duration.inSeconds.remainder(60))}'
          : '${twoDigits(_duration.inMinutes.remainder(60))}:${twoDigits(_duration.inSeconds.remainder(60))}',
      formattedDate,
      type,
    );
    await _box.add(entry);
  }

  void _updateTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final formattedTime = _duration.inHours > 0
        ? '${twoDigits(_duration.inHours)}:${twoDigits(_duration.inMinutes.remainder(60))}:${twoDigits(_duration.inSeconds.remainder(60))}'
        : '${twoDigits(_duration.inMinutes.remainder(60))}:${twoDigits(_duration.inSeconds.remainder(60))}';
    _streamController.add(formattedTime);
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}
