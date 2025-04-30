import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/material_item.dart';
import '../models/addition_log.dart';
import '../models/withdrawal_log.dart';
import '../services/auth_service.dart';

final materialServiceProvider = Provider((ref) => MaterialService(ref));

class MaterialService {
  final Ref _ref;
  final Box<MaterialItem> _materialBox = Hive.box<MaterialItem>('materials');
  final Box<AdditionLog> _additionBox = Hive.box<AdditionLog>('addition_logs');
  final Box<WithdrawalLog> _withdrawalBox = Hive.box<WithdrawalLog>('withdrawal_logs');

  MaterialService(this._ref);

  Future<void> addMaterial(MaterialItem material) async {
    await _materialBox.add(material);
    // Log the addition
    final currentUser = _ref.read(authServiceProvider).currentUser;
    if (currentUser != null) {
      final additionLog = AdditionLog(
        materialId: material.id,
        materialName: material.name,
        quantity: material.stock,
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
    
    if (oldMaterial != null && oldMaterial.stock != material.stock) {
      final quantityDifference = material.stock - oldMaterial.stock;
      if (quantityDifference > 0) {
        // Log the addition
        final currentUser = _ref.read(authServiceProvider).currentUser;
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

  Future<bool> withdrawMaterial(MaterialItem material, int quantity, String notes) async {
    if (quantity <= 0 || quantity > material.stock) {
      return false;
    }

    final key = _materialBox.keyAt(_materialBox.values.toList().indexOf(material));
    final updatedMaterial = MaterialItem(
      id: material.id,
      name: material.name,
      description: material.description,
      stock: material.stock - quantity,
      unitCost: material.unitCost,
      lastUpdated: DateTime.now(),
    );

    // Update the material stock
    await _materialBox.put(key, updatedMaterial);

    // Log the withdrawal
    final currentUser = _ref.read(authServiceProvider).currentUser;
    if (currentUser != null) {
      final withdrawalLog = WithdrawalLog(
        materialId: material.id,
        materialName: material.name,
        quantity: quantity,
        timestamp: DateTime.now(),
        username: currentUser.username,
        notes: notes,
      );
      await _withdrawalBox.add(withdrawalLog);
    }

    return true;
  }

  List<MaterialItem> getAllMaterials() {
    return _materialBox.values.toList();
  }

  Future<void> deleteMaterial(MaterialItem material) async {
    final key = _materialBox.keyAt(_materialBox.values.toList().indexOf(material));
    await _materialBox.delete(key);
  }
} 