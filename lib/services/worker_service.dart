import 'dart:convert';
import '../models/worker.dart';
import '../api/api_endpoints.dart';
import '../api/api_request.dart';

class WorkerService {
  Future<List<Worker>> getAllWorkers() async {
    final response = await apiRequest(ApiEndpoints.getAllWorkers, 'GET');

    if (response != null && response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Worker.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load workers');
    }
  }

  Future<Worker> getWorkerById(String id) async {
    final response = await apiRequest(ApiEndpoints.getWorkerById(id), 'GET');

    if (response != null && response.statusCode == 200) {
      return Worker.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load worker');
    }
  }

  Future<Worker> createWorker(Worker worker) async {
    final response = await apiRequest(ApiEndpoints.createWorker, 'POST', body: worker.toJson());

    if (response != null && response.statusCode == 201) {
      return Worker.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create worker');
    }
  }

  Future<Worker> updateWorker(String id, Worker worker) async {
    final response = await apiRequest(ApiEndpoints.updateWorker(id), 'PUT', body: worker.toJson());

    if (response != null && response.statusCode == 200) {
      return Worker.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update worker');
    }
  }

  Future<void> deactivateWorker(String id) async {
    final response = await apiRequest(ApiEndpoints.deactivateWorker(id), 'PUT');

    if (response == null || response.statusCode != 200) {
      throw Exception('Failed to deactivate worker');
    }
  }

  Future<void> activateWorker(String id) async {
    final response = await apiRequest(ApiEndpoints.ativateWorker(id), 'PUT');

    if (response == null || response.statusCode != 200) {
      throw Exception('Failed to ativate worker');
    }
  }
}