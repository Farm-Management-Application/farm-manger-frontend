// lib/services/chicken_service.dart
import 'dart:convert';
import '../models/chicken.dart';
import '../api/api_endpoints.dart';
import '../api/api_request.dart';

class ChickenService {
  Future<List<Chicken>> getAllChickenGroups() async {
    final response = await apiRequest(ApiEndpoints.getAllChickenGroups, 'GET');

    if (response != null && response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Chicken.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chicken groups');
    }
  }

  Future<Chicken> getChickenGroup(String id) async {
    final response = await apiRequest(ApiEndpoints.getChickenGroup(id), 'GET');

    if (response != null && response.statusCode == 200) {
      return Chicken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load chicken group');
    }
  }

  Future<Chicken> createChickenGroup(Chicken chicken) async {
    final response = await apiRequest(ApiEndpoints.createChickenGroup, 'POST', body: chicken.toJson());

    if (response != null && response.statusCode == 201) {
      return Chicken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create chicken group');
    }
  }

Future<Chicken> updateChickenGroup(String id, Chicken chicken) async {
  final response = await apiRequest(ApiEndpoints.updateChickenGroup(id), 'PUT', body: chicken.toUpdateJson());

  print('Request URL: ${ApiEndpoints.updateChickenGroup(id)}');
  print('Request Body: ${jsonEncode(chicken.toUpdateJson())}');
  print('Response: ${response?.body}');

  if (response != null && response.statusCode == 200) {
    return Chicken.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update chicken group');
  }
}


  Future<int> getTotalChickenCount() async {
    final response = await apiRequest(ApiEndpoints.getTotalChickenCount, 'GET');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body)['totalChickens'];
    } else {
      throw Exception('Failed to load total chicken count');
    }
  }

  Future<dynamic> estimateEggProductionForGroup(String groupId, Map<String, dynamic> data) async {
    final response = await apiRequest(ApiEndpoints.estimateEggProductionForGroup(groupId), 'POST', body: data);

    if (response != null && response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to estimate egg production');
    }
  }

  Future<dynamic> estimateEggProductionForAll(Map<String, dynamic> data) async {
    final response = await apiRequest(ApiEndpoints.estimateEggProductionForAll, 'POST', body: data);

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to estimate egg production');
    }
  }
}