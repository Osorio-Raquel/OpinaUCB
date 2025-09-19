// lib/screens/user_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

// ========= Formularios existentes =========
import 'experiencia_form_screen.dart';
import '../services/experiencia_service.dart';

// ========= NUEVOS: Calidad Académica =========
import 'calidad_academica_form_screen.dart';
import '../services/calidad_academica_service.dart';

// ========= NUEVOS: Infraestructura =========
import 'infraestructura_form_screen.dart';
import '../services/infraestructura_service.dart';

import '../services/token_store.dart';
import '../utils/constants.dart'; // base URL centralizada

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _colorAnimation =
        ColorTween(
          begin: const Color(0xFFB71C1C),
          end: const Color(0xFFD32F2F),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ===== Navegaciones =====
  void _goToCalidadAcademicaForm() {
    final service = CalidadAcademicaService(
      baseUrl: Constants.apiBaseUrl,
      getToken: TokenStore.get,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            CalidadAcademicaFormScreen(servicio: service),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _goToInfraestructuraForm() {
    final infraService = InfraestructuraService(
      baseUrl: Constants.apiBaseUrl,
      getToken: TokenStore.get,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            InfraestructuraFormScreen(servicio: infraService),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _goToExperienciaForm() {
    final expService = ExperienciaService(
      baseUrl: Constants.apiBaseUrl,
      getToken: TokenStore.get,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            ExperienciaFormScreen(servicio: expService),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ===== Logout =====
  Future<void> _logout() async {
    await TokenStore.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD32F2F),
          title: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Text(
                'Bienvenido ${widget.user.nombre}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            },
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
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
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecciona el área que deseas evaluar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),

                  // Botón 1: Calidad Académica
                  _buildMenuButton(
                    title: 'Calidad Académica',
                    icon: Icons.school,
                    color: const Color(0xFFD32F2F),
                    onPressed: _goToCalidadAcademicaForm,
                  ),
                  const SizedBox(height: 20),

                  // Botón 2: Infraestructura y Servicios
                  _buildMenuButton(
                    title: 'Infraestructura y Servicios',
                    icon: Icons.business,
                    color: const Color(0xFFC2185B),
                    onPressed: _goToInfraestructuraForm,
                  ),
                  const SizedBox(height: 20),

                  // Botón 3: Experiencia y Apoyo al Estudiante
                  _buildMenuButton(
                    title: 'Experiencia y Apoyo al Estudiante',
                    icon: Icons.people,
                    color: const Color(0xFF7B1FA2),
                    onPressed: _goToExperienciaForm,
                  ),
                  const SizedBox(height: 40),

                  // Información del usuario
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información de usuario:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD32F2F),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildUserInfoItem(
                            Icons.email,
                            'Email: ${widget.user.correo}',
                          ),
                          const SizedBox(height: 8),
                          _buildUserInfoItem(
                            Icons.person,
                            'Rol: ${widget.user.rol}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botón de Cerrar Sesión
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[800]!.withOpacity(0.8),
                    child: InkWell(
                      onTap: _logout,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, size: 20, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, Color.lerp(color, Colors.black, 0.2)!],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.white),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFD32F2F)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
