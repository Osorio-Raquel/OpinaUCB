// services/survey_service2.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/survey_model2.dart';

class SurveyService2 {
  static Future<List<Survey2>> fetchSurveys(String token) async {
    try {
      print('Fetching surveys from infraestructura-servicios endpoint...');

      final response = await http.get(
        Uri.parse(
          'http://localhost:3000/api/surveys/infraestructura-servicios',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> surveysData = data['data'];
          print('Found ${surveysData.length} infraestructura surveys');

          return surveysData.map((json) => Survey2.fromJson(json)).toList();
        } else {
          throw Exception(
            'Error en la respuesta del servidor: ${data['message']}',
          );
        }
      } else {
        throw Exception('Failed to load surveys: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchSurveys (infraestructura): $e');
      rethrow;
    }
  }
}
