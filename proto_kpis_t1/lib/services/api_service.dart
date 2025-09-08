// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/kpi.dart';

class ApiService {
  final _base = backendBase;

  Future<bool> enviarFormulario({
    String? usuarioId,
    int? edad,
    String? genero, // 'Masculino' | 'Femenino' | 'Otro'
    String? ciudad,
    required String categoria, // 'Docentes' | 'Infraestructura' | 'Servicios' | 'Administración'
    required int satisfaccion, // 1..5
    int? calidadServicio,      // 1..5
    String? recomendar,        // 'Sí' | 'No'
    String? comentario,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/api/formulario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario_id': usuarioId,
        'edad': edad,
        'genero': genero,
        'ciudad': ciudad,
        'categoria': categoria,
        'satisfaccion': satisfaccion,
        'calidad_servicio': calidadServicio,
        'recomendar': recomendar,
        'comentario': comentario,
      }),
    );
    return res.statusCode == 200;
  }

  Future<KPIsBundle?> getKPIs() async {
    final res = await http.get(Uri.parse('$_base/api/kpis'));
    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return KPIsBundle.fromMap(map);
    }
    return null;
  }
}
