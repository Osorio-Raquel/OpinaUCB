class Survey {
  final int id;
  final String usuarioId;
  final String pregunta1Claridad;
  final String pregunta2PreparacionDocentes;
  final String pregunta3MetodosEnsenanza;
  final String pregunta4CargaHoraria;
  final String pregunta5ProgramacionHorarios;
  final String pregunta6SatisfaccionGeneral;
  final String pregunta7Sugerencias;
  final DateTime creadoEn;

  Survey({
    required this.id,
    required this.usuarioId,
    required this.pregunta1Claridad,
    required this.pregunta2PreparacionDocentes,
    required this.pregunta3MetodosEnsenanza,
    required this.pregunta4CargaHoraria,
    required this.pregunta5ProgramacionHorarios,
    required this.pregunta6SatisfaccionGeneral,
    required this.pregunta7Sugerencias,
    required this.creadoEn,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      usuarioId: json['usuario_id'],
      pregunta1Claridad: json['pregunta1_claridad'],
      pregunta2PreparacionDocentes: json['pregunta2_preparacion_docentes'],
      pregunta3MetodosEnsenanza: json['pregunta3_metodos_ensenanza'],
      pregunta4CargaHoraria: json['pregunta4_carga_horaria'],
      pregunta5ProgramacionHorarios: json['pregunta5_programacion_horarios'],
      pregunta6SatisfaccionGeneral: json['pregunta6_satisfaccion_general'],
      pregunta7Sugerencias: json['pregunta7_sugerencias'],
      creadoEn: DateTime.parse(json['creado_en']),
    );
  }
}
