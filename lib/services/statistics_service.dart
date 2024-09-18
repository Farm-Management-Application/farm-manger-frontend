// lib/services/statistics_service.dart
import 'dart:convert';
import '../api/api_endpoints.dart';
import '../api/api_request.dart';

class StatisticsService {
  Future<int> getTotalLivestockCount() async {
    final response = await apiRequest(ApiEndpoints.getTotalLivestockCount, 'GET');

    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.body)['totalCount'];
    } else {
      throw Exception('Failed to load livestock count');
    }
  }

  Future<Map<String, dynamic>> getAverageSalary() async {
    final response = await apiRequest(ApiEndpoints.getAverageSalary, 'GET');

    if (response != null && response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      if (data.containsKey('averageSalary')) {
        final averageSalary = data['averageSalary'];
        final result = {
          'avgSalary': averageSalary['avgSalary'],
          'numberOfWorkers': averageSalary['numberOfWorkers']
        };
        return result;
      } else {
        throw Exception('Failed to load average salary');
      }
    } else {
      throw Exception('Failed to load average salary');
    }
  }

  Future<Map<String, dynamic>> getIllnessImpact() async {
    final response = await apiRequest(ApiEndpoints.getIllnessImpact, 'GET');

    if (response != null && response.statusCode == 200) {
      // Parse the response body as JSON
      final data = jsonDecode(response.body);

      if (data.containsKey('impact')) {
        final impact = data['impact'];

        // Extract totalAffected and totalCost from the impact object
        final result = {
          'totalAffected': impact['totalAffected'],
          'totalCost': impact['totalCost']
        };

        return result;
      } else {
        throw Exception('Impact data is missing from the response');
      }
    } else {
      throw Exception('Failed to load illness impact');
    }
  }
}