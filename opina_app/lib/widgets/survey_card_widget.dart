import 'package:flutter/material.dart';
import '../models/survey_model.dart';

class SurveyCard extends StatelessWidget {
  final Survey survey;

  const SurveyCard({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario ID: ${survey.usuarioId}'),
            Text('Claridad: ${survey.pregunta1Claridad}'),
            Text(
              'Preparación Docentes: ${survey.pregunta2PreparacionDocentes}',
            ),
            Text('Métodos Enseñanza: ${survey.pregunta3MetodosEnsenanza}'),
            Text('Carga Horaria: ${survey.pregunta4CargaHoraria}'),
            Text(
              'Programación Horarios: ${survey.pregunta5ProgramacionHorarios}',
            ),
            Text(
              'Satisfacción General: ${survey.pregunta6SatisfaccionGeneral}',
            ),
            Text('Sugerencias: ${survey.pregunta7Sugerencias}'),
            Text('Fecha: ${survey.creadoEn.toLocal()}'),
          ],
        ),
      ),
    );
  }
}
