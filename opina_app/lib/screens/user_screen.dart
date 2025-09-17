// lib/screens/user_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_screen.dart'; // Importamos la pantalla de login

class UserScreen extends StatefulWidget {
  final User user;
  
  const UserScreen({super.key, required this.user});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  
  // Función para cerrar sesión
  void _logout() {
    // Aquí podrías agregar lógica para limpiar el token de autenticación
    // si estás usando shared_preferences o similar
    
    // Navegar de regreso a la pantalla de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50], // Fondo claro en rojo
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
        automaticallyImplyLeading: false, // Elimina el botón de retroceso por defecto
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título principal
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
                // Acción para Calidad Académica
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Botón 2: Infraestructura y Servicios
            ElevatedButton(
              onPressed: () {
                // Acción para Infraestructura y Servicios
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Botón 3: Experiencia y Apoyo al Estudiante
            ElevatedButton(
              onPressed: () {
                // Acción para Experiencia y Apoyo al Estudiante
              },
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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