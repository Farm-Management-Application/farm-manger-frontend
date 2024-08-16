class Worker {
  final String id;
  final String name;
  final String role;
  final double salary;
  final DateTime dateOfJoining;
  final String status;
  final DateTime updatedAt;

  Worker({
    required this.id,
    required this.name,
    required this.role,
    required this.salary,
    required this.dateOfJoining,
    required this.status,
    required this.updatedAt,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['_id'],
      name: json['name'],
      role: json['role'],
      salary: json['salary'].toDouble(),
      dateOfJoining: DateTime.parse(json['date_of_joining']),
      status: json['status'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'salary': salary,
      'date_of_joining': dateOfJoining.toIso8601String(),
      'status': status,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}