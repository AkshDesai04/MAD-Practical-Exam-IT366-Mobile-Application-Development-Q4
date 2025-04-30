import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/material_item.dart';

class CsvMaterialRepository {
  static const String _fileName = 'materials.csv';
  File? _file;

  Future<File> _getFile() async {
    if (_file == null) {
      final directory = await getApplicationDocumentsDirectory();
      _file = File('${directory.path}/$_fileName');
      if (!await _file!.exists()) {
        await _file!.writeAsString('id,name,unitCost,stock,description,lastUpdated\n');
      }
    }
    return _file!;
  }

  Future<List<MaterialItem>> getAllMaterials() async {
    final file = await _getFile();
    final lines = await file.readAsLines();
    if (lines.length <= 1) return []; // Skip header

    return lines.skip(1).map((line) {
      final values = line.split(',');
      return MaterialItem(
        id: values[0],
        name: values[1],
        unitCost: double.parse(values[2]),
        stock: int.parse(values[3]),
        description: values[4],
        lastUpdated: DateTime.parse(values[5]),
      );
    }).toList();
  }

  Future<MaterialItem?> getMaterial(String id) async {
    final materials = await getAllMaterials();
    try {
      return materials.firstWhere((material) => material.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addMaterial(MaterialItem material) async {
    final file = await _getFile();
    final line = '${material.id},${material.name},${material.unitCost},${material.stock},${material.description},${material.lastUpdated.toIso8601String()}\n';
    await file.writeAsString(line, mode: FileMode.append);
  }

  Future<void> updateMaterial(MaterialItem material) async {
    final file = await _getFile();
    final materials = await getAllMaterials();
    final index = materials.indexWhere((m) => m.id == material.id);
    if (index != -1) {
      materials[index] = material;
      final header = 'id,name,unitCost,stock,description,lastUpdated\n';
      final lines = materials.map((m) => '${m.id},${m.name},${m.unitCost},${m.stock},${m.description},${m.lastUpdated.toIso8601String()}').join('\n');
      await file.writeAsString('$header$lines\n');
    }
  }

  Future<void> deleteMaterial(String id) async {
    final file = await _getFile();
    final materials = await getAllMaterials();
    materials.removeWhere((material) => material.id == id);
    final header = 'id,name,unitCost,stock,description,lastUpdated\n';
    final lines = materials.map((m) => '${m.id},${m.name},${m.unitCost},${m.stock},${m.description},${m.lastUpdated.toIso8601String()}').join('\n');
    await file.writeAsString('$header$lines\n');
  }
} 