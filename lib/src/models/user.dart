enum UserRole {
  admin,
  operator,
}

class User {
  final String username;
  final String password;
  final UserRole role;

  const User({
    required this.username,
    required this.password,
    required this.role,
  });

  bool get canAddMaterials => true;
  bool get canEditMaterials => role == UserRole.admin;
  bool get canDeleteMaterials => role == UserRole.admin;
} 