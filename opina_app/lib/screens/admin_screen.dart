// lib/screens/admin_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importamos la pantalla de login

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  // Función para cerrar sesión y redirigir al login
  void _logout() {
    // Navegar de regreso a la pantalla de login (reemplaza la pila de navegación)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Simular datos que se actualizarán al deslizar
  int _surveyCount = 1245;
  bool _isRefreshing = false;

  // Función que se ejecuta al deslizar hacia abajo
  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    
    // Simular una operación de red o base de datos que tarda 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    
    // Actualizar los datos (en una app real, aquí harías una llamada API)
    setState(() {
      _surveyCount += 5; // Simular nuevos datos
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo gris claro
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Azul oscuro
        title: const Text(
          'Panel de Administración',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centrar el título
        iconTheme: const IconThemeData(color: Colors.white), // Color blanco para íconos
        automaticallyImplyLeading: false, // Elimina el botón de retroceso por defecto
        actions: [
          // Botón de notificaciones
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Acción para notificaciones
            },
          ),
          // Botón para cerrar sesión
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout, // Conectado a la función de cerrar sesión
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Función que se ejecuta al deslizar
        color: Colors.blue[900], // Color del indicador de carga
        backgroundColor: Colors.white, // Fondo del indicador
        displacement: 40, // Distancia desde la parte superior
        edgeOffset: 0, // Desplazamiento desde el borde superior
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Espaciado alrededor del contenido
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinear contenido a la izquierda
            children: [
              // Título de bienvenida
              const Text(
                'Bienvenido Administrador',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 13, 95, 219),
                ),
              ),
              const SizedBox(height: 8), // Espaciado
              // Subtítulo descriptivo
              const Text(
                'Gestiona las encuestas y visualiza los resultados',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30), // Espaciado
              
              // Grid de botones principales con 2 columnas
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // 2 columnas
                  crossAxisSpacing: 20, // Espaciado horizontal entre elementos
                  mainAxisSpacing: 20, // Espaciado vertical entre elementos
                  childAspectRatio: 1.2, // Relación aspecto ancho/alto
                  children: [
                    // Botón 1: Calidad Académica
                    _buildAdminButton(
                      title: 'Calidad Académica',
                      icon: Icons.school,
                      color: Colors.blue[700]!,
                      onTap: () {
                        // Acción para Calidad Académica
                      },
                    ),
                    
                    // Botón 2: Infraestructura y Servicios
                    _buildAdminButton(
                      title: 'Infraestructura y Servicios',
                      icon: Icons.business_center,
                      color: Colors.green[700]!,
                      onTap: () {
                        // Acción para Infraestructura y Servicios
                      },
                    ),
                    
                    // Botón 3: Experiencia y Apoyo al Estudiante
                    _buildAdminButton(
                      title: 'Experiencia y Apoyo',
                      icon: Icons.people,
                      color: Colors.orange[700]!,
                      onTap: () {
                        // Acción para Experiencia y Apoyo al Estudiante
                      },
                    ),
                    
                    // Botón 4: Dashboard
                    _buildAdminButton(
                      title: 'Dashboard',
                      icon: Icons.bar_chart,
                      color: Colors.purple[700]!,
                      onTap: () {
                        // Acción para Dashboard
                      },
                    ),
                  ],
                ),
              ),
              
              // Tarjeta de estadísticas rápidas (solo Encuestas Totales)
              Card(
                elevation: 4, // Sombra
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // Espaciado uniforme
                    children: [
                      _buildStatItem('Encuestas Totales', '$_surveyCount', Icons.assignment),
                    ],
                  ),
                ),
              ),
              
              // Indicador de carga cuando se está actualizando
              if (_isRefreshing)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // Drawer lateral derecho (menú deslizable)
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Sin padding
          children: [
            // Encabezado del drawer con información del usuario
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[900], // Fondo azul oscuro
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Administrador',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'admin@ucb.edu',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Opción de Inicio
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Cerrar el drawer
              },
            ),
            // Opción de Configuración
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context); // Cerrar el drawer
              },
            ),
            const Divider(), // Línea divisoria
            // Opción de Cerrar Sesión
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: _logout, // Función de cerrar sesión
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir botones del panel de administración
  Widget _buildAdminButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4, // Sombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      child: InkWell(
        onTap: onTap, // Acción al hacer tap
        borderRadius: BorderRadius.circular(12), // Bordes redondeados para el efecto de tap
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
            color: color, // Color de fondo
          ),
          padding: const EdgeInsets.all(16), // Espaciado interno
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrar contenido verticalmente
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white, // Ícono blanco
              ),
              const SizedBox(height: 10), // Espaciado
              Text(
                title,
                textAlign: TextAlign.center, // Texto centrado
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método auxiliar para construir ítems de estadísticas
  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.blue[700], // Color azul para el ícono
          size: 30,
        ),
        const SizedBox(height: 8), // Espaciado
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900], // Color azul oscuro para el valor
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey, // Color gris para el título
          ),
        ),
      ],
    );
  }
}