class InfraestructuraModel {
  final String pregunta1Salones;
  final String pregunta2Laboratorios;
  final String pregunta3Biblioteca;
  final String pregunta4Cafeteria;
  final String pregunta5Limpieza;
  final String pregunta6SatisfaccionGeneral;
  final String pregunta7Sugerencias;

  InfraestructuraModel({
    required this.pregunta1Salones,
    required this.pregunta2Laboratorios,
    required this.pregunta3Biblioteca,
    required this.pregunta4Cafeteria,
    required this.pregunta5Limpieza,
    required this.pregunta6SatisfaccionGeneral,
    required this.pregunta7Sugerencias,
  });

  factory InfraestructuraModel.fromJson(Map<String, dynamic> json) {
    return InfraestructuraModel(
      pregunta1Salones: json['pregunta1_salones'] as String? ?? '',
      pregunta2Laboratorios: json['pregunta2_laboratorios'] as String? ?? '',
      pregunta3Biblioteca: json['pregunta3_biblioteca'] as String? ?? '',
      pregunta4Cafeteria: json['pregunta4_cafeteria'] as String? ?? '',
      pregunta5Limpieza: json['pregunta5_limpieza'] as String? ?? '',
      pregunta6SatisfaccionGeneral: json['pregunta6_satisfaccion_general'] as String? ?? '',
      pregunta7Sugerencias: json['pregunta7_sugerencias'] as String? ?? '',
    );
  }
}