import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'material_item.g.dart';

@HiveType(typeId: 0)
class MaterialItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double unitCost;

  @HiveField(3)
  int stock;

  @HiveField(4)
  DateTime lastUpdated;

  @HiveField(5)
  String description;

  MaterialItem({
    String? id,
    required this.name,
    required this.unitCost,
    required this.stock,
    required this.description,
    DateTime? lastUpdated,
  }) : id = id ?? const Uuid().v4(),
       lastUpdated = lastUpdated ?? DateTime.now();

  MaterialItem copyWith({
    String? name,
    double? unitCost,
    int? stock,
    String? description,
    DateTime? lastUpdated,
  }) {
    return MaterialItem(
      id: id,
      name: name ?? this.name,
      unitCost: unitCost ?? this.unitCost,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  double get totalValue => unitCost * stock;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitCost': unitCost,
      'stock': stock,
      'description': description,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      id: json['id'] as String,
      name: json['name'] as String,
      unitCost: (json['unitCost'] as num).toDouble(),
      stock: json['stock'] as int,
      description: json['description'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
} 