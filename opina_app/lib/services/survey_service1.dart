// services/survey_service1.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/survey_model1.dart';

class SurveyService1 {
  static Future<List<Survey1>> fetchSurveys(String token) async {
    try {
      print('Fetching surveys from experiencia-apoyo endpoint...');

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/surveys/experiencia-apoyo'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> surveysData = data['data'];
          print('Found ${surveysData.length} surveys');

          // DEBUG: Imprimir las keys del primer survey para ver qué campos tiene
          if (surveysData.isNotEmpty) {
            print('First survey keys: ${surveysData[0].keys}');
          }

          return surveysData.map((json) => Survey1.fromJson(json)).toList();
        } else {
          throw Exception(
            'Error en la respuesta del servidor: ${data['message']}',
          );
        }
      } else {
        throw Exception(
          'Failed to load surveys: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error in fetchSurveys: $e');
      rethrow;
    }
  }
}
