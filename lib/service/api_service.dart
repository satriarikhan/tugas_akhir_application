import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tugas_akhir_application/model/student_model.dart'; // Untuk utf8.decode


class ApiService {
  final String apiUrl =
      'https://raw.githubusercontent.com/SchaleDB/SchaleDB/refs/heads/main/data/en/students.json';

  Future<List<Student>> getStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final String jsonBody = utf8.decode(response.bodyBytes);
        
        // Parsing JSON top-level (yang merupakan List)
        List<dynamic> jsonList = json.decode(jsonBody);
        
        // Ubah setiap item di list menjadi objek Student
        return jsonList.map((jsonItem) => Student.fromJson(jsonItem)).toList();
        
      } else {
        throw Exception('Failed to load students (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}