// lib/models/fish.dart
import 'food_consumption.dart'; // Ensure this import statement is added

class Fish {
  String id;
  String name;
  int totalCount;
  String type;
  FoodConsumption foodConsumption;
  DateTime birthDate;
  DateTime createdAt;
  DateTime modifiedAt;

  Fish({
    required this.id,
    required this.name,
    required this.totalCount,
    required this.type,
    required this.foodConsumption,
    required this.birthDate,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['_id'],
      name: json['name'],
      totalCount: json['totalCount'],
      type: json['type'],
      foodConsumption: FoodConsumption.fromJson(json['foodConsumption']),
      birthDate: DateTime.parse(json['birthDate']),
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalCount': totalCount,
      'type': type,
      'foodConsumption': foodConsumption.toJson(),
      'birthDate': birthDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }
}