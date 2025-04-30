import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/withdrawal_log.dart';
import '../services/withdrawal_service.dart';

final withdrawalServiceProvider = Provider((ref) => WithdrawalService());

class WithdrawalLogScreen extends ConsumerWidget {
  const WithdrawalLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawalService = ref.watch(withdrawalServiceProvider);
    final withdrawals = withdrawalService.getAllWithdrawals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Logs'),
      ),
      body: withdrawals.isEmpty
          ? const Center(
              child: Text('No withdrawal logs found'),
            )
          : ListView.builder(
              itemCount: withdrawals.length,
              itemBuilder: (context, index) {
                final withdrawal = withdrawals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      withdrawal.materialName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Material ID: ${withdrawal.materialId}'),
                        Text('Quantity: ${withdrawal.quantity}'),
                        Text('Date: ${withdrawal.date}'),
                        Text('User: ${withdrawal.username}'),
                        if (withdrawal.notes.isNotEmpty)
                          Text('Notes: ${withdrawal.notes}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await withdrawalService.deleteWithdrawal(withdrawal);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
} 