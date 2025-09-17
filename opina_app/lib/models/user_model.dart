// lib/models/user_model.dart

/// Modelo de datos que representa un usuario en la aplicación
class User {
  final String id; // Identificador único del usuario
  final String correo; // Dirección de correo electrónico
  final String nombre; // Nombre del usuario
  final String apellidoPaterno; // Apellido paterno
  final String apellidoMaterno; // Apellido materno
  final bool anonimo; // Indicador si el usuario es anónimo
  final String rol; // Rol del usuario (ej: ESTUDIANTE, ADMINISTRADOR)
  final DateTime creadoEn; // Fecha y hora de creación del usuario

  /// Constructor principal de la clase User
  User({
    required this.id,
    required this.correo,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.anonimo,
    required this.rol,
    required this.creadoEn,
  });

  /// Factory constructor para crear una instancia de User desde un mapa JSON
  /// Útil para parsear respuestas de API o datos de base de datos
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', // Valor por defecto: string vacío si es null
      correo: json['correo'] ?? '', // Valor por defecto: string vacío si es null
      nombre: json['nombre'] ?? '', // Valor por defecto: string vacío si es null
      apellidoPaterno: json['apellido_paterno'] ?? '', // Mapeo de snake_case a camelCase
      apellidoMaterno: json['apellido_materno'] ?? '', // Mapeo de snake_case a camelCase
      anonimo: json['anonimo'] ?? false, // Valor por defecto: false si es null
      rol: json['rol'] ?? 'ESTUDIANTE', // Valor por defecto: 'ESTUDIANTE' si es null
      creadoEn: DateTime.parse(json['creado_en'] ?? DateTime.now().toString()), // Parseo de fecha ISO
    );
  }

  /// Método para convertir la instancia de User a un mapa JSON
  /// Útil para enviar datos a la API o guardar en base de datos
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo': correo,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno, // Conversión a snake_case para la API
      'apellido_materno': apellidoMaterno, // Conversión a snake_case para la API
      'anonimo': anonimo,
      'rol': rol,
      'creado_en': creadoEn.toIso8601String(), // Conversión a formato ISO 8601
    };
  }
}