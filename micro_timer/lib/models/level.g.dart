// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelAdapter extends TypeAdapter<Level> {
  @override
  final int typeId = 2;

  @override
  Level read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Level(
      currentLevel: fields[0] as int,
      currentExperience: fields[1] as int,
      currentCharacter: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Level obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.currentLevel)
      ..writeByte(1)
      ..write(obj.currentExperience)
      ..writeByte(2)
      ..write(obj.currentCharacter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
