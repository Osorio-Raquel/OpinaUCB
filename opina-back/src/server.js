// Importación de módulos necesarios
import http from 'http';
import { Server } from 'socket.io';
import { app } from './app.js';
import 'dotenv/config';

// Definición del puerto, usando variable de entorno o puerto 3000 por defecto
const PORT = process.env.PORT || 3000;

// Crear servidor HTTP usando la aplicación Express
const server = http.createServer(app);

// Configuración del servidor Socket.IO
const io = new Server(server, {
  cors: { 
    origin: '*', // Permitir conexiones desde cualquier origen (en producción debería ser más restrictivo)
    methods: ['GET', 'POST'] // Métodos HTTP permitidos para CORS
  }
});

// Opcional: exponer io para usarlo en rutas/servicios
// Esto permite acceder a la instancia de Socket.IO desde otras partes de la aplicación
app.set('io', io);

// Manejo de eventos de conexión de sockets
io.on('connection', (socket) => {
  console.log('⚡ socket conectado:', socket.id); // Log cuando un cliente se conecta
  
  // Evento que se dispara cuando un cliente se desconecta
  socket.on('disconnect', () => console.log('👋 socket fuera:', socket.id));
});

// Iniciar el servidor en el puerto especificado
server.listen(PORT, () => {
  console.log(`API lista en http://localhost:${PORT}`);
  console.log(`Swagger UI en http://localhost:${PORT}/api-docs`);
});