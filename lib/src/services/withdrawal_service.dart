import 'package:hive_flutter/hive_flutter.dart';
import '../models/withdrawal_log.dart';

class WithdrawalService {
  final Box<WithdrawalLog> _withdrawalBox = Hive.box<WithdrawalLog>('withdrawal_logs');

  Future<void> addWithdrawal(WithdrawalLog withdrawal) async {
    await _withdrawalBox.add(withdrawal);
  }

  List<WithdrawalLog> getAllWithdrawals() {
    return _withdrawalBox.values.toList();
  }

  List<WithdrawalLog> getWithdrawalsByMaterialId(String materialId) {
    return _withdrawalBox.values
        .where((log) => log.materialId == materialId)
        .toList();
  }

  Future<void> deleteWithdrawal(WithdrawalLog withdrawal) async {
    final key = _withdrawalBox.keyAt(_withdrawalBox.values.toList().indexOf(withdrawal));
    await _withdrawalBox.delete(key);
  }
} 