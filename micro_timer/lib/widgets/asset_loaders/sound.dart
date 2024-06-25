import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundButton extends StatefulWidget {
  const SoundButton({Key? key}) : super(key: key);

  @override
  _SoundButtonState createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _sounds = [
    'sounds/alex_productions_spirit.mp3',
    'sounds/artificial_music_addicted.mp3',
    'sounds/glitch_shinkansen_2_1.mp3',
    'sounds/glitch_shinkansen_2.mp3',
    'sounds/keys_of_moon_yugen.mp3',
    'sounds/punch_deck_808_lotus.mp3',
    'sounds/sappheiros_willow.mp3',
    'sounds/scott_buckley_sleep.mp3',
    'sounds/solas_composer_timeless_one.mp3',
    'sounds/yoitrax_ronin.mp3',
  ];

  bool _isPlaying = false;

  void _playRandomSound() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      final randomIndex = Random().nextInt(_sounds.length);
      final randomSound = _sounds[randomIndex];
      await _audioPlayer.play(AssetSource(randomSound), volume: 1.0);
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isPlaying ? Icons.music_off : Icons.music_note),
      tooltip: _isPlaying ? 'Stop Sound' : 'Play Random Sound',
      onPressed: _playRandomSound,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
