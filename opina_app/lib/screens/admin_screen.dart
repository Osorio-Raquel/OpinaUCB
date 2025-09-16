import 'package:flutter/material.dart';
import '../widgets/survey_card.dart';
import 'login_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OPINA UCB'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Reconstruction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Upgrade:'),
            const Text('- 0.5V/1.2V'),
            const Text('- 0.5V/1.2V'),
            const Divider(height: 30),
            const Text('Pilot ID: Jr. v. w.'),
            const Divider(height: 30),
            const Text(
              'RESULTADOS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SurveyCard(
              title: 'Ghost Features',
              onTap: () {},
            ),
            SurveyCard(
              title: 'Requests / Key Service',
              onTap: () {},
            ),
            SurveyCard(
              title: 'Expenses / Input / Request',
              onTap: () {},
            ),
            const Divider(height: 30),
            const Text('Pilot ID: Jr. v. w.'),
            const Divider(height: 30),
            const Text('RECIPIENT:'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}