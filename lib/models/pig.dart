class Pig {
  String id;
  String name;
  int totalCount;
  String type;
  DateTime birthDate;
  DateTime createdAt;
  DateTime modifiedAt;

  Pig({
    required this.id,
    required this.name,
    required this.totalCount,
    required this.type,
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
      'birthDate': birthDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }
}