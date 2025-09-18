import 'dart:convert';
import 'package:http/http.dart' as http;

class InfraestructuraService {
  final String baseUrl;
  final Future<String?> Function() getToken;

  InfraestructuraService({
    required this.baseUrl,
    required this.getToken,
  });

  /// POST -> /infraestructura-servicios
  Future<Map<String, dynamic>> createRespuesta({
    required String pregunta1Salones,
    required String pregunta2Laboratorios,
    required String pregunta3Biblioteca,
    required String pregunta4Cafeteria,
    required String pregunta5Limpieza,
    required String pregunta6SatisfaccionGeneral,
    String? pregunta7Sugerencias,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return {'success': false, 'message': 'Token no disponible'};
    }

    final uri = Uri.parse('$baseUrl/infraestructura-servicios');
    final body = {
      'pregunta1_salones': pregunta1Salones,
      'pregunta2_laboratorios': pregunta2Laboratorios,
      'pregunta3_biblioteca': pregunta3Biblioteca,
      'pregunta4_cafeteria': pregunta4Cafeteria,
      'pregunta5_limpieza': pregunta5Limpieza,
      'pregunta6_satisfaccion_general': pregunta6SatisfaccionGeneral,
      if (pregunta7Sugerencias != null && pregunta7Sugerencias.trim().isNotEmpty)
        'pregunta7_sugerencias': pregunta7Sugerencias.trim(),
    };

    final res = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(res.body)};
    } else {
      try {
        final err = jsonDecode(res.body);
        return {'success': false, 'message': err['message'] ?? 'Error'};
      } catch (_) {
        return {'success': false, 'message': 'Error ${res.statusCode}'};
      }
    }
  }
}
