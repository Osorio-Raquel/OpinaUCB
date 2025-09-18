// lib/screens/user_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

// 👇 imports nuevos/corregidos
import 'experiencia_form_screen.dart';
import '../services/experiencia_service.dart';
import '../services/token_store.dart';
import '../utils/constants.dart'; // 👈 usa la base URL central

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  // Función para cerrar sesión
  Future<void> _logout() async {
    await TokenStore.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _goToExperienciaForm() {
    // Usa la base URL centralizada (cámbiala con --dart-define en runtime si hace falta)
    // Para emulador Android: flutter run --dart-define=BACKEND_BASE=http://10.0.2.2:3000
    final expService = ExperienciaService(
      baseUrl: Constants.apiBaseUrl,
      getToken: TokenStore.get, // 👈 requerido por tu service
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExperienciaFormScreen(servicio: expService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text(
          'Bienvenido ${widget.user.nombre}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sistema de Encuestas UCB',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona el área que deseas evaluar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(137, 209, 4, 4),
              ),
            ),
            const SizedBox(height: 40),

            // Botón 1: Calidad Académica
            ElevatedButton(
              onPressed: () {
                // TODO: navegar a pantalla de Calidad Académica
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Calidad Académica',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón 2: Infraestructura y Servicios
            ElevatedButton(
              onPressed: () {
                // TODO: navegar a pantalla de Infraestructura y Servicios
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.business, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Infraestructura y Servicios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón 3: Experiencia y Apoyo al Estudiante
            ElevatedButton(
              onPressed: _goToExperienciaForm, // 👈 navegación al formulario
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Experiencia y Apoyo al Estudiante',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Información del usuario
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.red[200]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información de usuario:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Email: ${widget.user.correo}'),
                    Text('Rol: ${widget.user.rol}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botón de Cerrar Sesión
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
