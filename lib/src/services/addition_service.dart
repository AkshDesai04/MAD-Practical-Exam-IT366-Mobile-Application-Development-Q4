import 'package:hive_flutter/hive_flutter.dart';
import '../models/addition_log.dart';

class AdditionService {
  final Box<AdditionLog> _additionBox = Hive.box<AdditionLog>('addition_logs');

  Future<void> addAddition(AdditionLog addition) async {
    await _additionBox.add(addition);
  }

  List<AdditionLog> getAllAdditions() {
    return _additionBox.values.toList();
  }

  List<AdditionLog> getAdditionsByMaterialId(String materialId) {
    return _additionBox.values
        .where((log) => log.materialId == materialId)
        .toList();
  }

  Future<void> deleteAddition(AdditionLog addition) async {
    final key = _additionBox.keyAt(_additionBox.values.toList().indexOf(addition));
    await _additionBox.delete(key);
  }
} 