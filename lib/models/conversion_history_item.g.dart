// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversionHistoryItemAdapter extends TypeAdapter<ConversionHistoryItem> {
  @override
  final typeId = 0;

  @override
  ConversionHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversionHistoryItem(
      id: fields[0] as String,
      toolId: fields[1] as String,
      toolTitle: fields[2] as String,
      inputName: fields[3] as String,
      outputPath: fields[4] as String,
      createdAt: fields[5] as DateTime,
      sizeBytes: (fields[6] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ConversionHistoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.toolId)
      ..writeByte(2)
      ..write(obj.toolTitle)
      ..writeByte(3)
      ..write(obj.inputName)
      ..writeByte(4)
      ..write(obj.outputPath)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.sizeBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
