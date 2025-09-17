// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  // Implementación del patrón Singleton para tener una única instancia
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // URL base de la API obtenida desde las constantes
  static const String baseUrl = Constants.apiBaseUrl;

  /// Realiza una petición HTTP POST a la API
  /// @param endpoint - Ruta específica del endpoint
  /// @param data - Datos a enviar en el cuerpo de la petición (se convierten a JSON)
  // ignore: unintended_html_in_doc_comment
  /// @return Future<http.Response> - Respuesta de la petición HTTP
  Future<http.Response> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'), // Construye la URL completa
      headers: {'Content-Type': 'application/json'}, // Establece el header de contenido JSON
      body: json.encode(data), // Convierte los datos a formato JSON
    );
    return response;
  }

  /// Realiza una petición HTTP GET a la API
  /// param endpoint - Ruta específica del endpoint
  /// param token - Token de autenticación opcional (para endpoints protegidos)
  // ignore: unintended_html_in_doc_comment
  /// return Future<http.Response> - Respuesta de la petición HTTP
  Future<http.Response> get(String endpoint, {String? token}) async {
    final headers = {
      'Content-Type': 'application/json', // Header para contenido JSON
    };
    
    // Si se proporciona un token, añade el header de autorización
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'), // Construye la URL completa
      headers: headers, // Headers de la petición
    );
    return response;
  }
}