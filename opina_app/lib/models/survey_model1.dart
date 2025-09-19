// models/survey_model1.dart
class Survey1 {
  final int id;
  final String usuarioId;
  final String pregunta1Tutorias;
  final String pregunta2Orientacion;
  final String pregunta3Extracurriculares;
  final String pregunta4ApoyoDesarrollo;
  final String pregunta5Comunicacion;
  final String pregunta6SatisfaccionGeneral;
  final String pregunta7Sugerencias;
  final DateTime creadoEn;

  Survey1({
    required this.id,
    required this.usuarioId,
    required this.pregunta1Tutorias,
    required this.pregunta2Orientacion,
    required this.pregunta3Extracurriculares,
    required this.pregunta4ApoyoDesarrollo,
    required this.pregunta5Comunicacion,
    required this.pregunta6SatisfaccionGeneral,
    required this.pregunta7Sugerencias,
    required this.creadoEn,
  });

  factory Survey1.fromJson(Map<String, dynamic> json) {
    return Survey1(
      id: json['id'] ?? 0,
      usuarioId: json['usuario_id'] ?? '',
      pregunta1Tutorias: json['pregunta1_tutorias'] ?? '',
      pregunta2Orientacion: json['pregunta2_orientacion'] ?? '',
      pregunta3Extracurriculares: json['pregunta3_extracurriculares'] ?? '',
      pregunta4ApoyoDesarrollo: json['pregunta4_apoyo_desarrollo'] ?? '',
      pregunta5Comunicacion: json['pregunta5_comunicacion'] ?? '',
      pregunta6SatisfaccionGeneral:
          json['pregunta6_satisfaccion_general'] ?? '',
      pregunta7Sugerencias: json['pregunta7_sugerencias'] ?? '',
      creadoEn: DateTime.parse(
        json['creado_en'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
