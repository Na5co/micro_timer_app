import 'dart:async';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/timer_entry.dart';
import '../models/level.dart';
import 'level_service.dart';

enum PomodoroState { focus, shortBreak, longBreak }

class TimerService {
  final Box<TimerEntry> _entryBox;
  final LevelService _levelService;
  final _timeStreamController = StreamController<String>.broadcast();
  final _stateStreamController = StreamController<PomodoroState>.broadcast();
  Timer? _timer;
  Duration _duration = const Duration(minutes: 25);
  bool _isRunning = false;
  PomodoroState _currentState = PomodoroState.focus;
  int _completedPomodoros = 0;

  final int focusDuration = 25 * 60; // 25 minutes
  final int shortBreakDuration = 5 * 60; // 5 minutes
  final int longBreakDuration = 15 * 60; // 15 minutes
  final int longBreakInterval = 4; // Long break after every 4 pomodoros

  TimerService(this._entryBox, this._levelService);

  Stream<String> get timeStream => _timeStreamController.stream;
  Stream<PomodoroState> get stateStream => _stateStreamController.stream;
  Level get currentLevel => _levelService.currentLevel;
  bool get isRunning => _isRunning;
  PomodoroState get currentState => _currentState;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration -= const Duration(seconds: 1);
        _updateTime();
      } else {
        _completeCurrentSession();
      }
    });
  }

  Future<void> stop() async {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();

    if (_currentState == PomodoroState.focus) {
      await logDurationWithType('focus');
      _levelService.updateExperiencePoints(
          _getDurationForCurrentState() - _duration.inSeconds);
    }

    _duration = Duration(seconds: _getDurationForCurrentState());
    _updateTime();
  }

  void skipCurrentSession() {
    stop();
    _completeCurrentSession();
  }

  Future<void> logDurationWithType(String type) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM, dd/yyyy').format(now);
    final entry = TimerEntry(
      _getDurationForCurrentState() - _duration.inSeconds,
      formattedDate,
      type,
    );
    await _entryBox.add(entry);
  }

  void _updateTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    _timeStreamController.add('$minutes:$seconds');
  }

  void _completeCurrentSession() {
    stop();
    if (_currentState == PomodoroState.focus) {
      _completedPomodoros++;
      if (_completedPomodoros % longBreakInterval == 0) {
        _currentState = PomodoroState.longBreak;
      } else {
        _currentState = PomodoroState.shortBreak;
      }
    } else {
      _currentState = PomodoroState.focus;
    }
    _duration = Duration(seconds: _getDurationForCurrentState());
    _stateStreamController.add(_currentState);
    _updateTime();
  }

  int _getDurationForCurrentState() {
    switch (_currentState) {
      case PomodoroState.focus:
        return focusDuration;
      case PomodoroState.shortBreak:
        return shortBreakDuration;
      case PomodoroState.longBreak:
        return longBreakDuration;
    }
  }

  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
    _stateStreamController.close();
  }
}
