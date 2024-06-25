import 'package:hive/hive.dart';

part 'timer_entry.g.dart';

@HiveType(typeId: 0)
class TimerEntry extends HiveObject {
  @HiveField(0)
  final int durationInSeconds;
  @HiveField(1)
  final String formattedDate;
  @HiveField(2)
  final String type;

  TimerEntry(this.durationInSeconds, this.formattedDate, this.type);

  String get formattedDuration {
    final hours = durationInSeconds ~/ 3600;
    final minutes = (durationInSeconds % 3600) ~/ 60;
    final seconds = durationInSeconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
