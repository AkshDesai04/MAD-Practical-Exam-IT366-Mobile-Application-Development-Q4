import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/material_list_screen.dart';
import 'src/services/auth_service.dart';

void main() {
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
