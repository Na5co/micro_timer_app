import 'dart:async';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/timer_entry.dart';
import '../models/level.dart';
import 'level_service.dart';

class TimerService {
  final Box<TimerEntry> _entryBox;
  final LevelService _levelService;
  final _streamController = StreamController<String>.broadcast();
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;

  TimerService(this._entryBox, this._levelService);

  Stream<String> get timeStream => _streamController.stream;
  Level get currentLevel => _levelService.currentLevel;

  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return; // Prevent starting if already running

    _isRunning = true;
    _duration = Duration.zero; // Ensure duration is reset at the start
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration += const Duration(seconds: 1);
      _updateTime();
    });
  }

  Future<void> stop(type) async {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();

    if (_duration.inSeconds > 0) {
      await logDurationWithType(type);
      _levelService.updateExperiencePoints(_duration.inSeconds);
    }

    _duration = Duration.zero;
    _updateTime();
  }

  Future<void> logDurationWithType(String type) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM, dd/yyyy').format(now);
    final entry = TimerEntry(
      _duration.inSeconds,
      formattedDate,
      type,
    );
    print('Logging duration: ${entry.durationInSeconds}s');
    await _entryBox.add(entry);
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
