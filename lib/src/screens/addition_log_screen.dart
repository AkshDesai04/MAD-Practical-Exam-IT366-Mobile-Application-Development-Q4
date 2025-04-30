import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/addition_log.dart';
import '../services/addition_service.dart';

final additionServiceProvider = Provider((ref) => AdditionService());

class AdditionLogScreen extends ConsumerWidget {
  const AdditionLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final additionService = ref.watch(additionServiceProvider);
    final additions = additionService.getAllAdditions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addition Logs'),
      ),
      body: additions.isEmpty
          ? const Center(
              child: Text('No addition logs found'),
            )
          : ListView.builder(
              itemCount: additions.length,
              itemBuilder: (context, index) {
                final addition = additions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      addition.materialName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Material ID: ${addition.materialId}'),
                        Text('Quantity Added: ${addition.quantity}'),
                        Text('Date: ${addition.date}'),
                        Text('User: ${addition.username}'),
                        if (addition.notes.isNotEmpty)
                          Text('Notes: ${addition.notes}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await additionService.deleteAddition(addition);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
} 