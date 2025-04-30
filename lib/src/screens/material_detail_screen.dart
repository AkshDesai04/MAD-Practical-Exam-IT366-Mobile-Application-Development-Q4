import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/material_item.dart';
import '../providers/material_provider.dart';
import 'edit_material_screen.dart';

class MaterialDetailScreen extends ConsumerWidget {
  final MaterialItem material;

  const MaterialDetailScreen({super.key, required this.material});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(material.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMaterialScreen(material: material),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(material.description),
            const SizedBox(height: 16),
            Text(
              'Stock Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Current Stock: ${material.stock}'),
            Text('Unit Cost: \$${material.unitCost.toStringAsFixed(2)}'),
            Text('Total Value: \$${material.totalValue.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(
              'Last Updated',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(material.lastUpdated.toString()),
          ],
        ),
      ),
    );
  }
} 