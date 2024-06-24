import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/timer_entry.dart';

class EntriesList extends StatelessWidget {
  final Box<TimerEntry> timerBox;

  const EntriesList({Key? key, required this.timerBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: timerBox.listenable(),
      builder: (context, Box<TimerEntry> box, _) {
        if (box.values.isEmpty) {
          return const Center(
            child: Text('No entries yet.'),
          );
        } else {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              TimerEntry entry = box.getAt(index)!;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: _getIconForType(entry.type),
                  title: Text(
                    entry.duration,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    entry.formattedDate,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: const Icon(Icons.more_vert),
                ),
              );
            },
          );
        }
      },
    );
  }

  Icon _getIconForType(String? type) {
    switch (type) {
      case 'work':
        return const Icon(Icons.work, color: Colors.blue);
      case 'exercise':
        return const Icon(Icons.fitness_center, color: Colors.green);
      case 'study':
        return const Icon(Icons.book, color: Colors.orange);
      case 'leisure':
        return const Icon(Icons.music_note, color: Colors.purple);
      default:
        return const Icon(Icons.timer, color: Colors.grey);
    }
  }
}
