import 'package:hive/hive.dart';

@HiveType(typeId: 2)
enum UserRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  operator,
}

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final UserRole role;

  const User({
    required this.username,
    required this.role,
  });

  bool get canAddMaterials => true;
  bool get canEditMaterials => role == UserRole.admin;
  bool get canDeleteMaterials => role == UserRole.admin;
} 