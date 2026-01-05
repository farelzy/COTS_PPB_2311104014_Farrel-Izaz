import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task_model.dart';
import 'package:flutter/foundation.dart';

class TaskService {
  Future<List<Task>> getTasks() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/tasks?select=*&order=id.desc');
    
    debugPrint("START GET TASKS");
    debugPrint("URL: $url");
    debugPrint("Headers: ${ApiConfig.headers}"); 

    try {
      final response = await http.get(
        url,
        headers: ApiConfig.headers,
      );
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Raw Body: ${response.body}");

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        
        debugPrint("Berhasil parsing ${data.length} tugas");
        
        return data.map((e) => Task.fromJson(e)).toList();
      } else {
        debugPrint("Gagal: Server mengembalikan error");
        throw Exception('Gagal memuat tugas: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Exception terjadi: $e");
      rethrow;
    }
  }

  Future<bool> addTask(Task task) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/tasks');
    final bodyData = jsonEncode(task.toJson());

    debugPrint("ADD TASK REQUEST");
    debugPrint("URL: $url");
    debugPrint("Headers: ${ApiConfig.headers}");
    debugPrint("Body Payload: $bodyData");

    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: bodyData,
      );

      debugPrint("RESPONSE FROM SERVER");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        debugPrint("SUCCESS: Data created");
        return true;
      } else {
        debugPrint("FAILED: Gagal menyimpan data");
        return false;
      }
    } catch (e) {
      debugPrint("EXCEPTION: Terjadi error koneksi: $e");
      return false;
    }
  }

  Future<bool> updateTask(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/tasks?id=eq.$id'),
      headers: ApiConfig.headers,
      body: jsonEncode(data),
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }
}