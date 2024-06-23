import 'package:flutter/material.dart';
import '../widgets/timer_display.dart';
import '../widgets/start_stop_button.dart';
import '../services/timer_service.dart';
import '../widgets/MeshG.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TimerService _timerService = TimerService();
  String _time = "00:00";

  @override
  void initState() {
    super.initState();
    _timerService.timeStream.listen((time) {
      setState(() {
        _time = time;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Samurai Timer")),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const MeshG(),
            TimerDisplay(time: _time),
          ],
        ),
      ),
      floatingActionButton: StartStopButton(
        isRunning: _timerService.isRunning,
        onPress: () {
          if (_timerService.isRunning) {
            _timerService.stop();
          } else {
            _timerService.start();
          }
        },
      ),
    );
  }
}
