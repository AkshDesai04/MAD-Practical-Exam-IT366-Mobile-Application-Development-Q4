import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/withdrawal_log_provider.dart';

class WithdrawalLogsScreen extends ConsumerWidget {
  const WithdrawalLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(withdrawalLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Logs'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: logs.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: Text('No withdrawal logs found'),
            );
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(log.materialName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${log.quantity}'),
                      Text('User: ${log.username}'),
                      Text('Time: ${log.timestamp.toString()}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading logs: $error'),
        ),
      ),
    );
  }
} 