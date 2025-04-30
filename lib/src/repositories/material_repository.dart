import 'package:hive_flutter/hive_flutter.dart';
import '../models/material_item.dart';

class MaterialRepository {
  final Box<MaterialItem> _box;

  MaterialRepository(this._box);

  Future<List<MaterialItem>> getAllMaterials() async {
    return _box.values.toList();
  }

  Future<MaterialItem?> getMaterial(String id) async {
    return _box.get(id);
  }

  Future<void> addMaterial(MaterialItem material) async {
    await _box.put(material.id, material);
  }

  Future<void> updateMaterial(MaterialItem material) async {
    await _box.put(material.id, material);
  }

  Future<void> deleteMaterial(String id) async {
    await _box.delete(id);
  }

  Future<void> updateStock(String id, int newStock) async {
    final material = await getMaterial(id);
    if (material != null) {
      await updateMaterial(material.copyWith(stock: newStock));
    }
  }
} 