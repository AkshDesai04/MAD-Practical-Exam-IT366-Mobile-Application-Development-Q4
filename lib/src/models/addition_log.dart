import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class AdditionLog extends HiveObject {
  @HiveField(0)
  final String materialId;

  @HiveField(1)
  final String materialName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String username;

  @HiveField(5)
  final String notes;

  AdditionLog({
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.timestamp,
    required this.username,
    this.notes = '',
  });

  String get date => '${timestamp.day}/${timestamp.month}/${timestamp.year}';

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'materialName': materialName,
      'quantity': quantity,
      'timestamp': timestamp.toIso8601String(),
      'username': username,
      'notes': notes,
    };
  }

  factory AdditionLog.fromJson(Map<String, dynamic> json) {
    return AdditionLog(
      materialId: json['materialId'],
      materialName: json['materialName'],
      quantity: json['quantity'],
      timestamp: DateTime.parse(json['timestamp']),
      username: json['username'],
      notes: json['notes'] ?? '',
    );
  }
} 