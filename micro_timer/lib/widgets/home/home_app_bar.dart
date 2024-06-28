import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAchievementsPressed;
  final VoidCallback onHistoryPressed;

  const HomeAppBar({
    Key? key,
    required this.onAchievementsPressed,
    required this.onHistoryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Pomodo Samurai", style: GoogleFonts.lato()),
      backgroundColor: Colors.transparent,
      elevation: 0,
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
