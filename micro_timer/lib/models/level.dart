import 'package:hive/hive.dart';

part 'level.g.dart';

@HiveType(typeId: 2)
class Level extends HiveObject {
  @HiveField(0)
  int currentLevel;

  @HiveField(1)
  int currentExperience;

  @HiveField(2)
  String currentCharacter;

  Level({
    required this.currentLevel,
    required this.currentExperience,
    required this.currentCharacter,
  });
}
