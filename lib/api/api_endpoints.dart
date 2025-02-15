// lib/api/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'http://192.168.43.68:3000/api/farm';

  // Chickens
  static String createChickenGroup = '$baseUrl/chickens';
  static String updateChickenGroup(String id) => '$baseUrl/chickens/$id';
  static String getAllChickenGroups = '$baseUrl/chickens';
  static String getChickenGroup(String id) => '$baseUrl/chickens/$id';
  static String getTotalChickenCount = '$baseUrl/chickens/total';
  static String estimateEggProductionForGroup(String groupId) => '$baseUrl/chickens/$groupId/egg-production';
  static String estimateEggProductionForAll = '$baseUrl/chickens/egg-production';

  // Fish
  static String createFishGroup = '$baseUrl/fishes';
  static String updateFishGroup(String id) => '$baseUrl/fishes/$id';
  static String getAllFishGroups = '$baseUrl/fishes';
  static String getFishGroup(String id) => '$baseUrl/fishes/$id';
  static String getTotalFishCount = '$baseUrl/fishes/total';
  static String estimatePriceForFishGroup(String id) => '$baseUrl/fishes/$id/estimate-price';
  static String estimatePriceForAllFishGroups = '$baseUrl/fishes/estimate-price';

  // Pigs
  static String createPigGroup = '$baseUrl/pigs';
  static String updatePigGroup(String id) => '$baseUrl/pigs/$id';
  static String getAllPigGroups = '$baseUrl/pigs';
  static String getPigGroup(String id) => '$baseUrl/pigs/$id';
  static String getTotalPigCount = '$baseUrl/pigs/total';
  static String estimatePriceForPigGroup(String id) => '$baseUrl/pigs/$id/estimate-price';
  static String estimatePriceForAllPigGroups = '$baseUrl/pigs/estimate-price';
}