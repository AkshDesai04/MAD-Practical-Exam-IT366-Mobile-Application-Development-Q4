import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/material_item.dart';
import '../providers/material_provider.dart';

class EditMaterialScreen extends ConsumerStatefulWidget {
  final MaterialItem material;

  const EditMaterialScreen({super.key, required this.material});

  @override
  ConsumerState<EditMaterialScreen> createState() => _EditMaterialScreenState();
}

class _EditMaterialScreenState extends ConsumerState<EditMaterialScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _unitCostController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.material.name);
    _unitCostController = TextEditingController(text: widget.material.unitCost.toString());
    _stockController = TextEditingController(text: widget.material.stock.toString());
    _descriptionController = TextEditingController(text: widget.material.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitCostController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _unitCostController,
              decoration: const InputDecoration(labelText: 'Unit Cost'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final repository = ref.read(materialRepositoryProvider);
                final updatedMaterial = widget.material.copyWith(
                  name: _nameController.text,
                  unitCost: double.tryParse(_unitCostController.text) ?? widget.material.unitCost,
                  stock: int.tryParse(_stockController.text) ?? widget.material.stock,
                  description: _descriptionController.text,
                );
                await repository.updateMaterial(updatedMaterial);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
} 