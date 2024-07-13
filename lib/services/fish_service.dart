// lib/services/fish_service.dart
import 'dart:convert';
import '../models/fish.dart';
import '../api/api_endpoints.dart';
import '../api/api_request.dart';

class FishService {
  Future<List<Fish>> getAllFishGroups() async {
    final response = await apiRequest(ApiEndpoints.getAllFishGroups, 'GET');

    if (response != null && response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Fish.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load fish groups');
    }
  }

  Future<Fish> getFishGroup(String id) async {
    final response = await apiRequest(ApiEndpoints.getFishGroup(id), 'GET');

    if (response != null && response.statusCode == 200) {
      return Fish.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load fish group');
    }
  }

  Future<Fish> createFishGroup(Fish fish) async {
    final response = await apiRequest(ApiEndpoints.createFishGroup, 'POST', body: fish.toJson());

    if (response != null && response.statusCode == 201) {
      return Fish.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create fish group');
    }
  }

  Future<Fish> updateFishGroup(String id, Fish fish) async {
    final response = await apiRequest(ApiEndpoints.updateFishGroup(id), 'PUT', body: fish.toJson());

    if (response != null && response.statusCode == 200) {
      return Fish.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update fish group');
    }
  }

  Future<int> getTotalFishCount() async {
    final response = await apiRequest(ApiEndpoints.getTotalFishCount, 'GET');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body)['totalFishCount'];
    } else {
      throw Exception('Failed to load total fish count');
    }
  }

  Future<dynamic> estimatePriceForGroup(String id) async {
    final response = await apiRequest(ApiEndpoints.estimatePriceForFishGroup(id), 'POST');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response != null && response.statusCode == 400) {
      final error = jsonDecode(response.body);
      if (error['message'] == 'Fish group not yet ready for sale') {
        throw Exception('Fish group not yet ready for sale');
      }
    } else {
      throw Exception('Failed to estimate price');
    }
  }

  Future<dynamic> estimatePriceForAll() async {
    final response = await apiRequest(ApiEndpoints.estimatePriceForAllFishGroups, 'POST');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to estimate price');
    }
  }
}