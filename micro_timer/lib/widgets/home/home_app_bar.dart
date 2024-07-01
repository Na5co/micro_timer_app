import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:micro_timer/widgets/asset_loaders/sound.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAchievementsPressed;
  final VoidCallback onHistoryPressed;

  const HomeAppBar({
    Key? key,
    required this.onAchievementsPressed,
    required this.onHistoryPressed,
    required List<SoundButton> actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Pomodomon", style: GoogleFonts.lato()),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.emoji_events),
          tooltip: 'Achievements',
          onPressed: onAchievementsPressed,
        ),
        IconButton(
          icon: const Icon(Icons.history),
          tooltip: 'View History',
          onPressed: onHistoryPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
