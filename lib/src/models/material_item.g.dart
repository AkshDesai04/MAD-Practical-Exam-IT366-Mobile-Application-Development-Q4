// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialItemAdapter extends TypeAdapter<MaterialItem> {
  @override
  final int typeId = 0;

  @override
  MaterialItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialItem(
      id: fields[0] as String?,
      name: fields[1] as String,
      unitCost: fields[2] as double,
      stock: fields[3] as int,
      description: fields[5] as String,
      lastUpdated: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MaterialItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unitCost)
      ..writeByte(3)
      ..write(obj.stock)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
