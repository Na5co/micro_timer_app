// import 'dart:async';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import '../models/timer_entry.dart';
// import '../models/level.dart';
// import '../services/level_service.dart';

// class TimerService {
//   final LevelService _levelService;
//   final _streamController = StreamController<String>.broadcast();
//   Timer? _timer;

//   TimerService(this._levelService);

//   Stream<String> get timeStream => _streamController.stream;
//   Level get currentLevel => _levelService.currentLevel;

//   bool get isRunning => _timer?.isActive ?? false;

//   void dispose() {
//     _timer?.cancel();
//     _streamController.close();
//   }
// }
