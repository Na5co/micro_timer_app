import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 1)
class Achievement extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  bool achieved;

  Achievement({
    required this.title,
    required this.description,
    this.achieved = false,
  });
}
