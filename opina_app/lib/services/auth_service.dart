import 'dart:convert';
import 'package:http/http.dart' as http;
import './api_service.dart';
import '../models/user_model.dart';
import 'token_store.dart'; // 👈 NEW

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('auth/login', {
        'correo': email,
        'contrasena': password,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final token = data['token'] as String;
        // 👇 Guarda el token automáticamente
        await TokenStore.save(token);

        return {
          'success': true,
          'token': token,
          'user': User.fromJson(data['user']),
        };
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Error de autenticación',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> register(User user, String password) async {
    try {
      final response = await _apiService.post('auth/register', {
        'correo': user.correo,
        'contrasena': password,
        'nombre': user.nombre,
        'apellido_paterno': user.apellidoPaterno,
        'apellido_materno': user.apellidoMaterno,
        'anonimo': user.anonimo,
        'rol': user.rol,
      });

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {'success': true, 'user': User.fromJson(data['user'])};
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Error en el registro',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  /// getMe con token explícito (tu versión original)
  Future<Map<String, dynamic>> getMe(String token) async {
    try {
      final response = await _apiService.get('auth/me', token: token);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {'success': true, 'user': User.fromJson(data['user'])};
      } else {
        return {
          'success': false,
          'message': 'Error al obtener información del usuario',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // ===== Helpers nuevos =====

  /// Carga el token guardado y llama /auth/me
  Future<Map<String, dynamic>> getMeSaved() async {
    final token = await TokenStore.get();
    if (token == null) {
      return {'success': false, 'message': 'No hay sesión'};
    }
    return getMe(token);
  }

  /// Devuelve el token guardado (o null)
  Future<String?> getSavedToken() => TokenStore.get();

  /// ¿Hay sesión activa?
  Future<bool> isLoggedIn() async => (await TokenStore.get()) != null;

  /// Cierra sesión (borra token)
  Future<void> logout() => TokenStore.clear();
}
