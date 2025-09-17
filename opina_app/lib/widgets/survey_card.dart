import 'package:flutter/material.dart';

class SurveyCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SurveyCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}