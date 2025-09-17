import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  // Implementación del patrón Singleton para tener una única instancia
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // URL base de la API obtenida desde las constantes
  static final String baseUrl = Constants.apiBaseUrl; // 🔑 corregido

  /// Realiza una petición HTTP POST a la API
  Future<http.Response> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return response;
  }

  /// Realiza una petición HTTP GET a la API
  Future<http.Response> get(String endpoint, {String? token}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );
    return response;
  }
}
