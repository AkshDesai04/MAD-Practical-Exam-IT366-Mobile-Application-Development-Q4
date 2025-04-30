import 'package:hive_flutter/hive_flutter.dart';
import '../models/material_item.dart';
import '../models/addition_log.dart';
import '../services/auth_service.dart';

class MaterialService {
  final Box<MaterialItem> _materialBox = Hive.box<MaterialItem>('materials');
  final Box<AdditionLog> _additionBox = Hive.box<AdditionLog>('addition_logs');

  Future<void> addMaterial(MaterialItem material) async {
    await _materialBox.add(material);
    // Log the addition
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      final additionLog = AdditionLog(
        materialId: material.id,
        materialName: material.name,
        quantity: material.quantity,
        timestamp: DateTime.now(),
        username: currentUser.username,
        notes: 'Initial stock addition',
      );
      await _additionBox.add(additionLog);
    }
  }

  Future<void> updateMaterial(MaterialItem material) async {
    final key = _materialBox.keyAt(_materialBox.values.toList().indexOf(material));
    final oldMaterial = _materialBox.get(key);
    
    if (oldMaterial != null && oldMaterial.quantity != material.quantity) {
      final quantityDifference = material.quantity - oldMaterial.quantity;
      if (quantityDifference > 0) {
        // Log the addition
        final currentUser = AuthService.currentUser;
        if (currentUser != null) {
          final additionLog = AdditionLog(
            materialId: material.id,
            materialName: material.name,
            quantity: quantityDifference,
            timestamp: DateTime.now(),
            username: currentUser.username,
            notes: 'Stock update',
          );
          await _additionBox.add(additionLog);
        }
      }
    }
    
    await _materialBox.put(key, material);
  }

  List<MaterialItem> getAllMaterials() {
    return _materialBox.values.toList();
  }

  Future<void> deleteMaterial(MaterialItem material) async {
    final key = _materialBox.keyAt(_materialBox.values.toList().indexOf(material));
    await _materialBox.delete(key);
  }
} 