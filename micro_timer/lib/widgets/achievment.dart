import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/achievement.dart';

class AchievementsList extends StatelessWidget {
  final Box<Achievement> achievementBox;

  const AchievementsList({super.key, required this.achievementBox});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: achievementBox.listenable(),
      builder: (context, Box<Achievement> box, _) {
        if (box.values.isEmpty) {
          return const Center(
            child: Text('No achievements yet.'),
          );
        } else {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Achievement achievement = box.getAt(index)!;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(
                    achievement.achieved ? Icons.emoji_events : Icons.lock,
                    color: achievement.achieved ? Colors.amber : Colors.grey,
                  ),
                  title: Text(
                    achievement.title,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    achievement.description,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
