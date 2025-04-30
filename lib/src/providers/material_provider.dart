import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/material_item.dart';
import '../repositories/csv_material_repository.dart';

final materialRepositoryProvider = Provider<CsvMaterialRepository>((ref) {
  return CsvMaterialRepository();
});

final materialsProvider = FutureProvider<List<MaterialItem>>((ref) async {
  final repository = ref.watch(materialRepositoryProvider);
  return await repository.getAllMaterials();
});

final materialProvider = FutureProvider.family<MaterialItem?, String>((ref, id) async {
  final repository = ref.watch(materialRepositoryProvider);
  return await repository.getMaterial(id);
}); 