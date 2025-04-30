import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/material_item.dart';
import '../providers/material_provider.dart';
import 'add_material_screen.dart';
import 'material_detail_screen.dart';

class MaterialListScreen extends ConsumerWidget {
  const MaterialListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materials = ref.watch(materialsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials'),
      ),
      body: materials.when(
        data: (materials) {
          if (materials.isEmpty) {
            return const Center(
              child: Text('No materials found. Add some materials to get started.'),
            );
          }

          return ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return ListTile(
                title: Text(material.name),
                subtitle: Text('Stock: ${material.stock} | Total Value: \$${material.totalValue.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaterialDetailScreen(material: material),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMaterialScreen(),
            ),
          );
          // Refresh the materials list after returning from add screen
          ref.invalidate(materialsProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 