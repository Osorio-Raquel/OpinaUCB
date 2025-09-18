import 'dart:convert';
import 'package:http/http.dart' as http;

class ExperienciaService {
  // TODO: cambia por tu baseURL (localhost para web/emulador; ngrok/dispositivo real)
  final String baseUrl;

  // La función para obtener el token. Puedes inyectarla o usar shared_prefs.
  final Future<String?> Function() getToken;

  ExperienciaService({required this.baseUrl, required this.getToken});

  /// Crea una respuesta completa de experiencia_apoyo
  Future<Map<String, dynamic>> createRespuesta({
    required String pregunta1Tutorias,
    required String pregunta2Orientacion,
    required String pregunta3Extracurriculares,
    required String pregunta4ApoyoDesarrollo,
    required String pregunta5Comunicacion,
    required String pregunta6SatisfaccionGeneral,
    String? pregunta7Sugerencias,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return {'success': false, 'message': 'Token no disponible'};
    }

    final uri = Uri.parse('$baseUrl/experiencia-apoyo');
    final body = {
      'pregunta1_tutorias': pregunta1Tutorias,
      'pregunta2_orientacion': pregunta2Orientacion,
      'pregunta3_extracurriculares': pregunta3Extracurriculares,
      'pregunta4_apoyo_desarrollo': pregunta4ApoyoDesarrollo,
      'pregunta5_comunicacion': pregunta5Comunicacion,
      'pregunta6_satisfaccion_general': pregunta6SatisfaccionGeneral,
      if (pregunta7Sugerencias != null &&
          pregunta7Sugerencias.trim().isNotEmpty)
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
