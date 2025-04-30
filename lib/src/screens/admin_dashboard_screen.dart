import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/material_item.dart';
import '../models/addition_log.dart';
import '../models/withdrawal_log.dart';
import '../services/material_service.dart';
import '../services/auth_service.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialService = ref.watch(materialServiceProvider);
    final materials = materialService.getAllMaterials();
    final additions = Hive.box<AdditionLog>('addition_logs').values.toList();
    final withdrawals = Hive.box<WithdrawalLog>('withdrawal_logs').values.toList();

    // Calculate statistics
    final totalValue = materials.fold<double>(
      0,
      (sum, material) => sum + (material.stock * material.unitCost),
    );
    final lowStockItems = materials.where((m) => m.stock < 10).length;
    final totalItems = materials.fold<int>(0, (sum, material) => sum + material.stock);
    final recentAdditions = additions.take(5).toList();
    final recentWithdrawals = withdrawals.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Inventory Value',
                    value: '\$${totalValue.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    title: 'Low Stock Items',
                    value: lowStockItems.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Items',
                    value: totalItems.toString(),
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Materials',
                    value: materials.length.toString(),
                    icon: Icons.category,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Recent Activity
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Recent Additions
            _ActivitySection(
              title: 'Recent Additions',
              icon: Icons.add_circle,
              color: Colors.green,
              items: recentAdditions.map((log) => _ActivityItem(
                title: log.materialName,
                subtitle: 'Added ${log.quantity} units',
                timestamp: log.timestamp,
                username: log.username,
              )).toList(),
            ),
            const SizedBox(height: 16),
            
            // Recent Withdrawals
            _ActivitySection(
              title: 'Recent Withdrawals',
              icon: Icons.remove_circle,
              color: Colors.red,
              items: recentWithdrawals.map((log) => _ActivityItem(
                title: log.materialName,
                subtitle: 'Withdrawn ${log.quantity} units',
                timestamp: log.timestamp,
                username: log.username,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivitySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_ActivityItem> items;

  const _ActivitySection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No recent activity'),
                ),
              )
            else
              ...items,
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String username;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(subtitle),
          Text(
            'By $username on ${timestamp.toString().split('.')[0]}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
} 