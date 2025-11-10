// lib/service/currency_api_service.dart
// (FILE BARU)

import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyApiService {
  // Kita akan gunakan API gratis dari exchangerate-api
  // Kita ambil 'IDR' (Rupiah) sebagai mata uang dasar
  final String apiUrl = 'https://api.exchangerate-api.com/v4/latest/IDR';

  Future<Map<String, dynamic>> getRates() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // API ini mengembalikan kurs dalam sub-map 'rates'
        return data['rates'] as Map<String, dynamic>;
      } else {
        throw Exception('Gagal memuat kurs mata uang');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}