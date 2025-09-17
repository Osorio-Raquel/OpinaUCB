// lib/models/user_model.dart
class User {
  final String id;
  final String correo;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final bool anonimo;
  final String rol;
  final DateTime creadoEn;

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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      correo: json['correo'] ?? '',
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellido_paterno'] ?? '',
      apellidoMaterno: json['apellido_materno'] ?? '',
      anonimo: json['anonimo'] ?? false,
      rol: json['rol'] ?? 'ESTUDIANTE',
      creadoEn: DateTime.parse(json['creado_en'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo': correo,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'anonimo': anonimo,
      'rol': rol,
      'creado_en': creadoEn.toIso8601String(),
    };
  }
}