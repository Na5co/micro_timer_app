import 'dart:async';

class TimerService {
  final _streamController = StreamController<String>.broadcast();
  Timer? _timer;
  Duration _duration = Duration.zero;

  Stream<String> get timeStream => _streamController.stream;

  bool get isRunning => _timer?.isActive ?? false;

  void start() {
    _timer?.cancel();
    // Update the timer to fire every 10 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _duration = _duration + const Duration(milliseconds: 10);
      _updateTime();
    });
  }

  void stop() {
    _timer?.cancel();
    _duration = Duration.zero;
    _updateTime();
  }

  void _updateTime() {
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String formattedTime =
        '${twoDigits(_duration.inMinutes.remainder(60))}:${twoDigits(_duration.inSeconds.remainder(60))}.${threeDigits(_duration.inMilliseconds.remainder(1000))}';
    _streamController.add(formattedTime);
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}
