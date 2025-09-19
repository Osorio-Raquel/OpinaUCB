import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/survey_model.dart';
import '../services/survey_service.dart';

class SurveyResultsScreen extends StatefulWidget {
  final String token;
  const SurveyResultsScreen({super.key, required this.token});

  @override
  State<SurveyResultsScreen> createState() => _SurveyResultsScreenState();
}

class _SurveyResultsScreenState extends State<SurveyResultsScreen> {
  late Future<List<Survey>> surveys;

  @override
  void initState() {
    super.initState();
    surveys = SurveyService.fetchSurveys(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Resultados Calidad Académica'),
        backgroundColor: CupertinoColors.systemBackground,
        border: null,
      ),
      child: SafeArea(
        child: FutureBuilder<List<Survey>>(
          future: surveys,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 16),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error al cargar los resultados: ${snapshot.error}',
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay resultados disponibles'));
            }

            final surveyList = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final survey = surveyList[index];
                      return _buildSurveyCard(survey, context);
                    }, childCount: surveyList.length),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSurveyCard(Survey survey, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(14),
        onPressed: () {
          _showSurveyDetails(survey, context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono y ID
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.doc_chart_fill,
                  color: CupertinoColors.systemRed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Encuesta #${survey.id}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Usuario: ${survey.usuarioId}",
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${survey.creadoEn.day}/${survey.creadoEn.month}/${survey.creadoEn.year}',
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.tertiaryLabel,
                      ),
                    ),
                  ],
                ),
              ),

              // Calificación general
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRatingColor(survey.pregunta6SatisfaccionGeneral),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  survey.pregunta6SatisfaccionGeneral,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(String rating) {
    try {
      final value = double.tryParse(rating) ?? 0;
      if (value >= 4) return CupertinoColors.systemGreen;
      if (value >= 3) return CupertinoColors.systemYellow;
      return CupertinoColors.systemRed;
    } catch (e) {
      return CupertinoColors.systemGrey;
    }
  }

  void _showSurveyDetails(Survey survey, BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Detalles de Encuesta #${survey.id}"),
        message: Text("Usuario: ${survey.usuarioId}"),
        actions: [
          _buildDetailRow("Claridad", survey.pregunta1Claridad),
          _buildDetailRow(
            "Preparación Docentes",
            survey.pregunta2PreparacionDocentes,
          ),
          _buildDetailRow(
            "Métodos Enseñanza",
            survey.pregunta3MetodosEnsenanza,
          ),
          _buildDetailRow("Carga Horaria", survey.pregunta4CargaHoraria),
          _buildDetailRow(
            "Programación Horarios",
            survey.pregunta5ProgramacionHorarios,
          ),
          _buildDetailRow(
            "Satisfacción General",
            survey.pregunta6SatisfaccionGeneral,
          ),
          if (survey.pregunta7Sugerencias.isNotEmpty)
            CupertinoActionSheetAction(
              onPressed: () {
                _showSuggestions(survey.pregunta7Sugerencias, context);
              },
              child: const Text("Ver Sugerencias"),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cerrar",
            style: TextStyle(color: CupertinoColors.systemRed),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuggestions(String suggestions, BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Sugerencias"),
        content: Text(suggestions),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }
}
