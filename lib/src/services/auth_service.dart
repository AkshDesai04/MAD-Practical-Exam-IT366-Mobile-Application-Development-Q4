import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

class AuthService {
  final Ref _ref;

  AuthService(this._ref);

  static const List<User> _users = [
    User(
      username: 'admin',
      password: 'admin',
      role: UserRole.admin,
    ),
    User(
      username: 'operator',
      password: 'operator',
      role: UserRole.operator,
    ),
  ];

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _ref.read(isAuthenticatedProvider);

  Future<bool> login(String username, String password) async {
    final user = _users.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    
    _currentUser = user;
    _ref.read(isAuthenticatedProvider.notifier).state = true;
    return true;
  }

  void logout() {
    _ref.read(isAuthenticatedProvider.notifier).state = false;
    _currentUser = null;
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authServiceProvider).currentUser;
}); 