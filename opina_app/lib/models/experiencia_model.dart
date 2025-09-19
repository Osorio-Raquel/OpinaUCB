class ExperienciaModel {
  final String pregunta1Tutorias;
  final String pregunta2Orientacion;
  final String pregunta3Extracurriculares;
  final String pregunta4ApoyoDesarrollo;
  final String pregunta5Comunicacion;
  final String pregunta6SatisfaccionGeneral;
  final String pregunta7Sugerencias;

  ExperienciaModel({
    required this.pregunta1Tutorias,
    required this.pregunta2Orientacion,
    required this.pregunta3Extracurriculares,
    required this.pregunta4ApoyoDesarrollo,
    required this.pregunta5Comunicacion,
    required this.pregunta6SatisfaccionGeneral,
    required this.pregunta7Sugerencias,
  });

  factory ExperienciaModel.fromJson(Map<String, dynamic> json) {
    return ExperienciaModel(
      pregunta1Tutorias: json['pregunta1_tutorias'] as String? ?? '',
      pregunta2Orientacion: json['pregunta2_orientacion'] as String? ?? '',
      pregunta3Extracurriculares: json['pregunta3_extracurriculares'] as String? ?? '',
      pregunta4ApoyoDesarrollo: json['pregunta4_apoyo_desarrollo'] as String? ?? '',
      pregunta5Comunicacion: json['pregunta5_comunicacion'] as String? ?? '',
      pregunta6SatisfaccionGeneral: json['pregunta6_satisfaccion_general'] as String? ?? '',
      pregunta7Sugerencias: json['pregunta7_sugerencias'] as String? ?? '',
    );
  }
}