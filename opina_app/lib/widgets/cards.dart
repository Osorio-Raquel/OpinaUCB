import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  final int totalSurveys;
  final int calidadSurveys;
  final int experienciaSurveys;
  final int infraestructuraSurveys;

  const Cards({
    super.key,
    required this.totalSurveys,
    required this.calidadSurveys,
    required this.experienciaSurveys,
    required this.infraestructuraSurveys,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTotalCard(),
          const SizedBox(width: 12),
          _buildSurveyTypeCard(
            title: 'Calidad Académica',
            count: calidadSurveys,
            icon: Icons.school,
            color: Colors.blueAccent,
            percentage: totalSurveys > 0 ? (calidadSurveys / totalSurveys * 100).round() : 0,
          ),
          const SizedBox(width: 12),
          _buildSurveyTypeCard(
            title: 'Experiencia',
            count: experienciaSurveys,
            icon: Icons.people,
            color: Colors.pinkAccent,
            percentage: totalSurveys > 0 ? (experienciaSurveys / totalSurveys * 100).round() : 0,
          ),
          const SizedBox(width: 12),
          _buildSurveyTypeCard(
            title: 'Infraestructura',
            count: infraestructuraSurveys,
            icon: Icons.business,
            color: Colors.orangeAccent,
            percentage: totalSurveys > 0 ? (infraestructuraSurveys / totalSurveys * 100).round() : 0,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Card(
      elevation: 3,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[700]!, Colors.blue[500]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              totalSurveys.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Encuestas',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyTypeCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required int percentage,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Respuestas',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 4),
            Text(
              '$percentage% del total',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}