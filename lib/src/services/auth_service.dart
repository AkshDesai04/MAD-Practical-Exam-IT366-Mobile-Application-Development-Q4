import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final authServiceProvider = Provider((ref) => AuthService(ref));

class AuthService {
  final Ref _ref;
  User? _currentUser;

  AuthService(this._ref);

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _ref.read(isAuthenticatedProvider);

  Future<bool> login(String username, String password) async {
    // For demo purposes, we'll use a simple check
    if (username == 'admin' && password == 'admin') {
      _currentUser = const User(
        username: 'admin',
        role: UserRole.admin,
      );
      _ref.read(isAuthenticatedProvider.notifier).state = true;
      return true;
    } else if (username == 'operator' && password == 'operator') {
      _currentUser = const User(
        username: 'operator',
        role: UserRole.operator,
      );
      _ref.read(isAuthenticatedProvider.notifier).state = true;
      return true;
    }
    return false;
  }

  void logout() {
    _ref.read(isAuthenticatedProvider.notifier).state = false;
    _currentUser = null;
  }
}

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authServiceProvider).currentUser;
}); 