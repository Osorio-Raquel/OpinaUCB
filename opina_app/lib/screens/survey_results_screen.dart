import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    surveys = SurveyService.fetchSurveys(widget.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            final stats = _calculateStatistics(surveyList);

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Encabezado con estadísticas generales
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  sliver: SliverToBoxAdapter(
                    child: _buildStatsHeader(stats, context),
                  ),
                ),

                // Gráficos de estadísticas
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: _buildChartsSection(stats, context),
                  ),
                ),

                // Lista de encuestas
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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

  // Estructura para almacenar estadísticas
  Map<String, dynamic> _calculateStatistics(List<Survey> surveys) {
    // Calcular promedios
    double clarityAvg = 0;
    double preparationAvg = 0;
    double methodsAvg = 0;
    double workloadAvg = 0;
    double schedulingAvg = 0;
    double satisfactionAvg = 0;

    // Distribución de satisfacción general
    Map<String, int> satisfactionDistribution = {
      '1': 0,
      '2': 0,
      '3': 0,
      '4': 0,
      '5': 0,
    };

    for (var survey in surveys) {
      clarityAvg += double.tryParse(survey.pregunta1Claridad) ?? 0;
      preparationAvg +=
          double.tryParse(survey.pregunta2PreparacionDocentes) ?? 0;
      methodsAvg += double.tryParse(survey.pregunta3MetodosEnsenanza) ?? 0;
      workloadAvg += double.tryParse(survey.pregunta4CargaHoraria) ?? 0;
      schedulingAvg +=
          double.tryParse(survey.pregunta5ProgramacionHorarios) ?? 0;
      satisfactionAvg +=
          double.tryParse(survey.pregunta6SatisfaccionGeneral) ?? 0;

      // Distribución de satisfacción
      String satisfactionKey =
          (double.tryParse(survey.pregunta6SatisfaccionGeneral) ?? 0)
              .round()
              .toString();
      if (satisfactionDistribution.containsKey(satisfactionKey)) {
        satisfactionDistribution[satisfactionKey] =
            satisfactionDistribution[satisfactionKey]! + 1;
      }
    }

    final count = surveys.length;
    clarityAvg = count > 0 ? clarityAvg / count : 0;
    preparationAvg = count > 0 ? preparationAvg / count : 0;
    methodsAvg = count > 0 ? methodsAvg / count : 0;
    workloadAvg = count > 0 ? workloadAvg / count : 0;
    schedulingAvg = count > 0 ? schedulingAvg / count : 0;
    satisfactionAvg = count > 0 ? satisfactionAvg / count : 0;

    return {
      'totalSurveys': count,
      'clarityAvg': clarityAvg,
      'preparationAvg': preparationAvg,
      'methodsAvg': methodsAvg,
      'workloadAvg': workloadAvg,
      'schedulingAvg': schedulingAvg,
      'satisfactionAvg': satisfactionAvg,
      'satisfactionDistribution': satisfactionDistribution,
    };
  }

  Widget _buildStatsHeader(Map<String, dynamic> stats, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estadísticas Generales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${stats['totalSurveys']} Encuestas',
                  style: TextStyle(
                    color: CupertinoColors.systemRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Claridad', stats['clarityAvg']),
              _buildStatItem('Preparación', stats['preparationAvg']),
              _buildStatItem('Satisfacción', stats['satisfactionAvg']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, double value) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _getValueColor(value),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
        ),
      ],
    );
  }

  Color _getValueColor(double value) {
    if (value >= 4) return CupertinoColors.systemGreen;
    if (value >= 3) return CupertinoColors.systemYellow;
    return CupertinoColors.systemRed;
  }

  Widget _buildChartsSection(Map<String, dynamic> stats, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución de Satisfacción',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildSatisfactionChart(stats['satisfactionDistribution']),
          ),
          const SizedBox(height: 24),
          Text(
            'Comparación de Métricas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: _buildMetricsComparisonChart(stats)),
        ],
      ),
    );
  }

  Widget _buildSatisfactionChart(Map<String, int> distribution) {
    final List<charts.Series<MapEntry<String, int>, String>> seriesList = [
      charts.Series<MapEntry<String, int>, String>(
        id: 'Satisfacción',
        domainFn: (entry, _) => entry.key,
        measureFn: (entry, _) => entry.value,
        data: distribution.entries.toList(),
        colorFn: (entry, _) {
          int rating = int.parse(entry.key);
          switch (rating) {
            case 1:
              return charts.MaterialPalette.red.shadeDefault;
            case 2:
              return charts.MaterialPalette.orange.shadeDefault;
            case 3:
              return charts.MaterialPalette.yellow.shadeDefault;
            case 4:
              return charts.MaterialPalette.green.shadeDefault;
            case 5:
              return charts.MaterialPalette.blue.shadeDefault;
            default:
              return charts.MaterialPalette.gray.shadeDefault;
          }
        },
        labelAccessorFn: (entry, _) => '${entry.value}',
      ),
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsComparisonChart(Map<String, dynamic> stats) {
    final data = [
      _ChartData('Claridad', stats['clarityAvg'], CupertinoColors.systemBlue),
      _ChartData(
        'Preparación',
        stats['preparationAvg'],
        CupertinoColors.systemGreen,
      ),
      _ChartData('Métodos', stats['methodsAvg'], CupertinoColors.systemOrange),
      _ChartData(
        'Carga Horaria',
        stats['workloadAvg'],
        CupertinoColors.systemRed,
      ),
      _ChartData(
        'Horarios',
        stats['schedulingAvg'],
        CupertinoColors.systemPurple,
      ),
      _ChartData(
        'Satisfacción',
        stats['satisfactionAvg'],
        CupertinoColors.systemYellow,
      ),
    ];

    final List<charts.Series<_ChartData, String>> seriesList = [
      charts.Series<_ChartData, String>(
        id: 'Métricas',
        domainFn: (_ChartData data, _) => data.metric,
        measureFn: (_ChartData data, _) => data.value,
        data: data,
        colorFn: (_ChartData data, _) =>
            charts.ColorUtil.fromDartColor(data.color.value),
        labelAccessorFn: (_ChartData data, _) => data.value.toStringAsFixed(1),
      ),
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
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

// Clase auxiliar para los datos del gráfico
class _ChartData {
  final String metric;
  final double value;
  final Color color;

  _ChartData(this.metric, this.value, this.color);
}
