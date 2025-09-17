// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/user_screen.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opina App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Map<String, dynamic>>(
        future: _checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data!['user'] != null) {
            final user = snapshot.data!['user'] as User;
            if (user.rol == 'ADMINISTRADOR') {
              return const AdminScreen();
            } else {
              return UserScreen(user: user);
            }
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _checkAuthStatus() async {
    // Aquí verificarías si hay un token guardado y validarlo
    // Por ahora, siempre retornamos un mapa vacío para ir al login
    return {'user': null};
  }
}