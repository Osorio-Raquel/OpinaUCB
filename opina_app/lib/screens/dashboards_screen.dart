import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:opina_app/models/calidad_academica_model.dart';
import 'package:opina_app/models/experiencia_model.dart';
import 'package:opina_app/models/infraestructura_model.dart';
import 'package:opina_app/services/api_service.dart';
import 'package:opina_app/services/token_store.dart';

class DashboardsScreen extends StatefulWidget {
  const DashboardsScreen({super.key});

  @override
  State<DashboardsScreen> createState() => _DashboardsScreenState();
}

class _DashboardsScreenState extends State<DashboardsScreen> {
  final themePurple = Colors.purple.shade700;
  List<CalidadAcademicaModel> _calidadData = [];
  List<ExperienciaModel> _experienciaData = [];
  List<InfraestructuraModel> _infraestructuraData = [];

  bool _isLoading = true;
  String _errorMessage = '';

  final ApiService _apiService = ApiService();

  int _completedRequests = 0;
  final int _totalRequests = 3;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final token = await TokenStore.get();
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'No se encontró un token de autenticación.';
          _isLoading = false;
        });
        return;
      }

      await Future.wait([
        _getCalidadData(token),
        _getExperienciaData(token),
        _getInfraestructuraData(token),
      ]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los datos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getCalidadData(String token) async {
    try {
      final response = await _apiService.get('api/surveys/calidad-academica', token: token);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        final List<dynamic> dataList = decodedJson['data'];
          
        setState(() {
          _calidadData = dataList
              .map((item) => CalidadAcademicaModel.fromJson(item))
              .toList();
          _checkAllRequestsComplete();
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar encuestas de calidad académica: ${response.statusCode}';
          _checkAllRequestsComplete();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _checkAllRequestsComplete();
      });
    }
  }

  Future<void> _getExperienciaData(String token) async {
    try {
      final response = await _apiService.get('api/surveys/experiencia-apoyo', token: token);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        final List<dynamic> dataList = decodedJson['data'];
          
        setState(() {
          _experienciaData = dataList
              .map((item) => ExperienciaModel.fromJson(item))
              .toList();
          _checkAllRequestsComplete();
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar encuestas de experiencia-apoyo: ${response.statusCode}';
          _checkAllRequestsComplete();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _checkAllRequestsComplete();
      });
    }
  }

  Future<void> _getInfraestructuraData(String token) async {
    try {
      final response = await _apiService.get('api/surveys/infraestructura-servicios', token: token);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        final List<dynamic> dataList = decodedJson['data'];
          
        setState(() {
          _infraestructuraData = dataList
              .map((item) => InfraestructuraModel.fromJson(item))
              .toList();
          _checkAllRequestsComplete();
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar encuestas de infraestructura-servicios: ${response.statusCode}';
          _checkAllRequestsComplete();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _checkAllRequestsComplete();
      });
    }
  }

  void _checkAllRequestsComplete() {
    _completedRequests++;
    if (_completedRequests >= _totalRequests) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String selectedSurveyType = 'Calidad Académica';
  int selectedQuestionIndex = 0;

double getAverageSatisfactionForCalidad() {
    if (_calidadData.isEmpty) return 0;
    double total = _calidadData.fold(0, (sum, survey) => 
        sum + _convertCalidadAnswerToNumber(5, survey.pregunta6SatisfaccionGeneral));
    return total / _calidadData.length;
  }

  double getAverageSatisfactionForExperiencia() {
    if (_experienciaData.isEmpty) return 0;
    double total = _experienciaData.fold(0, (sum, survey) => 
        sum + _convertExperienciaAnswerToNumber(5, survey.pregunta6SatisfaccionGeneral));
    return total / _experienciaData.length;
  }

  double getAverageSatisfactionForInfraestructura() {
    if (_infraestructuraData.isEmpty) return 0;
    double total = _infraestructuraData.fold(0, (sum, survey) => 
        sum + _convertInfraestructuraAnswerToNumber(5, survey.pregunta6SatisfaccionGeneral));
    return total / _infraestructuraData.length;
  }

  int _convertCalidadAnswerToNumber(int questionIndex, String answer) {
    switch (questionIndex) {
      case 0: // pregunta1_claridad
        switch (answer) {
          case 'Muy claro': return 5;
          case 'Claro': return 4;
          case 'Regular': return 3;
          case 'Poco claro': return 2;
          case 'Nada claro': return 1;
          default: return 3;
        }
      case 1: // pregunta2_preparacion_docentes
        switch (answer) {
          case 'Excelente': return 5;
          case 'Buena': return 4;
          case 'Regular': return 3;
          case 'Deficiente': return 2;
          case 'Muy deficiente': return 1;
          default: return 3;
        }
      case 2: // pregunta3_metodos_ensenanza
        switch (answer) {
          case 'Muy adecuados': return 5;
          case 'Adecuados': return 4;
          case 'Regulares': return 3;
          case 'Poco adecuados': return 2;
          case 'Nada adecuados': return 1;
          default: return 3;
        }
      case 3: // pregunta4_carga_horaria
        switch (answer) {
          case 'Muy adecuada': return 5;
          case 'Adecuada': return 4;
          case 'Regular': return 3;
          case 'Excesiva': return 2;
          case 'Insuficiente': return 1;
          default: return 3;
        }
      case 4: // pregunta5_programacion_horarios
        switch (answer) {
          case 'Muy flexible': return 5;
          case 'Flexible': return 4;
          case 'Regular': return 3;
          case 'Poco flexible': return 2;
          case 'Nada flexible': return 1;
          default: return 3;
        }
      case 5: // pregunta6_satisfaccion_general
        switch (answer) {
          case 'Muy satisfecho': return 5;
          case 'Satisfecho': return 4;
          case 'Regular': return 3;
          case 'Insatisfecho': return 2;
          case 'Muy insatisfecho': return 1;
          default: return 3;
        }
      default:
        return 3;
    }
  }

  int _convertInfraestructuraAnswerToNumber(int questionIndex, String answer) {
    switch (questionIndex) {
      case 0: // pregunta1_salones
        switch (answer) {
          case 'Muy adecuados': return 5;
          case 'Adecuados': return 4;
          case 'Regulares': return 3;
          case 'Poco adecuados': return 2;
          case 'Nada adecuados': return 1;
          default: return 3;
        }
      case 1: // pregunta2_laboratorios
        switch (answer) {
          case 'Excelente': return 5;
          case 'Buena': return 4;
          case 'Regular': return 3;
          case 'Deficiente': return 2;
          case 'Muy deficiente': return 1;
          default: return 3;
        }
      case 2: // pregunta3_biblioteca
        switch (answer) {
          case 'Muy útiles': return 5;
          case 'Útiles': return 4;
          case 'Regulares': return 3;
          case 'Poco útiles': return 2;
          case 'Nada útiles': return 1;
          default: return 3;
        }
      case 3: // pregunta4_cafeteria
        switch (answer) {
          case 'Muy satisfecho': return 5;
          case 'Satisfecho': return 4;
          case 'Neutral': return 3;
          case 'Insatisfecho': return 2;
          case 'Muy insatisfecho': return 1;
          default: return 3;
        }
      case 4: // pregunta5_limpieza
        switch (answer) {
          case 'Excelente': return 5;
          case 'Buena': return 4;
          case 'Regular': return 3;
          case 'Deficiente': return 2;
          case 'Muy deficiente': return 1;
          default: return 3;
        }
      case 5: // pregunta6_satisfaccion_general
        switch (answer) {
          case 'Muy satisfecho': return 5;
          case 'Satisfecho': return 4;
          case 'Regular': return 3;
          case 'Insatisfecho': return 2;
          case 'Muy insatisfecho': return 1;
          default: return 3;
        }
      default:
        return 3;
    }
  }

  int _convertExperienciaAnswerToNumber(int questionIndex, String answer) {
    switch (questionIndex) {
      case 0: // pregunta1_tutorias
        switch (answer) {
          case 'Muy útiles': return 5;
          case 'Útiles': return 4;
          case 'Regulares': return 3;
          case 'Poco útiles': return 2;
          case 'Nada útiles': return 1;
          default: return 3;
        }
      case 1: // pregunta2_orientacion
        switch (answer) {
          case 'Muy accesibles': return 5;
          case 'Accesibles': return 4;
          case 'Regulares': return 3;
          case 'Poco accesibles': return 2;
          case 'Nada accesibles': return 1;
          default: return 3;
        }
      case 2: // pregunta3_extracurriculares
        switch (answer) {
          case 'Muy satisfecho': return 5;
          case 'Satisfecho': return 4;
          case 'Neutral': return 3;
          case 'Insatisfecho': return 2;
          case 'Muy insatisfecho': return 1;
          default: return 3;
        }
      case 3: // pregunta4_apoyo_desarrollo
        switch (answer) {
          case 'Excelente': return 5;
          case 'Bueno': return 4;
          case 'Regular': return 3;
          case 'Deficiente': return 2;
          case 'Muy deficiente': return 1;
          default: return 3;
        }
      case 4: // pregunta5_comunicacion
        switch (answer) {
          case 'Muy adecuada': return 5;
          case 'Adecuada': return 4;
          case 'Regular': return 3;
          case 'Poco adecuada': return 2;
          case 'Nada adecuada': return 1;
          default: return 3;
        }
      case 5: // pregunta6_satisfaccion_general
        switch (answer) {
          case 'Muy satisfecho': return 5;
          case 'Satisfecho': return 4;
          case 'Regular': return 3;
          case 'Insatisfecho': return 2;
          case 'Muy insatisfecho': return 1;
          default: return 3;
        }
      default:
        return 3;
    }
  }

  List<double> getAveragesForSelectedSurvey() {
    List<double> averages = List.filled(6, 0.0);
    int count = 0;
    
    switch (selectedSurveyType) {
      case 'Calidad Académica':
        count = _calidadData.length;
        for (var survey in _calidadData) {
          averages[0] += _convertCalidadAnswerToNumber(0, survey.pregunta1Claridad);
          averages[1] += _convertCalidadAnswerToNumber(1, survey.pregunta2PreparacionDocentes);
          averages[2] += _convertCalidadAnswerToNumber(2, survey.pregunta3MetodosEnsenanza);
          averages[3] += _convertCalidadAnswerToNumber(3, survey.pregunta4CargaHoraria);
          averages[4] += _convertCalidadAnswerToNumber(4, survey.pregunta5ProgramacionHorarios);
          averages[5] += _convertCalidadAnswerToNumber(5, survey.pregunta6SatisfaccionGeneral);
        }
        break;
      case 'Experiencia':
        count = _experienciaData.length;
        for (var survey in _experienciaData) {
          averages[0] += _convertExperienciaAnswerToNumber(0, survey.pregunta1Tutorias);
          averages[1] += _convertExperienciaAnswerToNumber(1, survey.pregunta2Orientacion);
          averages[2] += _convertExperienciaAnswerToNumber(2, survey.pregunta3Extracurriculares);
          averages[3] += _convertExperienciaAnswerToNumber(3, survey.pregunta4ApoyoDesarrollo);
          averages[4] += _convertExperienciaAnswerToNumber(4, survey.pregunta5Comunicacion);
          averages[5] += _convertExperienciaAnswerToNumber(5, survey.pregunta6SatisfaccionGeneral);
        }
        break;
      case 'Infraestructura':
        count = _infraestructuraData.length;
        for (var survey in _infraestructuraData) {
          averages[0] += _convertInfraestructuraAnswerToNumber(0, survey.pregunta1Salones);
          averages[1] += _convertInfraestructuraAnswerToNumber(1, survey.pregunta2Laboratorios);
          averages[2] += _convertInfraestructuraAnswerToNumber(2, survey.pregunta3Biblioteca);
          averages[3] += _convertInfraestructuraAnswerToNumber(3, survey.pregunta4Cafeteria);
          averages[4] += _convertInfraestructuraAnswerToNumber(4, survey.pregunta5Limpieza);
          averages[5] += _convertInfraestructuraAnswerToNumber(5, survey.pregunta6SatisfaccionGeneral);
        }
        break;
    }
    
    for (int i = 0; i < averages.length; i++) {
      averages[i] = count > 0 ? averages[i] / count : 0;
    }
    
    return averages;
  }

  Map<String, int> getAnswerDistribution(int questionIndex) {
    Map<String, int> distribution = {};
    
    switch (selectedSurveyType) {
      case 'Calidad Académica':
        for (var survey in _calidadData) {
          String answer;
          switch (questionIndex) {
            case 0: answer = survey.pregunta1Claridad; break;
            case 1: answer = survey.pregunta2PreparacionDocentes; break;
            case 2: answer = survey.pregunta3MetodosEnsenanza; break;
            case 3: answer = survey.pregunta4CargaHoraria; break;
            case 4: answer = survey.pregunta5ProgramacionHorarios; break;
            case 5: answer = survey.pregunta6SatisfaccionGeneral; break;
            default: answer = '';
          }
          distribution[answer] = (distribution[answer] ?? 0) + 1;
        }
        break;
      case 'Experiencia':
        for (var survey in _experienciaData) {
          String answer;
          switch (questionIndex) {
            case 0: answer = survey.pregunta1Tutorias; break;
            case 1: answer = survey.pregunta2Orientacion; break;
            case 2: answer = survey.pregunta3Extracurriculares; break;
            case 3: answer = survey.pregunta4ApoyoDesarrollo; break;
            case 4: answer = survey.pregunta5Comunicacion; break;
            case 5: answer = survey.pregunta6SatisfaccionGeneral; break;
            default: answer = '';
          }
          distribution[answer] = (distribution[answer] ?? 0) + 1;
        }
        break;
      case 'Infraestructura':
        for (var survey in _infraestructuraData) {
          String answer;
          switch (questionIndex) {
            case 0: answer = survey.pregunta1Salones; break;
            case 1: answer = survey.pregunta2Laboratorios; break;
            case 2: answer = survey.pregunta3Biblioteca; break;
            case 3: answer = survey.pregunta4Cafeteria; break;
            case 4: answer = survey.pregunta5Limpieza; break;
            case 5: answer = survey.pregunta6SatisfaccionGeneral; break;
            default: answer = '';
          }
          distribution[answer] = (distribution[answer] ?? 0) + 1;
        }
        break;
    }
    
    return distribution;
  }

  List<String> getQuestionLabels() {
    switch (selectedSurveyType) {
      case 'Calidad Académica':
        return [
          'Claridad de contenidos',
          'Preparación de docentes',
          'Métodos de enseñanza',
          'Carga horaria',
          'Programación de horarios',
          'Satisfacción general'
        ];
      case 'Experiencia':
        return [
          'Tutorías',
          'Orientación',
          'Actividades extracurriculares',
          'Apoyo al desarrollo',
          'Comunicación',
          'Satisfacción general'
        ];
      case 'Infraestructura':
        return [
          'Salones de clase',
          'Laboratorios',
          'Biblioteca',
          'Cafetería',
          'Limpieza',
          'Satisfacción general'
        ];
      default:
        return [];
    }
  }

  List<String> getSuggestions() {
    switch (selectedSurveyType) {
      case 'Calidad Académica':
        return _calidadData
            .map((survey) => survey.pregunta7Sugerencias)
            .where((suggestion) => suggestion.isNotEmpty)
            .toList();
      case 'Experiencia':
        return _experienciaData
            .map((survey) => survey.pregunta7Sugerencias)
            .where((suggestion) => suggestion.isNotEmpty)
            .toList();
      case 'Infraestructura':
        return _infraestructuraData
            .map((survey) => survey.pregunta7Sugerencias)
            .where((suggestion) => suggestion.isNotEmpty)
            .toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final calidadAvg = getAverageSatisfactionForCalidad();
    final experienciaAvg = getAverageSatisfactionForExperiencia();
    final infraestructuraAvg = getAverageSatisfactionForInfraestructura();

    final maxValue = [calidadAvg, experienciaAvg, infraestructuraAvg].reduce((a, b) => a > b ? a : b);

    final averages = getAveragesForSelectedSurvey();
    final labels = getQuestionLabels();
    final suggestions = getSuggestions();
    final answerDistribution = getAnswerDistribution(selectedQuestionIndex);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themePurple)),
              SizedBox(height: 16),
              Text('Cargando datos...', style: TextStyle(color: themePurple)),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Dashboards'),
          backgroundColor: themePurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboards'),
        backgroundColor: themePurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(8.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(1)),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Resumen de Satisfacción General',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      _buildBarItem('Calidad Académica', calidadAvg, maxValue, Colors.blueAccent),
                      const SizedBox(height: 15),
                      _buildBarItem('Experiencia Estudiantil', experienciaAvg, maxValue, Colors.pinkAccent),
                      const SizedBox(height: 15),
                      _buildBarItem('Infraestructura', infraestructuraAvg, maxValue, Colors.orangeAccent),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 20),
                      Text(
                        'Resumen por Categorías',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Filtrar:',
                            style: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(width: 20),
                          DropdownButton<String>(
                            value: selectedSurveyType,
                            items: const [
                              DropdownMenuItem(value: 'Calidad Académica', child: Text('Calidad Académica')),
                              DropdownMenuItem(value: 'Experiencia', child: Text('Experiencia Estudiantil')),
                              DropdownMenuItem(value: 'Infraestructura', child: Text('Infraestructura')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedSurveyType = value!;
                                selectedQuestionIndex = 0;
                              });
                            },
                          )
                        ],
                      ),
                                            
                      const SizedBox(height: 10),

                      Text(
                        'Desempeño por Categoría',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 300,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: RadarChart(
                          RadarChartData(
                            dataSets: [
                              RadarDataSet(
                                dataEntries: averages
                                    .sublist(0, 5)
                                    .map((avg) => RadarEntry(value: avg))
                                    .toList(),
                                fillColor: const Color.fromRGBO(187, 222, 251, 0.6),
                                borderColor: Colors.blueAccent,
                                borderWidth: 2,
                              ),
                            ],
                            radarShape: RadarShape.polygon,
                            radarBorderData: const BorderSide(color: Colors.grey, width: 1),
                            tickCount: 4,
                            ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                            tickBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                            radarTouchData: RadarTouchData(
                              touchCallback: (FlTouchEvent event, response) {
                                if (response != null && event is FlTapUpEvent) {
                                  setState(() {
                                    if(response.touchedSpot != null){
                                      selectedQuestionIndex = response.touchedSpot!.touchedRadarEntryIndex;
                                    }
                                  });
                                }
                              },
                            ),
                            titleTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
                            getTitle: (index, angle) {
                              return RadarChartTitle(
                                text: labels[index],
                                angle: angle,
                                positionPercentageOffset: 0.1,
                              );
                            },
                          ),
                          duration: Duration(milliseconds: 400),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      Text(
                        'Categoría: ${labels[selectedQuestionIndex]}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calificación promedio: ${averages[selectedQuestionIndex].toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: averages[selectedQuestionIndex] / 5,
                              backgroundColor: Colors.grey[300],
                              color: _getColorForValue(averages[selectedQuestionIndex]),
                              minHeight: 12,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getRatingText(averages[selectedQuestionIndex]),
                              style: TextStyle(
                                color: _getColorForValue(averages[selectedQuestionIndex]),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      Text(
                        'Distribución de respuestas:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 14),
                      ...answerDistribution.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(entry.key),
                              ),
                              Expanded(
                                flex: 3,
                                child: LinearProgressIndicator(
                                  value: entry.value / _calidadData.length,
                                  backgroundColor: Colors.grey[200],
                                  color: Colors.blueAccent,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${entry.value}'),
                            ],
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 20,),
                      Divider(),
                      SizedBox(height: 20),

                      Text(
                        'Sugerencias de los estudiantes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: suggestions.isEmpty
                            ? const Center(
                                child: Text('No hay sugerencias para esta categoría'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: const Icon(Icons.lightbulb_outline, color: Colors.amber),
                                      title: Text(suggestions[index]),
                                    ),
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 10,)
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarItem(String label, double value, double maxValue, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('${value.toStringAsFixed(2)}/5', 
                 style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 25,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Stack(
            children: [
              Container(
                width: (value / 5) * MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color
                ),
              ),
              Positioned(
                left: 8,
                top: 2,
                child: Text(
                  _getRatingText(value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorForValue(double value) {
    if (value < 2.0) return Colors.red;
    if (value < 3.0) return Colors.orange;
    if (value < 4.0) return Colors.yellow[700]!;
    return Colors.green.shade400;
  }

  String _getRatingText(double value) {
    if (value < 2.0) return 'Muy Insatisfecho';
    if (value < 3.0) return 'Insatisfecho';
    if (value < 4.0) return 'Neutral';
    if (value < 4.5) return 'Satisfecho';
    return 'Muy Satisfecho';
  }

}