class Chicken {
  String id;
  String title;
  int totalCount;
  DateTime birthDate;
  DateTime createdAt;
  DateTime modifiedAt;

  Chicken({
    required this.id,
    required this.title,
    required this.totalCount,
    required this.birthDate,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Chicken.fromJson(Map<String, dynamic> json) {
    return Chicken(
      id: json['_id'],
      title: json['title'],
      totalCount: json['totalCount'],
      birthDate: DateTime.parse(json['birthDate']),
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalCount': totalCount,
      'birthDate': birthDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'totalCount': totalCount,
      'birthDate': birthDate.toIso8601String(),
    };
  }
}