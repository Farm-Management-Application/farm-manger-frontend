import 'dart:convert';
import '../models/illness.dart';
import '../api/api_endpoints.dart';
import '../api/api_request.dart';

class IllnessService {
  // Fetch all illnesses
  Future<List<Illness>> getAllIllnesses() async {
    final response = await apiRequest(ApiEndpoints.getAllIllnesses, 'GET');

    if (response != null && response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);  // Parsing the JSON string into a list
      return body.map((dynamic item) => Illness.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load illnesses');
    }
  }

  // Fetch illness by ID
  Future<Illness> getIllnessById(String id) async {
    final response = await apiRequest(ApiEndpoints.getIllnessById(id), 'GET');

    if (response != null && response.statusCode == 200) {
      return Illness.fromJson(jsonDecode(response.body));  // Parsing the JSON string into a map
    } else {
      throw Exception('Failed to load illness');
    }
  }

  // Create a new illness record
  Future<Illness> createIllness(Illness illness) async {
    final response = await apiRequest(ApiEndpoints.createIllness, 'POST', body: illness.toJson());

    if (response != null && response.statusCode == 201) {
      return Illness.fromJson(jsonDecode(response.body));  // Parsing the JSON string into a map
    } else {
      throw Exception('Failed to create illness');
    }
  }

  // Update an illness record
  Future<Illness> updateIllness(String id, Illness illness) async {
    final response = await apiRequest(ApiEndpoints.updateIllness(id), 'PUT', body: illness.toJson());

    if (response != null && response.statusCode == 200) {
      return Illness.fromJson(jsonDecode(response.body));  // Parsing the JSON string into a map
    } else {
      throw Exception('Failed to update illness');
    }
  }

  // Soft delete an illness record by setting isDeleted to true
  Future<void> deleteIllness(String id) async {
    final response = await apiRequest(ApiEndpoints.deleteIllness(id), 'DELETE');

    if (response == null || response.statusCode != 200) {
      throw Exception('Failed to delete illness');
    }
  }
}