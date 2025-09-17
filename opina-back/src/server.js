// Importación de módulos necesarios
import http from 'http';
import { Server } from 'socket.io';
import { app } from './app.js';
import 'dotenv/config';

// Puerto
const PORT = process.env.PORT || 3000;

// Crear servidor HTTP usando la app de Express
const server = http.createServer(app);

// Orígenes permitidos para CORS/WebSocket (desde .env)
const origins = (process.env.CORS_ORIGINS || '')
  .split(',')
  .map(s => s.trim())
  .filter(Boolean);

// Config Socket.IO (CORS)
const io = new Server(server, {
  cors: origins.length
    ? { origin: origins, methods: ['GET', 'POST'], credentials: true }
    : { origin: true,  methods: ['GET', 'POST'], credentials: true }, // dev por defecto
});

// Exponer io a la app si lo necesitas en rutas/servicios
app.set('io', io);

// Eventos de socket
io.on('connection', (socket) => {
  console.log('⚡ socket conectado:', socket.id);
  socket.on('disconnect', () => console.log('👋 socket fuera:', socket.id));
});

// Iniciar servidor: importante escuchar en 0.0.0.0 para LAN/ngrok/adb reverse
server.listen(PORT, '0.0.0.0', () => {
  const base = process.env.BASE_URL || `http://localhost:${PORT}`;
  console.log(`API lista en ${base}`);
  console.log(`Swagger UI en ${base}/api-docs`);
});
