// lib/services/calidad_academica_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalidadAcademicaService {
  final String baseUrl;
  final Future<String?> Function() getToken;

  CalidadAcademicaService({
    required this.baseUrl,
    required this.getToken,
  });

  /// POST /calidad-academica
  Future<Map<String, dynamic>> createRespuesta({
    required String pregunta1Claridad,
    required String pregunta2PreparacionDocentes,
    required String pregunta3MetodosEnsenanza,
    required String pregunta4CargaHoraria,
    required String pregunta5ProgramacionHorarios,
    required String pregunta6SatisfaccionGeneral,
    String? pregunta7Sugerencias,
  }) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return {'success': false, 'message': 'Token no disponible'};
    }

    final uri = Uri.parse('$baseUrl/calidad-academica');
    final body = {
      'pregunta1_claridad': pregunta1Claridad,
      'pregunta2_preparacion_docentes': pregunta2PreparacionDocentes,
      'pregunta3_metodos_ensenanza': pregunta3MetodosEnsenanza,
      'pregunta4_carga_horaria': pregunta4CargaHoraria,
      'pregunta5_programacion_horarios': pregunta5ProgramacionHorarios,
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
