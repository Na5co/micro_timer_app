// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerEntryAdapter extends TypeAdapter<TimerEntry> {
  @override
  final int typeId = 0;

  @override
  TimerEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerEntry(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimerEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.durationInSeconds)
      ..writeByte(1)
      ..write(obj.formattedDate)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
