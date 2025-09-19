class CalidadAcademicaModel {
  final String pregunta1Claridad;
  final String pregunta2PreparacionDocentes;
  final String pregunta3MetodosEnsenanza;
  final String pregunta4CargaHoraria;
  final String pregunta5ProgramacionHorarios;
  final String pregunta6SatisfaccionGeneral;
  final String pregunta7Sugerencias;

  CalidadAcademicaModel({
    required this.pregunta1Claridad,
    required this.pregunta2PreparacionDocentes,
    required this.pregunta3MetodosEnsenanza,
    required this.pregunta4CargaHoraria,
    required this.pregunta5ProgramacionHorarios,
    required this.pregunta6SatisfaccionGeneral,
    required this.pregunta7Sugerencias,
  });

  factory CalidadAcademicaModel.fromJson(Map<String, dynamic> json) {
    return CalidadAcademicaModel(
      pregunta1Claridad: json['pregunta1_claridad'] as String? ?? '',
      pregunta2PreparacionDocentes: json['pregunta2_preparacion_docentes'] as String? ?? '',
      pregunta3MetodosEnsenanza: json['pregunta3_metodos_ensenanza'] as String? ?? '',
      pregunta4CargaHoraria: json['pregunta4_carga_horaria'] as String? ?? '',
      pregunta5ProgramacionHorarios: json['pregunta5_programacion_horarios'] as String? ?? '',
      pregunta6SatisfaccionGeneral: json['pregunta6_satisfaccion_general'] as String? ?? '',
      pregunta7Sugerencias: json['pregunta7_sugerencias'] as String? ?? '',
    );
  }
}