import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ComparisonChart extends StatelessWidget {
  final Map<String, Map<String, int>> satisfactionData;

  const ComparisonChart({
    super.key,
    required this.satisfactionData
  });

  @override
  Widget build(BuildContext context) {
    final satisfactionLevels = [
      'Muy satisfecho',
      'Satisfecho', 
      'Neutral',
      'Insatisfecho',
      'Muy insatisfecho'
    ];

    final surveyColors = {
      'Calidad Académica': Colors.blueAccent,
      'Experiencia': Colors.pinkAccent,
      'Infraestructura': Colors.orangeAccent,
    };

    final maxValue = _getMaxValue(satisfactionData);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                groupsSpace: 12,
                barGroups: _createBarGroups(satisfactionLevels, satisfactionData, surveyColors),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[400]!),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[300]!,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < satisfactionLevels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                satisfactionLevels[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                                maxLines: 2
                              ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(maxValue),
                      getTitlesWidget: (value, meta) {
                        // Only show integer values
                        if (value % 1 == 0) {
                          return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                        }
                        return const Text('');
                      },
                      reservedSize: 10,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(surveyColors),
        ],
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(
    List<String> levels,
    Map<String, Map<String, int>> data,
    Map<String, Color> colors,
  ) {
    final List<BarChartGroupData> barGroups = [];

    for (int levelIndex = 0; levelIndex < levels.length; levelIndex++) {
      final level = levels[levelIndex];
      final bars = <BarChartRodData>[];

      colors.forEach((surveyType, color) {
        final count = data[surveyType]?[level] ?? 0;
        bars.add(
          BarChartRodData(
            toY: count.toDouble(),
            width: 10,
            color: color,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxValue(data),
              color: Colors.grey[100],
            ),
          ),
        );
      });

      barGroups.add(
        BarChartGroupData(
          x: levelIndex,
          barRods: bars,
        ),
      );
    }

    return barGroups;
  }

  double _getMaxValue(Map<String, Map<String, int>> data) {
    double max = 0;
    data.forEach((surveyType, levels) {
      levels.forEach((level, count) {
        if (count > max) max = count.toDouble();
      });
    });
    return max * 1.1;
  }

  double _calculateInterval(double maxValue) {
    if (maxValue <= 10) return 2;
    if (maxValue <= 30) return 5;
    if (maxValue <= 100) return 10;
    if (maxValue <= 200) return 20;
    return 50;
  }

  Widget _buildLegend(Map<String, Color> colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: entry.value,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                entry.key,
                style: const TextStyle(fontSize: 12),
                
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}