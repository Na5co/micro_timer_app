import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/timer_entry.dart';
import '../widgets/timer_entries.dart';

class EntriesScreen extends StatelessWidget {
  final Box<TimerEntry> timerBox;

  const EntriesScreen({Key? key, required this.timerBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: EntriesList(timerBox: timerBox),
    );
  }
}
