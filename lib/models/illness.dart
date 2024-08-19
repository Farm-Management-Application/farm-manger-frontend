class Illness {
  final String id;
  final String livestockId;
  final String livestockType;
  final String illnessDescription;
  final double treatmentCost;
  final int affectedCount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Illness({
    required this.id,
    required this.livestockId,
    required this.livestockType,
    required this.illnessDescription,
    required this.treatmentCost,
    required this.affectedCount,
    required this.startDate,
    this.endDate,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Illness.fromJson(Map<String, dynamic> json) {
    return Illness(
      id: json['_id'],
      livestockId: json['livestockId'],
      livestockType: json['livestockType'],
      illnessDescription: json['illnessDescription'],
      treatmentCost: json['treatmentCost'].toDouble(),
      affectedCount: json['affectedCount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'livestockId': livestockId,
      'livestockType': livestockType,
      'illnessDescription': illnessDescription,
      'treatmentCost': treatmentCost,
      'affectedCount': affectedCount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };

    // Only add the _id field if it's not empty
    if (id.isNotEmpty) {
      data['_id'] = id;
    }

    return data;
  }
}