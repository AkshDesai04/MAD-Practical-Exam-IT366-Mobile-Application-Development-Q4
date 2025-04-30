import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/withdrawal_log.dart';

final withdrawalLogRepositoryProvider = Provider<WithdrawalLogRepository>((ref) {
  return WithdrawalLogRepository();
});

final withdrawalLogsProvider = FutureProvider<List<WithdrawalLog>>((ref) async {
  final repository = ref.watch(withdrawalLogRepositoryProvider);
  return repository.getLogs();
});

class WithdrawalLogRepository {
  static const _boxName = 'withdrawal_logs';

  Future<List<WithdrawalLog>> getLogs() async {
    final box = await Hive.openBox<WithdrawalLog>(_boxName);
    return box.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> addLog(WithdrawalLog log) async {
    final box = await Hive.openBox<WithdrawalLog>(_boxName);
    await box.add(log);
  }
} 