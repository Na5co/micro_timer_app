import 'dart:async';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/timer_entry.dart';

class TimerService {
  final Box<TimerEntry> _box;
  final _streamController = StreamController<String>.broadcast();
  Timer? _timer;
  Duration _duration = Duration.zero;

  TimerService(this._box);

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

  Future<void> stop([String? type]) async {
    _timer?.cancel();
    await _logDuration(_duration, type);
    _duration = Duration.zero;
    _updateTime();
  }

  void _updateTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final formattedTime = _duration.inHours > 0
        ? '${twoDigits(_duration.inHours)}:${twoDigits(_duration.inMinutes.remainder(60))}:${twoDigits(_duration.inSeconds.remainder(60))}'
        : '${twoDigits(_duration.inMinutes.remainder(60))}:${twoDigits(_duration.inSeconds.remainder(60))}';
    _streamController.add(formattedTime);
  }

  Future<void> _logDuration(Duration duration, [String? type]) async {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM, dd/yyyy').format(now);
    final entry = TimerEntry(
      duration.inHours > 0
          ? '${duration.inHours}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}'
          : '${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}',
      formattedDate,
      type, // Log the type
    );
    await _box.add(entry);
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}
