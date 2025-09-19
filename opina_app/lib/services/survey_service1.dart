import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/survey_model1.dart';
import '../utils/constants.dart';

class SurveyService1 {
  static Future<List<Survey1>> fetchSurveys(String token) async {
    final url = Uri.parse(
      '${Constants.apiBaseUrl}/api/surveys/experiencia-apoyo',
    );
    print('[SurveyService] GET $url'); // ✅ Log de URL

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(
        '[SurveyService] Status Code: ${response.statusCode}',
      ); // ✅ Log de código HTTP
      print('[SurveyService] Body: ${response.body}'); // ✅ Log del body

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List surveysJson = data['data'];
        return surveysJson.map((json) => Survey1.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado: token inválido o expirado');
      } else {
        throw Exception('Error al cargar encuestas: ${response.statusCode}');
      }
    } catch (e) {
      print('[SurveyService] Error: $e'); // ✅ Log de error
      rethrow;
    }
  }
}
