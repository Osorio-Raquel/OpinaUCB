// models/survey_model2.dart
class Survey2 {
  final int id;
  final String usuarioId;
  final String pregunta1Salones;
  final String pregunta2Laboratorios;
  final String pregunta3Biblioteca;
  final String pregunta4Cafeteria;
  final String pregunta5Limpieza;
  final String pregunta6SatisfaccionGeneral;
  final String pregunta7Sugerencias;
  final DateTime creadoEn;

  Survey2({
    required this.id,
    required this.usuarioId,
    required this.pregunta1Salones,
    required this.pregunta2Laboratorios,
    required this.pregunta3Biblioteca,
    required this.pregunta4Cafeteria,
    required this.pregunta5Limpieza,
    required this.pregunta6SatisfaccionGeneral,
    required this.pregunta7Sugerencias,
    required this.creadoEn,
  });

  factory Survey2.fromJson(Map<String, dynamic> json) {
    return Survey2(
      id: json['id'] ?? 0,
      usuarioId: json['usuario_id'] ?? '',
      pregunta1Salones: json['pregunta1_salones'] ?? '',
      pregunta2Laboratorios: json['pregunta2_laboratorios'] ?? '',
      pregunta3Biblioteca: json['pregunta3_biblioteca'] ?? '',
      pregunta4Cafeteria: json['pregunta4_cafeteria'] ?? '',
      pregunta5Limpieza: json['pregunta5_limpieza'] ?? '',
      pregunta6SatisfaccionGeneral:
          json['pregunta6_satisfaccion_general'] ?? '',
      pregunta7Sugerencias: json['pregunta7_sugerencias'] ?? '',
      creadoEn: DateTime.parse(
        json['creado_en'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
