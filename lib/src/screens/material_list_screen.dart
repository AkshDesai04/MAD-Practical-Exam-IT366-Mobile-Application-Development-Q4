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
    final materials = ref.watch(materialsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Inventory'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
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
      body: materials.when(
        data: (materials) {
          if (materials.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No materials found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add some materials to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return Slidable(
                endActionPane: currentUser?.username == 'admin' && currentUser?.role == UserRole.admin
                    ? ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              final repository = ref.read(materialRepositoryProvider);
                              await repository.deleteMaterial(material.id);
                              ref.invalidate(materialsProvider);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      )
                    : null,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      material.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stock: ${material.stock}'),
                        Text('Total Value: \$${material.totalValue.toStringAsFixed(2)}'),
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
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading materials',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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