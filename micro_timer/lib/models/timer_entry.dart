import 'package:hive/hive.dart';

part 'timer_entry.g.dart';

@HiveType(typeId: 0)
class TimerEntry extends HiveObject {
  @HiveField(0)
  final String duration;

  @HiveField(1)
  final String formattedDate;

  @HiveField(2)
  final String? type;

  TimerEntry(this.duration, this.formattedDate, [this.type]);
}
