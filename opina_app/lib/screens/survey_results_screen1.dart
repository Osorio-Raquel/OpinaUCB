import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/survey_model1.dart';
import '../services/survey_service1.dart';

class SurveyResultsScreen1 extends StatefulWidget {
  final String token;
  const SurveyResultsScreen1({super.key, required this.token});

  @override
  State<SurveyResultsScreen1> createState() => _SurveyResultsScreenState();
}

class _SurveyResultsScreenState extends State<SurveyResultsScreen1> {
  late Future<List<Survey1>> surveys;

  @override
  void initState() {
    super.initState();
    surveys = SurveyService1.fetchSurveys(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Resultados Experiencia y Apoyo'),
        backgroundColor: CupertinoColors.systemBackground,
        border: null,
      ),
      child: SafeArea(
        child: FutureBuilder<List<Survey1>>(
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

  Widget _buildSurveyCard(Survey1 survey, BuildContext context) {
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
                  _getShortRating(survey.pregunta6SatisfaccionGeneral),
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
    final lowerRating = rating.toLowerCase();
    if (lowerRating.contains('muy') ||
        lowerRating.contains('excelente') ||
        lowerRating.contains('buena')) {
      return CupertinoColors.systemGreen;
    } else if (lowerRating.contains('satisfecho') ||
        lowerRating.contains('adecuado')) {
      return CupertinoColors.systemYellow;
    } else if (lowerRating.contains('insatisfecho') ||
        lowerRating.contains('regular')) {
      return CupertinoColors.systemRed;
    }
    return CupertinoColors.systemGrey;
  }

  String _getShortRating(String rating) {
    final lowerRating = rating.toLowerCase();
    if (lowerRating.contains('muy satisfecho')) return 'Muy Sat';
    if (lowerRating.contains('satisfecho')) return 'Sat';
    if (lowerRating.contains('insatisfecho')) return 'Insat';
    if (lowerRating.contains('regular')) return 'Regular';
    if (lowerRating.contains('adecuado')) return 'Adec';
    if (lowerRating.contains('buena')) return 'Buena';
    if (lowerRating.contains('excelente')) return 'Excel';
    return rating.length > 10 ? '${rating.substring(0, 8)}...' : rating;
  }

  void _showSurveyDetails(Survey1 survey, BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Detalles de Encuesta #${survey.id}"),
        message: Text("Usuario: ${survey.usuarioId}"),
        actions: [
          if (survey.pregunta1Tutorias != null)
            _buildDetailRow("Tutorías", survey.pregunta1Tutorias!),
          if (survey.pregunta2Orientacion != null)
            _buildDetailRow("Orientación", survey.pregunta2Orientacion!),
          if (survey.pregunta3Extracurriculares != null)
            _buildDetailRow(
              "Actividades Extracurriculares",
              survey.pregunta3Extracurriculares!,
            ),
          if (survey.pregunta4ApoyoDesarrollo != null)
            _buildDetailRow(
              "Apoyo al Desarrollo",
              survey.pregunta4ApoyoDesarrollo!,
            ),
          if (survey.pregunta5Comunicacion != null)
            _buildDetailRow("Comunicación", survey.pregunta5Comunicacion!),
          _buildDetailRow(
            "Satisfacción General",
            survey.pregunta6SatisfaccionGeneral,
          ),
          if (survey.pregunta7Sugerencias != null &&
              survey.pregunta7Sugerencias!.isNotEmpty)
            CupertinoActionSheetAction(
              onPressed: () {
                _showSuggestions(survey.pregunta7Sugerencias!, context);
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
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
              textAlign: TextAlign.right,
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
        content: SingleChildScrollView(child: Text(suggestions)),
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
