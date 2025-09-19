import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomPiechart extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final String title;
  final double chartHeight, chartWidth;
  final bool showLegend;
  final Map<String, double> data;

  const CustomPiechart({
    super.key,
    required this.sections,
    required this.data,
    this.title = '',
    this.chartHeight = 250,
    this.chartWidth = 100,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        if (title.isNotEmpty) const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 15),
            SizedBox(
              width: chartWidth,
              height: chartHeight,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: chartWidth * 0.2,
                  sectionsSpace: 2,
                  startDegreeOffset: -90,
                ),
              ),
            ),
            
            if (showLegend) const SizedBox(width: 20),
            
            // Legend
            if (showLegend)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.entries.map((entry) {
                    final section = sections[data.keys.toList().indexOf(entry.key)];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: section.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${entry.key} (${entry.value.round()}%)',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static List<PieChartSectionData> createSectionsFromMap(
    Map<String, double> data, {
    List<Color>? colors,
    double radius = 60,
  }) {
    final defaultColors = [
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.deepOrangeAccent,
      Colors.indigoAccent
    ];

    final List<PieChartSectionData> sections = [];
    int colorIndex = 0;

    data.forEach((label, value) {
      sections.add(
        PieChartSectionData(
          color: colors != null && colorIndex < colors.length
              ? colors[colorIndex]
              : defaultColors[colorIndex % defaultColors.length],
          value: value,
          title: '$value%',
          radius: radius,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return sections;
  }
}