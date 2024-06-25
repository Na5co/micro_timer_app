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

  TimerService(this._entryBox, this._levelService);

  Stream<String> get timeStream => _streamController.stream;
  Level get currentLevel => _levelService.currentLevel;

  bool get isRunning => _timer?.isActive ?? false;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration += const Duration(seconds: 1);
      _updateTime();
    });
  }

  Future<void> stop() async {
    _timer?.cancel();
    await logDurationWithType("default");
    _levelService.updateExperiencePoints(_duration.inSeconds);
    _duration = Duration.zero;
    _updateTime();
  }

  Future<void> logDurationWithType(String type) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM, dd/yyyy').format(now);
    final entry = TimerEntry(
      _formatDuration(_duration),
      formattedDate,
      type,
    );
    await _entryBox.add(entry);
    _duration = Duration.zero;
  }

  void _updateTime() {
    _streamController.add(_formatDuration(_duration));
  }

  String _formatDuration(Duration duration) {
    String formatDurationPart(int value, String singular, String plural) {
      return value == 1 ? "$value $singular" : "$value $plural";
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];
    if (hours > 0) parts.add(formatDurationPart(hours, "hour", "hours"));
    if (minutes > 0) {
      parts.add(formatDurationPart(minutes, "minute", "minutes"));
    }
    if (seconds > 0 || parts.isEmpty) {
      parts.add(formatDurationPart(seconds, "second", "seconds"));
    }

    return parts.join(" ");
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}
