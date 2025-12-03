import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/home_response.dart';

class ApiService {
  static const String baseUrl = 'https://api.prosignings.online/api'; // can hide in main production

  static Future<HomeResponse> fetchHomeData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/home'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return HomeResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load home data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching home data: $e');
    }
  }
}