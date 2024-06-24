import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../services/timer_service.dart';
import '../widgets/timer_display.dart';
import '../widgets/start_stop_button.dart';
import '../widgets/background_container.dart';
import '../widgets/glossy_container.dart';
import '../widgets/quotes_display.dart';
import '../widgets/sound.dart';
import '../models/timer_entry.dart';
import '../widgets/timer_entries.dart';

class HomeScreen extends StatefulWidget {
  final Box<TimerEntry> timerBox;

  const HomeScreen({super.key, required this.timerBox});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TimerService _timerService;
  String _time = "00:00:00";

  @override
  void initState() {
    super.initState();
    _timerService = TimerService(widget.timerBox);
    _timerService.timeStream.listen((time) {
      setState(() {
        _time = time;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Samurai Timer", style: GoogleFonts.lato()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 1),
                  child: QuotesDisplay(width: size.width),
                ),
                SizedBox(height: size.height * 0.08),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GradientBGContainer(
                        height: size.height * 0.2,
                        width: size.width * 0.9,
                      ),
                      GlossMask(
                        height: size.height * 0.15,
                        width: size.width * 0.45,
                      ),
                      TimerDisplay(time: _time),
                    ],
                  ),
                ),
                const SoundButton(),
              ],
            ),
          ),
          Expanded(
            child: EntriesList(timerBox: widget.timerBox),
          ),
          Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
            child: Text(
              "Stay focused, stay humble.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
            ),
          ),
        ],
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

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }
}
