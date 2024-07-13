// lib/models/pig.dart
import 'food_consumption.dart';

class Pig {
  String id;
  String name;
  int totalCount;
  String type;
  FoodConsumption foodConsumption;
  DateTime birthDate;
  DateTime createdAt;
  DateTime modifiedAt;

  Pig({
    required this.id,
    required this.name,
    required this.totalCount,
    required this.type,
    required this.foodConsumption,
    required this.birthDate,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Pig.fromJson(Map<String, dynamic> json) {
    return Pig(
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