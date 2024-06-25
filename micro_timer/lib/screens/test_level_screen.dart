import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../models/level.dart';
import '../widgets/asset_loaders/character_animation.dart';
import '../constants.dart';

class TestLevelScreen extends StatefulWidget {
  final Box<Level> levelBox;

  const TestLevelScreen({Key? key, required this.levelBox}) : super(key: key);

  @override
  _TestLevelScreenState createState() => _TestLevelScreenState();
}

class _TestLevelScreenState extends State<TestLevelScreen> {
  late Level _level;

  @override
  void initState() {
    super.initState();
    _level = widget.levelBox.get(0) ??
        Level(currentLevel: 0, currentExperience: 0, currentCharacter: 'Egg');
    widget.levelBox.put(0, _level); // Ensure a default level is available
  }

  void _gainExperience(int points) {
    setState(() {
      _level.currentExperience += points;
      while (_level.currentExperience >=
          kExperiencePoints[_level.currentLevel + 1]!) {
        _level.currentExperience -= kExperiencePoints[_level.currentLevel + 1]!;
        _level.currentLevel += 1;
        _level.currentCharacter = kCharacters[_level.currentLevel] ?? 'Egg';
      }
      _level.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Level Animations", style: GoogleFonts.lato()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CharacterAnimation(
              width: 200,
              height: 200,
              character: _level.currentCharacter,
            ),
            SizedBox(height: 20),
            Text(
              'Current Level: ${_level.currentLevel}',
              style:
                  GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Current Character: ${_level.currentCharacter}',
              style:
                  GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            Text(
              'Current Experience: ${_level.currentExperience}',
              style:
                  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _gainExperience(900), // Gain 900 experience points
              child: Text("Gain 900 XP"),
            ),
            ElevatedButton(
              onPressed: () =>
                  _gainExperience(7200), // Gain 7200 experience points
              child: Text("Gain 7200 XP"),
            ),
          ],
        ),
      ),
    );
  }
}
