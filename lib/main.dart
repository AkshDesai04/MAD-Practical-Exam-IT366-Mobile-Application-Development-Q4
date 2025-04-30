import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/models/material_item.dart';
import 'src/models/withdrawal_log.dart';
import 'src/models/addition_log.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/material_list_screen.dart';
import 'src/services/auth_service.dart';

class WithdrawalLogAdapter extends TypeAdapter<WithdrawalLog> {
  @override
  final int typeId = 3;

  @override
  WithdrawalLog read(BinaryReader reader) {
    return WithdrawalLog(
      materialId: reader.read(),
      materialName: reader.read(),
      quantity: reader.read(),
      timestamp: reader.read(),
      username: reader.read(),
      notes: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, WithdrawalLog obj) {
    writer.write(obj.materialId);
    writer.write(obj.materialName);
    writer.write(obj.quantity);
    writer.write(obj.timestamp);
    writer.write(obj.username);
    writer.write(obj.notes);
  }
}

class AdditionLogAdapter extends TypeAdapter<AdditionLog> {
  @override
  final int typeId = 4;

  @override
  AdditionLog read(BinaryReader reader) {
    return AdditionLog(
      materialId: reader.read(),
      materialName: reader.read(),
      quantity: reader.read(),
      timestamp: reader.read(),
      username: reader.read(),
      notes: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, AdditionLog obj) {
    writer.write(obj.materialId);
    writer.write(obj.materialName);
    writer.write(obj.quantity);
    writer.write(obj.timestamp);
    writer.write(obj.username);
    writer.write(obj.notes);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MaterialItemAdapter());
  Hive.registerAdapter(WithdrawalLogAdapter());
  Hive.registerAdapter(AdditionLogAdapter());
  await Hive.openBox<MaterialItem>('materials');
  await Hive.openBox<WithdrawalLog>('withdrawal_logs');
  await Hive.openBox<AdditionLog>('addition_logs');
  runApp(
    const ProviderScope(
      child: MaterialInventoryApp(),
    ),
  );
}

class MaterialInventoryApp extends ConsumerWidget {
  const MaterialInventoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      title: 'Material Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: isAuthenticated
          ? const MaterialListScreen()
          : const LoginScreen(),
    );
  }
}
