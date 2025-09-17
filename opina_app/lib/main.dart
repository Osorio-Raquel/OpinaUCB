// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/user_screen.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() {
  runApp(const MyApp()); // Punto de entrada de la aplicación Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opina App', // Nombre de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema principal azul
      ),
      // FutureBuilder para determinar la pantalla inicial basada en el estado de autenticación
      home: FutureBuilder<Map<String, dynamic>>(
        future: _checkAuthStatus(), // Futuro que verifica el estado de autenticación
        builder: (context, snapshot) {
          // Mientras se espera la respuesta, mostrar un indicador de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } 
          // Si hay datos y el usuario está autenticado, redirigir a la pantalla correspondiente
          else if (snapshot.hasData && snapshot.data!['user'] != null) {
            final user = snapshot.data!['user'] as User;
            // Verificar el rol del usuario para determinar a qué pantalla dirigirlo
            if (user.rol == 'ADMINISTRADOR') {
              return const AdminScreen(); // Pantalla de administrador
            } else {
              return UserScreen(user: user); // Pantalla de usuario regular
            }
          } 
          // Si no hay usuario autenticado, mostrar la pantalla de login
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  /// Función que verifica el estado de autenticación del usuario
  /// Actualmente retorna un mapa vacío (usuario no autenticado)
  /// En una implementación real, aquí se verificaría si hay un token guardado
  Future<Map<String, dynamic>> _checkAuthStatus() async {
    // Aquí verificarías si hay un token guardado y validarlo
    // Por ejemplo, usando SharedPreferences o un servicio de autenticación
    // Por ahora, siempre retornamos un mapa vacío para ir al login
    return {'user': null};
  }
}