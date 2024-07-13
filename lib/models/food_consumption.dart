// lib/models/food_consumption.dart
class FoodConsumption {
  int sacks;
  double pricePerSack;

  FoodConsumption({
    required this.sacks,
    required this.pricePerSack,
  });

  factory FoodConsumption.fromJson(Map<String, dynamic> json) {
    return FoodConsumption(
      sacks: json['sacks'],
      pricePerSack: json['pricePerSack'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sacks': sacks,
      'pricePerSack': pricePerSack,
    };
  }
}