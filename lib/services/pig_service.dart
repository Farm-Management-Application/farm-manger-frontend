// lib/services/pig_service.dart
import 'dart:convert';
import '../models/pig.dart';
import '../api/api_endpoints.dart';
import '../api/api_request.dart';

class PigService {
  Future<List<Pig>> getAllPigGroups() async {
    final response = await apiRequest(ApiEndpoints.getAllPigGroups, 'GET');

    if (response != null && response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Pig.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load pig groups');
    }
  }

  Future<Pig> getPigGroup(String id) async {
    final response = await apiRequest(ApiEndpoints.getPigGroup(id), 'GET');

    if (response != null && response.statusCode == 200) {
      return Pig.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load pig group');
    }
  }

  Future<Pig> createPigGroup(Pig pig) async {
    final response = await apiRequest(ApiEndpoints.createPigGroup, 'POST', body: pig.toJson());

    if (response != null && response.statusCode == 201) {
      return Pig.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create pig group');
    }
  }

  Future<Pig> updatePigGroup(String id, Pig pig) async {
    final response = await apiRequest(ApiEndpoints.updatePigGroup(id), 'PUT', body: pig.toJson());

    if (response != null && response.statusCode == 200) {
      return Pig.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update pig group');
    }
  }

  Future<int> getTotalPigCount() async {
    final response = await apiRequest(ApiEndpoints.getTotalPigCount, 'GET');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body)['totalPigCount'];
    } else {
      throw Exception('Failed to load total pig count');
    }
  }

  Future<dynamic> estimatePriceForGroup(String id) async {
    final response = await apiRequest(ApiEndpoints.estimatePriceForPigGroup(id), 'POST');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response != null && response.statusCode == 400) {
      final error = jsonDecode(response.body);
      if (error['message'] == 'Pig group not yet ready for sale') {
        throw Exception('Pig group not yet ready for sale');
      }
    } else {
      throw Exception('Failed to estimate price');
    }
  }

  Future<dynamic> estimatePriceForAll() async {
    final response = await apiRequest(ApiEndpoints.estimatePriceForAllPigGroups, 'POST');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to estimate price');
    }
  }
}