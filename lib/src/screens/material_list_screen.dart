import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/material_item.dart';
import '../models/user.dart';
import '../providers/material_provider.dart';
import '../services/auth_service.dart';
import 'add_material_screen.dart';
import 'material_detail_screen.dart';
import 'withdrawal_logs_screen.dart';
import 'admin_dashboard_screen.dart';
import '../services/material_service.dart';

final materialServiceProvider = Provider((ref) => MaterialService(ref));

class MaterialListScreen extends ConsumerWidget {
  const MaterialListScreen({super.key});

  Future<void> _exportToCSV(List<MaterialItem> materials, BuildContext context) async {
    try {
      // Create CSV content
      final csvContent = StringBuffer();
      // Add headers
      csvContent.writeln('Name,Description,Stock,Unit Cost,Total Value,Last Updated');
      
      // Add data rows
      for (final material in materials) {
        csvContent.writeln(
          '"${material.name}","${material.description}",'
          '${material.stock},${material.unitCost},'
          '${material.totalValue},"${material.lastUpdated}"'
        );
      }

      // Get the downloads directory
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Could not access downloads directory');
      }

      // Create the file
      final file = File('${directory.path}/material_inventory_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csvContent.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File saved to: ${file.path}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialService = ref.watch(materialServiceProvider);
    final materials = materialService.getAllMaterials();
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Inventory'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          if (currentUser?.username == 'admin' && currentUser?.role == UserRole.admin)
            IconButton(
              icon: const Icon(Icons.dashboard),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen(),
                  ),
                );
              },
              tooltip: 'Dashboard',
            ),
          if (currentUser?.username == 'admin' && currentUser?.role == UserRole.admin)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WithdrawalLogsScreen(),
                  ),
                );
              },
              tooltip: 'View Logs',
            ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final materialsData = await ref.read(materialsProvider.future);
              if (materialsData.isNotEmpty) {
                await _exportToCSV(materialsData, context);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No materials to export'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              }
            },
            tooltip: 'Export to CSV',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authServiceProvider).logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: materials.isEmpty
          ? const Center(
              child: Text('No materials found'),
            )
          : ListView.builder(
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final material = materials[index];
                final isLowStock = material.stock < 10;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: isLowStock ? Colors.red.shade50 : null,
                  child: ListTile(
                    leading: isLowStock
                        ? const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                          )
                        : const Icon(Icons.inventory_2_outlined),
                    title: Text(
                      material.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isLowStock ? Colors.red : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Stock: ${material.stock}',
                          style: TextStyle(
                            color: isLowStock ? Colors.red : null,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Unit Cost: \$${material.unitCost.toStringAsFixed(2)}'),
                        Text(
                          'Total Value: \$${(material.stock * material.unitCost).toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaterialDetailScreen(material: material),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMaterialScreen(),
            ),
          );
          ref.invalidate(materialsProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Material'),
      ),
    );
  }
} 